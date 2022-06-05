import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
final _alarmController = TextEditingController();
final _alarm_min_Controller = TextEditingController();

//
// String top() {
//
// }


class alarmPage extends StatefulWidget {
  const alarmPage({Key? key}) : super(key: key);

  @override
  State<alarmPage> createState() => _alarmPageState();
}

class _alarmPageState extends State<alarmPage> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


//앱 아이콘의 뱃지를 초기화 - 앱이 foreground 상태가 될대 뱃지를 초기화
//1
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _init();
  }
//2
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
//3
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }


  //flutter_local_notification 초기화 -> 특정시간에 표시하기 위해
  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  //현재 시간 등록하기
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }
//  ios 권한요청 - 미리 초기화
  Future<void> _initializeNotification() async {
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

//메세지 등록 취소 - 새로운 메시지 등록 - 이전메시지 취소
  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

//권한요청
  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  //메세지 등록

  Future<void> _registerMessage({
    required int hour,
    required int minutes,
    required message,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'YoriJori',
      message,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
          //앱을 실행하면 메세지가 사라짐
          ongoing: true,
          styleInformation: BigTextStyleInformation(message),
          icon: 'ic_notification',
        ),
        iOS: const IOSNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    var hour=0;
    var min=0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 시간 설정'),
      ),
      body: Column(
        children: [

          // Row(
          //   children: [
          //     Expanded(
          //       child: Row(
          //         children: [
          //           TextField(
          //             controller: _alarmController,
          //             decoration: const InputDecoration(
          //               filled: true,
          //               fillColor: Color(0xFFFBF7F7),
          //               labelText: '알람시간을 입력하세요 ',
          //               border: OutlineInputBorder(),
          //             ),
          //
          //           ),
          //           TextField(
          //             controller: _alarmController,
          //             decoration: const InputDecoration(
          //               filled: true,
          //               fillColor: Color(0xFFFBF7F7),
          //               labelText: '알람시간을 입력하세요 ',
          //               border: OutlineInputBorder(),
          //             ),
          //
          //           ),
          //         ],
          //       ),
          //     )
          //
          //   ],
          //
          // ),



          Container(
             // flex :6,
              padding: EdgeInsets.all(30),

              child:

              Row(
                children: [

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        //labelText: '시간',
                        hintText: '시간을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      controller: _alarmController,
                      // validator: (value) {
                      //   if (value.isEmpty) return 'Please enter a valid first name.';
                      //   return null;
                      // },
                    ),
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:10,
                      child:  Text(':')),
                  SizedBox(width: 5,),
                  // Icon
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        //labelText: '분',
                        hintText: '분을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      controller: _alarm_min_Controller,
                      // validator: (value) {
                      //   if (value.length < 1) return 'Please enter a valid last name.';
                      //   return null;
                      // },
                    ),
                  ),
                  // SizedBox(
                  //     width:30,
                  //     child:  Text('분')),
                ],
              )




          ),



          ElevatedButton(
            onPressed: () async {
             // print ('나는');
              hour = int.parse(_alarmController.text);
              min = int.parse(_alarm_min_Controller.text);
              //print(n);

              await _cancelNotification();
              await _requestPermissions();

              final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
              print("heyehy");
              print(now.hour);
              await _registerMessage(
                hour: hour,
                minutes: min,
                message: 'yorijori  top 3의 주인공을 확인해보세요 . !',
              );
            },
            child: const Text('저장하기'),
          ),
        ],
        // child: ElevatedButton(
        //   onPressed: () async {
        //     await _cancelNotification();
        //     await _requestPermissions();
        //
        //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
        //     print("heyehy");
        //     print(now.hour);
        //     await _registerMessage(
        //       hour: now.hour,
        //       minutes: now.minute + 1,
        //       message: 'Hello, world',
        //     );
        //   },
        //   child: const Text('Show Notification'),
        // ),
      ),
    );
  }
}

