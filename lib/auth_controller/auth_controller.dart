import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

/// What the backend hands back when a call starts.
class CallSession {
  /// LiveKit access token for this caller.
  final String token;

  /// The LiveKit room the backend created for this call.
  final String roomName;

  /// The LiveKit server the token belongs to.
  final String serverUrl;

  const CallSession({
    required this.token,
    required this.roomName,
    required this.serverUrl,
  });
}

class AuthController extends GetxController {
  /// The token server in the `backend/` folder.
  ///
  /// Point the app at a different server at build time, for example an ngrok
  /// tunnel when testing on a real phone:
  ///
  ///     flutter run --dart-define=BACKEND_URL=https://abc123.ngrok-free.app
  static const String _backendUrlOverride = String.fromEnvironment('BACKEND_URL');

  /// Used only if the backend does not say which LiveKit server to join.
  static const String _fallbackLiveKitUrl =
      'wss://appointmentsetter-7p2s97kw.livekit.cloud';

  static String get backendUrl {
    if (_backendUrlOverride.isNotEmpty) return _backendUrlOverride;
    // The Android emulator reaches the host machine through 10.0.2.2.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  final Uuid uuid = const Uuid();

  Future<CallSession?> startSession({
    required String selectedLabel,
    required String selectedAgent,
  }) async {
    final uri = Uri.parse('$backendUrl/start-session');
    final Map<String, String> data = {
      'participantId': uuid.v4(),
      'selectedLabel': selectedLabel,
      'selectedAgent': selectedAgent,
    };

    debugPrint('Starting session at $uri with $data');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              // Skips ngrok's browser warning page when the backend runs
              // behind a free ngrok tunnel. Other servers ignore it.
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint(
            'Failed to start session: ${response.statusCode} ${response.body}');
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final token = json['participantToken'] as String?;
      if (token == null || token.isEmpty) {
        debugPrint('Backend response had no participantToken: ${response.body}');
        return null;
      }

      return CallSession(
        token: token,
        roomName: json['roomName'] as String? ?? '',
        serverUrl: json['serverUrl'] as String? ?? _fallbackLiveKitUrl,
      );
    } on TimeoutException {
      debugPrint('Backend at $uri did not answer within 15 seconds');
      return null;
    } catch (e) {
      debugPrint('Could not reach backend at $uri: $e');
      return null;
    }
  }
}
