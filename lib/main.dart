import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/cubits/enforcers/enforcer_cubit.dart';
import 'package:safe_return/cubits/postCode/post_code_cubit.dart';
import 'package:safe_return/firebase_options.dart';
import 'package:safe_return/paths/route_generator.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/screens/indexing_page.dart';
import 'package:safe_return/utils/services/pushnotification_services.dart';

Future<bool> requestNotificationPermission() async {
  final status = await Permission.notification.request();

  if (status.isGranted) {
    return true;
  } else {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().setupInteractedMessage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RouteGenerator _router = RouteGenerator();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PublicBloc(),
        ),
        BlocProvider(
          create: (context) => EnforcerBloc(),
        ),
        BlocProvider(
          create: (context) => PostCodeCubit(),
        ),
        BlocProvider(
          create: (context) => EnforcerCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Safe Return',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: IndexingPage(),
        onGenerateRoute: _router.generateRoute,
        initialRoute: Routes.indexPage,
      ),
    );
  }
}
