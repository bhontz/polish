import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthScreensEvent {}

final class AuthScreensChangeState extends AuthScreensEvent {}

class AuthScreensBloc extends Bloc<AuthScreensEvent, bool> {
  AuthScreensBloc() : super(false) {
    on<AuthScreensChangeState>((event, emit) {
      emit(!state);
    });
  }
}

// Event
sealed class AuthEvent {}

final class AppStarted extends AuthEvent {}

// State
sealed class AuthState {}

final class LoggedIn extends AuthState {}

final class LoggedOut extends AuthState {}

final class Loading extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(Loading()) {
    on<AppStarted>((event, emit) async {
      // Check for token in local storage
      final token = await _getToken();
      if (token != null) {
        emit(LoggedIn());
        // Navigate to home screen
      } else {
        emit(LoggedOut());
        // Navigate to login screen
      }
    });
  }

  Future<String?> _getToken() async {
    String? uid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? un = prefs.getString('username');
    final String? pw = prefs.getString('password');
    if (un != null && pw != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: un,
          password: pw,
        );
        uid = FirebaseAuth.instance.currentUser!.uid;
      } on FirebaseAuthException {
        uid = null;
      }
    }
    return uid;
  }
}
