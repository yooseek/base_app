import 'package:equatable/equatable.dart';

import 'package:withapp_did/core/wedid_core.dart';

abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  final String msg;
  final NetworkErrorCategory error;

  const ServerFailure({
    this.msg = "ServerFailure",
    this.error = NetworkErrorCategory.networkError,
  });

  @override
  String toString() {
    return 'ServerFailure{msg: $msg, error: $error}';
  }

  @override
  List<Object> get props => [msg, error];
}

class CacheFailure extends Failure {
  final String msg;

  const CacheFailure({
    this.msg = "CacheFailure",
  });

  @override
  String toString() {
    return 'CacheFailure{msg: $msg}';
  }

  @override
  List<Object> get props => [msg];
}

class NetworkFailure extends Failure {
  final String msg;

  const NetworkFailure({
    this.msg = "NetworkFailure",
  });

  @override
  String toString() {
    return 'NetworkFailure{msg: $msg}';
  }

  @override
  List<Object> get props => [msg];
}