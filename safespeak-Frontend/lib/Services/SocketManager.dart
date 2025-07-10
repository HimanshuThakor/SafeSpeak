import 'package:safespeak/Utils/ApiHelper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 30);
  late IO.Socket _socket;

  Future<void> connectWithRetry() async {
    int retryAttempt = 0;
    Duration retryDelay = initialRetryDelay;

    while (retryAttempt < maxRetries) {
      try {
        await connectSocket(); // Your method to establish the socket connection
        print('Socket connected successfully');
        return; // Connection successful, exit the loop
      } catch (e) {
        print('Connection attempt $retryAttempt failed: $e');
        retryAttempt++;

        if (retryAttempt < maxRetries) {
          print('Retrying in $retryDelay...');
          await Future.delayed(retryDelay);
          retryDelay = _getNextRetryDelay(retryDelay);
        }
      }
    }

    print('Max retries reached. Unable to establish socket connection.');
  }

  Future<void> connectSocket() async {
    _socket = IO.io(
        ApiHelper.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"Content-type": "application/json"})
            .setTimeout(3000)
            .enableAutoConnect()
            .enableReconnection()
            .build());
    // Your code to establish the socket connection
    // Example: _socket = await IO.io(url);
  }

  Duration _getNextRetryDelay(Duration previousDelay) {
    // Exponential backoff strategy for retry delay
    Duration nextDelay = previousDelay * 2;
    return nextDelay < maxRetryDelay ? nextDelay : maxRetryDelay;
  }
}
