import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'enforcer_state.dart';

class EnforcerCubit extends Cubit<EnforcerCubitState> {
  EnforcerCubit() : super(EnforcerInitial());

  Future<void> fetchStaff({String? val}) async {
    try {
      if (val == null) {
        emit(GetEnforcerInitialState());
      }

      Query query = FirebaseFirestore.instance.collection('enforcer').limit(5);

      if (val != null) {
        query = query
            .where('name', isGreaterThanOrEqualTo: val)
            .where('name', isLessThan: '${val}z');
      }
      QuerySnapshot querySnapshot = await query.get();

      List<String> tempZipCodeOptions = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String postCode = data['name'];
          tempZipCodeOptions.add(postCode);
        }
      }

      emit(GetEnforcerSuccessState(codes: tempZipCodeOptions));
    } catch (e) {
      emit(GetEnforcerFailedState(message: "Failed to fetch staff"));
    }
  }
}
