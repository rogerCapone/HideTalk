import 'package:equatable/equatable.dart';

enum ConnectionType {
  Wifi,
  Mobile,
}

abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected({this.connectionType});
}

class InternetDisconnected extends InternetState {}
