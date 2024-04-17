import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_code_state.dart';

class PostCodeCubit extends Cubit<PostCodeState> {
  PostCodeCubit() : super(PostCodeInitial());

  Future<void> fetchPostCodes({String? val}) async {
    try {
      if (val == null) {
        emit(PostCodeInitialState());
      }

      Query query = FirebaseFirestore.instance.collection('post_code').limit(5);

      if (val != null) {
        query = query
            .where('postcode', isGreaterThanOrEqualTo: val)
            .where('postcode', isLessThan: '${val}z');
      }
      QuerySnapshot querySnapshot = await query.get();

      List<String> tempZipCodeOptions = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String postCode = data['postcode'];
          tempZipCodeOptions.add(postCode);
        }
      }

      emit(PostCodeSuccessState(codes: tempZipCodeOptions));
    } catch (e) {
      emit(PostCodeFailedState(message: "Failed to fetch zip codes"));
    }
  }
}
