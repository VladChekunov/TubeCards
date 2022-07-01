import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens an email app with a given template email.
///
/// The template email has [email] as destination address, [subject] as
/// subject and body as body.
///
/// Throws an [Exception] if the email app cannot be opened.
Future<void> openEmailAppWithTemplate({
  required String email,
  required String subject,
  required String body,
}) async {
  final url = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {'subject': subject, 'body': body},
  )
      .toString()
      // replaceAll is necessary see https://bit.ly/3uXuSUH
      .replaceAll('+', '%20');

  // ignore_for_file: deprecated_member_use
  // If we use launchUrl, I don't know any way that spaces in the subject and
  // body are not replaced with +.
  if (await canLaunch(url)) {
    final isSuccessful = await launch(url);
    if (!isSuccessful) {
      throw Exception('Cannot open email app');
    }
  } else {
    throw Exception('Cannot open email app');
  }
}

/// Opens an email app.
///
/// Throws an [Exception] if the email app cannot be opened.
Future<void> openEmailApp() async {
  if (Platform.isAndroid) {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.APP_EMAIL',
    );
    await intent.launch();
  } else if (Platform.isIOS) {
    await launch('message://');
  } else {
    throw Exception('Cannot open email app with template');
  }
}
