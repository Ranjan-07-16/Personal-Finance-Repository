import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';
import '../services/session_service.dart';

class UserState {
  final String username;
  final String email;

  const UserState({required this.username, required this.email});

  UserState copyWith({String? username, String? email}) => UserState(
        username: username ?? this.username,
        email: email ?? this.email,
      );
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(super.state);

  Future<void> updateUsername(String username) async {
    state = state.copyWith(username: username);
    UserData.username = username;
    await SessionService.saveSession(state.username, state.email);
  }

  Future<void> setUser(String username, String email) async {
    state = UserState(username: username, email: email);
    UserData.username = username;
    UserData.email = email;
    await SessionService.saveSession(username, email);
  }

  Future<void> clearUser() async {
    await SessionService.clearSession();
    UserData.username = '';
    UserData.email = '';
    state = const UserState(username: '', email: '');
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(UserState(
    username: UserData.username,
    email: UserData.email,
  ));
});
