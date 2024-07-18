import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<void> getPermission() async {
    await _pushNotification.requestPermission();
  }

  static Future<String?> getToken() {
    return _pushNotification.getToken();
  }

  static void sendNotificationMessage(String title) async {
    await Future.delayed(Duration(seconds: 5));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    print(client.credentials.accessToken);

    final notificationData = {
      'message': {
        'token': 'ci5pRcdaQxahKi2bon-Vy7:APA91bGhKERjuuKLAJej1Qttwt2T5hxhiQf07bQKLI9D4V6qsLcVq79H6zZXeH2VHHEjplTu_qvpj02mVAPSaM8RKKxyHjN5NTvMib0bb0pM7IJt90H8GKUrIFoGucrcDkboiprP_LGy',
        'notification': {
          'title': "Muhammaddan xabar",
          'body': "Uuuuu qayerdasan?",
        }
      },
    };

    const projectId = "my-push-notification-app-2552";
    Uri url = Uri.parse("https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }
  }
}
