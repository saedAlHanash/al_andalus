import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class LauncherHelper {
  static Future<void> openMap(num lat, num lng) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openPage(String url) async {
    final googleUrl = Uri.parse(url);

    await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
  }

  static Future<void> callPhone({String? phone}) async {
    await launchUrl(Uri.parse("tel://$phone"));
  }

  static Future<void> sendWhatsApp({String? phone, String? text}) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: text,
    );

    // var contact = phone ?? '';
    // var androidUrl = "whatsapp://send?phone=$contact&text=$text";
    // var iosUrl = "https://wa.me/$contact?text=${Uri.parse(text ?? '')}";

    await launchUrl(link.asUri());
  }

  static Future<void> sendEmail({String? email, String? subject, String? body}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email ?? '',
      queryParameters: {
        'subject': ?subject,
        'body': ?body,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not open email application';
    }
  }
}
