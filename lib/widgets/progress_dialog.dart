import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressDialog {
  BuildContext context;

  ProgressDialog(this.context);

  void showAlertDialog(Color color, {String? message}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: true,
      // barrierColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0.4, // Controls the thickness of the shadow
                  blurRadius: 5.0, // Controls the blurriness of the shadow
                  offset: const Offset(
                    1,
                    1,
                  ),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: SpinKitCircle(
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }

  dimissDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
