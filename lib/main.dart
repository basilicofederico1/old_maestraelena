import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maestraelena_app/Pages/splash.dart';
import 'package:maestraelena_app/Theme/app_style.dart';
import 'package:maestraelena_app/wp_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Pages/agenda_page.dart';
import 'State/app_state.dart';
import 'firebase_options.dart';

/*
  TO DO (order by priorities)
  - Handle notification tap (open the post)
  - Handle in app notification (banner at the top that tell about a new post!)
  - Send notification at the very first start, so people can agree for the notification
    permission.
    -> MAYBE: create a topic first start, manage from here to send a notification,
       unsubscribe from topic.
    -> ALTERNATIVE send notification to specific device using token
    -> BETTER: something that ask permission at the first start
  - create Android APK and send it to about 20 people to check if everything is fine
  - IoS testing and integration
  - OPTZ back on top when switching category in StorePage

  COOL STUFF I WANT IN THE APP
  - Server app to handle Notification, Store and Messagging

  TO DO FUTURE FEATURES
  - Agenda digitale
  - Improve user experience (comments, likes, ...)
  - Login + Profile + Newsletter
  - Interaction between users? 
  - Personalized in app ads
*/

int devicebuild = 1; //0 stands for ANDROID; 1 stands for IOS

bool desktopTesting = false;

Future<void> main() async {
  if (!desktopTesting) {
    WidgetsFlutterBinding.ensureInitialized();
    InternetWatchdog().start();
    keepNowRefreshed();

    if (devicebuild == 1) {
      online = true;
    }

    //load posts for the first time
    postLibrary = getLatestNumPosts(10, 1, websiteUrl);

    //set orientation lock as portrait and run App
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) => runApp(const MyApp()));
  } else {
    runApp(const MyAppDesktopTesting());
  }
}

//background notification
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //handle with background notification message
  //print("Handling a background message: ${message.messageId}");
}

void initializeFirebaseWhenOnline() async {
  while (!online) {
    await Future.delayed(const Duration(seconds: 1));
  }
  // Initialize when online...
  //FIREBASE

  //Initialize
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  //Notifications
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  messaging.subscribeToTopic('All');
  messaging.subscribeToTopic('TestIOS');

  //app state utility
  final utilityReference = FirebaseStorage.instance
      .refFromURL("gs://maestraelenaapp.appspot.com/utility/app_state.txt");
  Uint8List? downloadedState = await utilityReference.getData();
  const utf8decoderState = Utf8Decoder(allowMalformed: true);
  String stateString = utf8decoderState.convert(downloadedState!);
  appState = jsonDecode(stateString);
  for (int i = 0; i < appState["developing_state"].length; i++) {
    if (appState["developing_state"][i]["name"] == "dev_state_active") {
      devStateActive = appState["developing_state"][i]["state"];
    }
  }
  devCheckEnded = true;

  //Store
  final productReference = FirebaseStorage.instance
      .refFromURL("gs://maestraelenaapp.appspot.com/store/product.txt");
  Uint8List? downloadedData = await productReference.getData();
  const utf8decoder = Utf8Decoder(allowMalformed: true);
  String productString = utf8decoder.convert(downloadedData!);
  products = jsonDecode(productString);
  for (int i = 0; i < products["products"].length; i++) {
    var imageUrl = await FirebaseStorage.instance
        .ref()
        .child("store/${products["products"][i]["image"]}")
        .getDownloadURL();
    products["products"][i]["imageUrl"] = imageUrl;
  }

  //Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  //throw Exception("Crashlytics test");

  firebaseInitialized = true;
}

void postWatchdogInitialization() async {
  while (!postInitialized) {
    if (postInitializedTrigger) {
      postLibrary = getLatestNumPosts(10, 1, websiteUrl);
      postInitializedTrigger = false;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

//launch APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    initializeFirebaseWhenOnline();
    postWatchdogInitialization();
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}

//alternative for desktop testing
class MyAppDesktopTesting extends StatelessWidget {
  const MyAppDesktopTesting({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: AgendaPage(),
    );
  }
}

//this function to get the unique device token
Future getDeviceToken() async {
  FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
  String? deviceToken = await firebaseMessage.getToken();
  //print("##### DEVICE TOKEN ######");
  //print("##### $deviceToken #####");
  return (deviceToken == null) ? "" : deviceToken;
}
