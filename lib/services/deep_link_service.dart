import 'dart:async';
import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_links/app_links.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:al_andalus/core/app/app_widget.dart';
import 'package:al_andalus/main.dart';

class DeepLinkService {
  static String? _pendingDeepLinkUrl;
  static final _appLinks = AppLinks();

  static String? get pendingDeepLinkUrl => _pendingDeepLinkUrl;

  static bool get hasPendingDeepLink => _pendingDeepLinkUrl != null;

  /// Clear the pending deep link after it has been handled.
  static void clearPendingDeepLink() {
    _pendingDeepLinkUrl = null;
  }

  /// Initialize all deep linking listeners (FCM click events, Local Notification clicks, and Native deep links).
  static Future<void> initialize() async {
    // 1. FCM Terminated State click
    try {
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleFirebaseMessage(initialMessage, isFromTerminatedState: true);
      }
    } catch (e) {
      loggerObject.e(e);
    }

    // 2. FCM Background/Foreground State click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleFirebaseMessage(message, isFromTerminatedState: false);
    });

    // 3. Local Notifications Terminated State click
    try {
      final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails != null && notificationAppLaunchDetails.didNotificationLaunchApp) {
        final payload = notificationAppLaunchDetails.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          _setPendingDeepLink(payload);
        }
      }
    } catch (e) {
      loggerObject.e(e);
    }

    // 4. Native Deep Links (using app_links)
    // A. Terminated state (Cold Start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _setPendingDeepLink(initialUri.toString());
      }
    } catch (e) {
      loggerObject.e(e);
      // Log or handle error
    }

    // B. Foreground/Background state (Native Stream)
    _appLinks.uriLinkStream.listen(
      (uri) {
        navigateToUrl(uri.toString());
      },
      onError: (err) {
        loggerObject.e(err);
        // Log or handle error
      },
    );
  }

  /// Set pending deep link
  static void _setPendingDeepLink(String url) {
    final cleaned = cleanUrl(url);
    if (cleaned != null) {
      _pendingDeepLinkUrl = cleaned;
    }
  }

  /// Process incoming FCM Message clicked event
  static void _handleFirebaseMessage(RemoteMessage message, {required bool isFromTerminatedState}) {
    final url = message.data['url'] ?? message.data['link'] ?? message.data['path'];
    if (url != null && url.toString().isNotEmpty) {
      if (isFromTerminatedState) {
        _setPendingDeepLink(url.toString());
      } else {
        navigateToUrl(url.toString());
      }
    }
  }

  /// Parse the URL and extract path & query parameters.
  /// Supported:
  /// - https://back.al-andalus.com/carPage?id=123 -> /carPage?id=123
  /// - al-andalus://carPage?id=123 -> /carPage?id=123
  /// - /carPage?id=123 -> /carPage?id=123
  static String? cleanUrl(String url) {
    try {
      String processedUrl = url.trim();

      // If it's a custom scheme like al-andalus://path, convert it to al-andalus:/path
      // to prevent Uri.parse from lowercasing the host part.
      if (processedUrl.startsWith('al-andalus://')) {
        processedUrl = processedUrl.replaceFirst('al-andalus://', 'al-andalus:/');
      }

      final uri = Uri.parse(processedUrl);
      String path = uri.path;

      // Check scheme and host to extract path
      if (uri.scheme == 'al-andalus' || uri.host == 'back.al-andalus.com') {
        if (path.isEmpty && uri.host.isNotEmpty && uri.host != 'back.al-andalus.com') {
          path = uri.host;
        } else if (uri.host.isNotEmpty && uri.host != 'back.al-andalus.com') {
          path = '/${uri.host}$path';
        }
      } else {
        // Fallback for general URL formats
        if (path.isEmpty && uri.host.isNotEmpty) {
          path = uri.host;
        }
      }

      if (!path.startsWith('/')) {
        path = '/$path';
      }

      if (uri.hasQuery) {
        return '$path?${uri.query}';
      }
      return path;
    } catch (e) {
      return null;
    }
  }

  /// Direct navigation to URL via GoRouter.
  static void navigateToUrl(String url) {
    final cleanedUrl = cleanUrl(url);
    if (cleanedUrl == null) return;

    if (ctx != null && ctx!.mounted) {
      try {
        goRouter.push(cleanedUrl);
      } catch (e) {
        // Fallback if push fails
        try {
          goRouter.go(cleanedUrl);
        } catch (err) {
          // Log route navigation error
        }
      }
    } else {
      // Save it to pending if context/navigator is not ready
      _pendingDeepLinkUrl = cleanedUrl;
    }
  }

  /// Handle any pending deep link (e.g. from splash screen).
  static bool handlePendingNavigation() {
    if (_pendingDeepLinkUrl != null) {
      final url = _pendingDeepLinkUrl!;
      _pendingDeepLinkUrl = null;
      navigateToUrl(url);
      return true;
    }
    return false;
  }
}
