import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authscreens/auth_bloc.dart';
import 'register.dart';
import 'login.dart';
import 'homepage.dart';

// Widget to listen to BLoC state and navigate
class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(AppStarted());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Loading) {
          return CircularProgressIndicator(); // Show loading indicator
        } else if (state is LoggedIn) {
          return HomePage(); // Navigate to home screen
        } else if (state is LoggedOut) {
          return BlocProvider(
            create: (context) => AuthScreensBloc(),
            child: LoginOrRegister(),
          );
        }
        return Container(); // Default case
      },
    );
  }
}

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final authScreensBloc = context.read<AuthScreensBloc>();

    void togglePages() {
      authScreensBloc.add(AuthScreensChangeState());
    }

    return BlocBuilder<AuthScreensBloc, bool>(
      builder:
          (context, state) => Navigator(
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder:
                    (_) =>
                        authScreensBloc.state == false
                            ? RegisterPage(onTap: togglePages)
                            : LoginPage(onTap: togglePages),
              );
            },
          ),
    );
  }
}
