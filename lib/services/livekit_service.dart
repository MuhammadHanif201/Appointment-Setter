import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  static Room? _currentRoom;

  static Future<void> disconnectCurrentRoom() async {
    if (_currentRoom != null) {
      print("🔌 Disconnecting from LiveKit Room: ${_currentRoom!.name}");
      await _currentRoom!.disconnect();
      _currentRoom = null;
    }
  }

  static Future<Room> connectToRoom({
    required String url,
    required String token,
  }) async {
    try {
      await disconnectCurrentRoom();

      final room = Room();
      await room.prepareConnection(url, token);
      await room.connect(
        url,
        token,
      );

      room.addListener(() {
        room.events.listen((event) {
          if (event is TrackSubscribedEvent) {
            print("✅ New Track Subscribed: ${event.publication.name
            }");
          }
          if (event is TrackUnsubscribedEvent) {
            print("⚠️ Track Unsubscribed: ${event.publication.name
            }");
          }
        });
      });

      await room.localParticipant?.setMicrophoneEnabled(true);

      _currentRoom = room;

      print("✅ Connected to LiveKit Room: ${room.name}");
      return room;
    } catch (e) {
      print("❌ LiveKit connection error: $e");
      rethrow;
    }
  }

  static Room? get currentRoom => _currentRoom;

  static void clearRoom() {
    _currentRoom = null;
  }
}
// import 'package:livekit_client/livekit_client.dart';
//
// class LiveKitService {
//   static Room? _currentRoom;
//
//   /// Connects to a LiveKit Room using the provided URL and token
//   static Future<Room> connectToRoom({
//     required String url,
//     required String token,
//   }) async {
//     try {
//       // Ensure any existing room is disconnected
//       await disconnectCurrentRoom(
//         url: url,
//         disconnect: 'disconnect before new connect',
//       );
//
//       final room = Room();
//
//       await room.connect(
//         url,
//         token,
//         roomOptions: const RoomOptions(
//           adaptiveStream: true,
//           dynacast: true,
//         ),
//       );
//
//       await room.localParticipant?.setMicrophoneEnabled(true);
//
//       _currentRoom = room;
//
//       print("✅ Connected to LiveKit Room: ${room.name}");
//       return room;
//     } catch (e) {
//       print("❌ LiveKit connection error: $e");
//       rethrow;
//     }
//   }
//
//   /// Disconnects from the current room and logs the disconnect details
//   static Future<void> disconnectCurrentRoom({
//     required String url,
//     required String disconnect,
//   }) async {
//     try {
//       if (_currentRoom != null) {
//         print("🔌 Disconnecting from LiveKit Room: ${_currentRoom!.name ?? 'unnamed'}");
//         print("📤 Disconnect details sent to backend: URL = $url, Status = $disconnect");
//
//         await _currentRoom!.disconnect();
//         _currentRoom = null;
//
//         print("📴 Room disconnected successfully");
//       } else {
//         print("⚠️ No active room to disconnect");
//       }
//     } catch (e) {
//       print("❌ Error while disconnecting from room: $e");
//       rethrow;
//     }
//   }
//
//   /// Getter for the current active room (if any)
//   static Room? get currentRoom => _currentRoom;
//
//   /// Clears the room reference (used optionally)
//   static void clearRoom() {
//     _currentRoom = null;
//   }
// }
