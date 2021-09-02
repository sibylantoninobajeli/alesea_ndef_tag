import 'dart:developer';
import 'package:vibration/vibration.dart';

InternalPushNotificationListenerProviderSingleton
internalPushNotificationProvider =
InternalPushNotificationListenerProviderSingleton.internal();


enum InternalNotificationType{
  FIRST_ACCESS_FALSE,
  LOGGED_IN,
  LOGGED_IN_AND_PRIVACY,
  LOGGED_OUT,
  VERIFING,
  START_READING,
  STOP_READING,
  ROLES_NEED_RELOAD,
  SELECTED_ROLE_CHANGED
}


abstract class InternalNotificationListener {
  void onInternalNotification(InternalNotificationType type, Map<int,String>? mex);
}

// An implementation of Observer/Subscriber Pattern.
class InternalPushNotificationListenerProviderSingleton {
  static final InternalPushNotificationListenerProviderSingleton _instance = new InternalPushNotificationListenerProviderSingleton.internal();

  factory InternalPushNotificationListenerProviderSingleton() => _instance;

  InternalPushNotificationListenerProviderSingleton.internal() {
    log(runtimeType.toString()+" :: InternalPushNotificationListenerProviderSingleton.internal Start");
    initState();
    _subscribers = [];
    log(runtimeType.toString()+" :: InternalPushNotificationListenerProviderSingleton.internal Completed");
  }


  List<InternalNotificationListener> _subscribers=[];

  bool _canVibrate = true;
  void initState() async {
    _canVibrate = (await Vibration.hasVibrator())!;

    log(runtimeType.toString()+" :: initState Start");
    log(runtimeType.toString()+" :: initState Completed");
  }

  void unsubscribe(InternalNotificationListener listener) {
    final String _methodName="unsubscribe";
    _subscribers.remove(listener);
    log(runtimeType.toString()+" ::"+_methodName  +" Completed");
  }

  void subscribe(InternalNotificationListener listener) {
    log(runtimeType.toString()+" :: subscribe ");
    _subscribers.add(listener);
  }

  void dispose(InternalNotificationListener listener) {
    log(runtimeType.toString()+" :: dispose ");
    for(var l in _subscribers) {
      if(l == listener)
        _subscribers.remove(l);
    }
  }

  Future<void> notifyNewInternalPush(InternalNotificationType type,Map<int, String>? mex) async {
    if (_canVibrate) {
      Vibration.vibrate(duration: 50, amplitude: 1);
      // Vibraion.vibrate(pattern: [100, 800, 50, 1000], intensities: [255, 1,255,1]);
    }
    log(runtimeType.toString()+" :: notifyNewInternalPush ");
    _subscribers.forEach((InternalNotificationListener s) => s.onInternalNotification(type,mex));
  }


}