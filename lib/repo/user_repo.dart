import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:safe_return/models/enforcer_profile_model.dart';
import 'package:safe_return/models/user_data.dart';
import 'package:safe_return/utils/custom_methods.dart';

class UserRepo {
  Future<String> registerUser(
    String name,
    String ic,
    String email,
    String userId,
    String password,
    String occupation,
    String state,
    String city,
    String contactNumber,
    List docs,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'ic': ic,
        'email': email,
        'userId': userId,
        'occupation': occupation,
        'state': state,
        'city': city,
        'contactNumber': contactNumber,
        'userType': "public",
        "status": false,
        "uId": user.uid,
        "docs": docs,
      });
      return "Registration successful!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception(e.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> loginUser({
    required String email,
    required String password,
    String? userId,
    String? userType,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userType == "public") {
        final user = credential.user;
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        final userDocData = docSnapshot.data();

        if (userDocData!['userId'] == userId) {
          return credential;
        } else {
          throw Exception('Invalid user ID or password.');
        }
      } else {
        return credential;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == '"invalid-credential"') {
        throw Exception('invalid credentials');
      }
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception(e.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> getUserAttrData(String attr) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.data() != null) {
        final userData = docSnapshot.data() as Map<String, dynamic>;

        final userType = userData[attr] as String;
        return userType;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<bool?> getUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.data() != null) {
        final userData = docSnapshot.data() as Map<String, dynamic>;

        final userType = userData["status"];
        return userType;
      } else {
        return null;
      }
    }
    return null;
  }

  static Future<UserData> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final userDataMap = docSnapshot.data() as Map<String, dynamic>;
    UserData userData = UserData.fromMap(userDataMap);

    return userData;
  }

  static Future<EnforcerProfileModel> getEnforcerData() async {
    final user = FirebaseAuth.instance.currentUser;
    final docSnapshot = await FirebaseFirestore.instance
        .collection('enforcer')
        .doc(user!.uid)
        .get();
    final userDataMap = docSnapshot.data() as Map<String, dynamic>;
    EnforcerProfileModel userData = EnforcerProfileModel.fromMap(userDataMap);

    return userData;
  }

  Future<String> updateUser({
    required String userId,
    required String name,
    required String email,
    required String ic,
    required String occupation,
    required String state,
    required String city,
    required String contactNumber,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': name,
        'ic': ic,
        'occupation': occupation,
        'state': state,
        'city': city,
        'contactNumber': contactNumber,
      });
      return "User data updated successfully!";
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateUserData(Map<String, dynamic> requestData) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update(requestData);
      return "User data updated successfully!";
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
        return 'Password updated successfully!';
      } else {
        throw Exception('No user logged in!');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The new password is too weak.');
      } else if (e.code == 'wrong-password') {
        throw Exception('The current password is incorrect.');
      } else {
        throw Exception(e.message.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadFiles(
      List<String> paths, String folderName) async {
    List<String> urls = [];
    for (var path in paths) {
      String fileName = getFileName(path);
      final file = File(path);
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('case_files/$folderName/$fileName');
      try {
        var uploadTask = await reference.putFile(file);
        final fileUrl = await uploadTask.ref.getDownloadURL();
        urls.add(fileUrl);
      } catch (error) {
        rethrow;
      }
    }
    return urls;
  }

  Future<String> createNewCase(Map<String, dynamic> requestData) async {
    try {
      final caseCollections = FirebaseFirestore.instance.collection('cases');
      await caseCollections.add(requestData);
      return "Case Created";
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFilteredCases(
      {String? name, String? age, String? state}) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    final casesCollection = FirebaseFirestore.instance.collection('cases');

    if (name != null && name.isNotEmpty) {
      Query<Map<String, dynamic>> query = casesCollection;

      if (name.isNotEmpty) {
        query = query.where(
          'name',
          isEqualTo: name.toLowerCase(),
        );
      }
      if (age!.isNotEmpty) {
        query = query.where('age', isEqualTo: age);
      }
      if (state!.isNotEmpty) {
        query = query.where('state', isEqualTo: state.toLowerCase());
      }

      snapshot = await query.get();
    } else {
      snapshot = await casesCollection.get();
    }
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUnverifiedUsers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    final casesCollection = FirebaseFirestore.instance.collection('users');
    Query<Map<String, dynamic>> query =
        casesCollection.where("status", isEqualTo: false);
    snapshot = await query.get();

    return snapshot;
  }

  Future<String> changeVerifiedStatus({
    required bool status,
    required String userId,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> userObj =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userObj.update({'status': status});
      if (status) {
        return "Verified";
      } else {
        return "Rejected";
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addEnforcersToCases(String enforcerId, String caseId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    QuerySnapshot querySnapshot = await firestore
        .collection('cases')
        .where("caseId", isEqualTo: caseId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference caseRef = querySnapshot.docs[0].reference;

      batch.update(caseRef, {
        'enforcers': FieldValue.arrayUnion([enforcerId]),
      });

      await batch.commit();
    } else {
      throw Exception("No document found with caseId: $caseId");
    }
  }
}
