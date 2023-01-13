import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  const Failure();
}

class ServerFailure extends Failure {
  final String msg;

  const ServerFailure({
    this.msg = "ServerFailure",
  });

  @override
  List<Object> get props => [msg];

}

class CacheFailure extends Failure {
  final String msg;

  const CacheFailure({
    this.msg = "CacheFailure",
  });

  @override
  List<Object> get props => [msg];
}

class NetworkFailure extends Failure {
  final String msg;

  const NetworkFailure({
    this.msg = "NetworkFailure",
  });

  @override
  List<Object> get props => [msg];
}