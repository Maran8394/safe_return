// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_return/repo/user_repo.dart';

import 'package:safe_return/screens/auth_page.dart';
import 'package:safe_return/screens/enforcer_dashboard.dart';
import 'package:safe_return/screens/public_dashboard.dart';
import 'package:safe_return/screens/view_case.dart';
import 'package:safe_return/widgets/constant_widgets.dart';

class IndexingPage extends StatefulWidget {
  int? index;
  IndexingPage({
    super.key,
    this.index,
  });

  @override
  State<IndexingPage> createState() => _IndexingPageState();
}

class _IndexingPageState extends State<IndexingPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[];
  late StreamSubscription<User?> _userStreamSubscription;
  bool isFirstLaunch = true;

  @override
  void initState() {
    super.initState();

    if (widget.index != null) {
      setState(() {
        _selectedIndex = widget.index!;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }
    _userStreamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _handleUserLoggedIn(user);
      } else {
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
    _widgetOptions.addAll([
      const ViewCase(),
      const AuthPage(),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamSubscription.cancel();
  }

  void _handleUserLoggedIn(User user) async {
    UserRepo userRepo = UserRepo();
    final String? role = await userRepo.getUserAttrData("userType");
    if (role != null) {
      switch (role) {
        case 'public':
          _widgetOptions.last = const PublicDashboard();
          break;
        case 'enforcer':
          _widgetOptions.last = const EnforcerDashboard();
          break;
        default:
          break;
      }
    } else {
      _widgetOptions.last = const EnforcerDashboard();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.blue,
        selectedIconTheme: const IconThemeData(color: Colors.orange),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: ConstantWidgets.bottomNavItems(),
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
