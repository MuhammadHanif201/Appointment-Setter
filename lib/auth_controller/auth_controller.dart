import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final String apiUrl = 'https://2851-2400-adc5-171-2500-ccfb-f18f-9f2d-8363.ngrok-free.app/start-session';
  final Uuid uuid = Uuid();

  Future<Map<String, dynamic>?> sendDataToBackend(
      String selectedLabel, String selectedAgent) async {
    try {
      String uniqueId = uuid.v4();
      String uniqueRoomId = uuid.v4();

      final Map<String, String> data = {
        'roomName': uniqueId,
        'participantId': uniqueRoomId,
        'selectedLabel': selectedLabel,
        'selectedAgent': selectedAgent,
      };

      print("Data:$data");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return {
          'token': json['participantToken'],
          'roomName': json['roomName'],
        };
      } else {
        print('Failed to send data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> getLiveKitToken({
    required String selectedLabel,
    required String selectedAgent,
  }) async {
    final response = await sendDataToBackend(selectedLabel, selectedAgent);

    if (response != null && response.containsKey('token')) {
      return response['token'];
    } else {
      return null;
    }
  }
}
