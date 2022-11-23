import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(appNotifications: false));

  void toggleAppNotifications(bool newValue) {
    //* This is whats right
    //* We emit the new state
    emit(state.copyWith(appNotifications: newValue));

    // ! This is wrong NOT DO IT!
    // ! YOU SHOULD NEVER MUTATE EXISTING STATES!
    // state.appNotifications = newValue;
    // ! DART Knows that this state is same as previous
    // emit(state);
  }
}
