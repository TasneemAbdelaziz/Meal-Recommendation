import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  final Connectivity _connectivity;

  ConnectivityChecker(this._connectivity);

  /// Check if device has internet connection
  Future<bool> hasConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      // Check if we have any connectivity
      if (result.contains(ConnectivityResult.none)) {
        return false;
      }
      
      // We have connectivity (wifi, mobile, or ethernet)
      return result.contains(ConnectivityResult.wifi) ||
             result.contains(ConnectivityResult.mobile) ||
             result.contains(ConnectivityResult.ethernet);
    } catch (e) {
      // If we can't check connectivity, assume we're offline
      return false;
    }
  }

  /// Get current connection type
  Future<String> getConnectionType() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      if (result.contains(ConnectivityResult.wifi)) {
        return 'WiFi';
      } else if (result.contains(ConnectivityResult.mobile)) {
        return 'Mobile Data';
      } else if (result.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet';
      } else {
        return 'None';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
