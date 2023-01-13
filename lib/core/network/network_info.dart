import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  const NetworkInfoImpl({
    required this.connectionChecker,
  });

  @override
  Future<bool> get isConnected async => await connectionChecker.checkConnectivity() == ConnectivityResult.none ? false : true;
}