import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  // List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  ConnectivityService() {
    // Check the initial connectivity status
    initConnectivity();

    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      bool isConnected = result[0] == ConnectivityResult.none ? false : true;

      // ignore: avoid_print
      print('Connectivity changed: $isConnected');
      if (!_connectionController.isClosed) {
        _connectionController.add(isConnected);
      }
    });

    //_connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Check the initial connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    bool isConnected = result[0] == ConnectivityResult.none ? false : true;

    // ignore: avoid_print
    print('Connectivity changed: $isConnected');
  }

  // Expose the connectivity stream
  Stream<bool> get connectionStatus => _connectionController.stream;

  // Dispose of the stream controller when not in use
  void dispose() {
    _connectionController.close();
  }
}
