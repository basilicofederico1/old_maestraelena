//app state variable
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../Calendar/calendar.dart';

//TEMP STATE
//agenda page debug
bool agendaPageDebug = false; //true is "show agenda page"

//APP OFF
late Map appState;
bool devStateActive = false;
bool devCheckEnded = false;
bool appStateFirstLaunch = true;

//CALENDAR SETUP
DateTime now = DateTime.now();

void keepNowRefreshed() async {
  bool start = true;
  while (start) {
    now = DateTime.now();
    await Future.delayed(const Duration(minutes: 1));
  }
}

DateTime fromDate = DateTime(2010, 1, 1, 0, 0, 0);
DateTime toDate = DateTime(2030, 31, 12, 23, 59, 59);
Calendar calendar = Calendar(fromDate, toDate);

//this one continuously check for internet connection changes
bool online = false;

//main posts list (recent posts list)
late Future<dynamic> postLibrary;

//true when the first 10 post were downloaded
bool postInitialized = false;
//true when recognize that something goes wrong downloading first 10 post
bool postInitializedTrigger = false;
bool postInitializedSuccesfullTrigger = false;

//this one become true when Firebase.initializeApp is called
bool firebaseInitialized = false;

//this for initializing products
late Map products;

//Internet Watchdog
class InternetWatchdog {
  StreamSubscription<ConnectivityResult>? _subscription;

  void start() {
    //print('Starting internet watchdog...');
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void stop() {
    //print('Stopping internet watchdog...');
    _subscription?.cancel();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      online = false;
      //print('No internet connection!');
    } else {
      online = true;
      //print('Internet connection detected!');
    }
  }
}
