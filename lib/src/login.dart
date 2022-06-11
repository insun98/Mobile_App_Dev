
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import '../Provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Provider/PostProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //알람기능 추가

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
    //여기서 - 바뀌는거 감지하면 - if - notification 에서 notifier 하면 이때 시간 -
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
      'yorijori_본인확인',
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
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ApplicationState authProvider= Provider.of<ApplicationState>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 120.0),
            Column(
              children: const <Widget>[
                Text('Yori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
                Text('Jori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
              ],
            ),
            const SizedBox(height: 30.0),
            // TODO: Remove filled: true values (103)
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('로그인'),
              style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
              onPressed: () async {
                bool? login = await authProvider.verifyEmail(_usernameController.text, (e) => _showErrorDialog(context, 'Invalid email', e));

                if(login == true){
                  print(_passwordController);
                  authProvider.signInWithEmailAndPassword(_usernameController.text, _passwordController.text,(e) => _showErrorDialog(context, 'Invalid email', e));
                  postProvider.getTypePost('양식');
                  Navigator.pushNamed(context, '/logo');
                }else{
                  print("false");
                }


                await _cancelNotification();
                await _requestPermissions();

                final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                await _registerMessage(
                  hour: now.hour,
                  minutes: now.minute + 1,
                  message: _usernameController.text+'계정으로 로그인이 되었습니다 . '
                      +"\n"+'본인이 아닐경우 로그아웃 하세요 .',
                );
                _usernameController.clear();
                _passwordController.clear();

              },
            ),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {Navigator.pushNamed(context, '/signup');},
                  child: Text('회원가입'),
                  style: TextButton.styleFrom(primary: Color(0xFF7B7877)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

