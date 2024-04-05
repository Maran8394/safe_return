import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_return/paths/asset_paths.dart';
import 'package:safe_return/utils/enums/state_enums.dart';

class ConstantWidgets {
  static List<BottomNavigationBarItem> bottomNavItems() => [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            size: 30,
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'Profile',
        ),
      ];

  static Future showAlert(context, message, StateType stateType) {
    String? showIcon;
    if (stateType == StateType.success) {
      showIcon = AssetPath.successIcon;
    } else if (stateType == StateType.warning) {
      showIcon = AssetPath.warningIcon;
    } else {
      showIcon = AssetPath.failedIcon;
    }
    return showDialog(
      barrierDismissible: true,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 100),
          icon: SvgPicture.asset(
            showIcon!,
            height: MediaQuery.of(context).size.height / 14,
            width: MediaQuery.of(context).size.width / 10,
          ),
          title: Center(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          titlePadding: const EdgeInsets.only(
            top: 0,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          actionsAlignment: MainAxisAlignment.center,
          // actions: [
          //   TextButton(
          //     child: const Text("OK"),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ],
        );
      },
    );
  }
}
