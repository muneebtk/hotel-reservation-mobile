import 'dart:async';
import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketService {
  static WebSocketChannel? _channel;
  static StreamSubscription? _listener;
  static bool _isConnected = false; // Track WebSocket connection status

  /// Establish a WebSocket connection and listen for updates
  static Future<void> listenSocket(
      Function(String bookingId, String status) updateStatus) async {
    if (_isConnected) {
      // print("WebSocket is already connected. Ignoring duplicate request.");
      return;
    }

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');

      // ✅ Try refreshing the token if needed
      if (accessToken == null) {
        // print("Access token is missing. Fetching new token...");
        accessToken = await fetchNewToken();
        await pref.setString('access_token', accessToken);
      }

      final Uri wsUrl = Uri.parse(
          'wss://$devSocketBaseUrl:8000/ws/booking_updates/?token=$accessToken');

      await closeSocket(); // Ensure the previous connection is closed before reconnecting.

      _channel = WebSocketChannel.connect(wsUrl);
      _isConnected = true;

      _listener = _channel!.stream.listen(
        (data) {
          // print('Received: $data');
          try {
            final decodedData = jsonDecode(data); // Parse JSON response
            if (decodedData['update'] != null) {
              final bookingId = decodedData['update']['booking_id'].toString();
              final status = decodedData['update']['status'].toString();
              updateStatus(bookingId, status);
            }
          } catch (e) {
            // print("Error parsing WebSocket data: $e");
          }
        },
        onDone: () {
          // print('WebSocket closed.');
          _isConnected = false;
          reconnect(updateStatus); // Reconnect if WebSocket closes
        },
        onError: (error) {
          // print('WebSocket error: $error');
          _isConnected = false;
          reconnect(updateStatus); // Reconnect if an error occurs
        },
      );

      // print("WebSocket connected.");
    } catch (error) {
      // print("WebSocket connection failed: $error");
      _isConnected = false;
    }
  }

  /// Close the WebSocket connection and clean up
  static Future<void> closeSocket() async {
    if (!_isConnected) return;

    await _listener?.cancel();
    _listener = null;

    await _channel?.sink.close(status.normalClosure);
    _channel = null;

    _isConnected = false;
    // print("WebSocket closed manually.");
  }

  /// Reconnect WebSocket with a delay
  static void reconnect(
      Function(String bookingId, String status) updateStatus) {
    if (_isConnected) return; // Prevent multiple reconnect attempts

    Future.delayed(const Duration(seconds: 5), () {
      // print("Reconnecting WebSocket...");
      listenSocket(updateStatus);
    });
  }

  /// Mock function to fetch a new token (Replace this with API call)
  static Future<String> fetchNewToken() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return "newly_fetched_token_123"; // Replace with actual API call
  }
}
