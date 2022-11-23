part of 'settings_cubit.dart';

@immutable
class SettingsState extends Equatable {
  final bool appNotifications;

  SettingsState({this.appNotifications});

  //* In order to create this method
  //* CTRL + . (class)--> generate COPY WITH
  //Create a new state to emit it!
  SettingsState copyWith({
    bool appNotifications,
  }) {
    return SettingsState(
      appNotifications: appNotifications ?? this.appNotifications,
    );
  }

  @override
  //*Inside EQUATABLE WE NEED TO SUBMIT THE VALUES WE WANT
  //* To look in order to compare or react to changes
  List<Object> get props => [appNotifications];
}

class SettingsInitial extends SettingsState {}
