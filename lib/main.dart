import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/firebase_options.dart';
import 'package:safe_return/paths/route_generator.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/screens/indexing_page.dart';
import 'package:safe_return/utils/custom_methods.dart';
import 'package:safe_return/utils/services/pushnotification_services.dart';

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
  await sendPushMessage(
    "cRBid4nyQdWWnN4dmIgMTL:APA91bF0KRArQ26m3kBoIa7lrNp6t2S8BGiUPRhL9sOvVJapfZJERnqEidZdYQSppQEQaHfLX8plrXlqjHCwi8whhyZeGMpUdkXbm7CKd-K9SWdw74EmQ_90o2oJaJZQis9kCkeFEYhf",
  );
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
