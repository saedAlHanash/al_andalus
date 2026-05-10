import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class LauncherHelper {
  static Future<void> openMap(num lat, num lng) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openPage(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // ignore
    }
  }

  static Future<void> callPhone({String? phone}) async {
    if (phone == null || phone.isEmpty) return;
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        await launchUrl(telUri);
      }
    } catch (e) {
      // ignore
    }
  }

  static Future<void> sendWhatsApp({String? phone, String? text}) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: text,
    );

    try {
      await launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
    } catch (e) {
      // ignore
    }
  }

  static Future<void> sendEmail({String? email, String? subject, String? body}) async {
    final Map<String, String> params = {
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
    };

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email ?? '',
      queryParameters: params.isEmpty ? null : params,
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      rethrow;
    }
  }
}
