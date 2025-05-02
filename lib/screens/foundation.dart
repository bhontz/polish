import 'package:flutter/material.dart';
import 'settings.dart';
import 'homepage.dart';

class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T E A C H E R', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
            },
          ),
        ],
      ),
      body: HomePage(), // # NavigatorWidget(),
    );
  }
}

// class NavigatorWidget extends StatelessWidget {
//   const NavigatorWidget({super.key});

//   //   CommentsPage({super.key, required this.book});

//   @override
//   Widget build(BuildContext context) {
//     final appMenuBloc = context.read<AppMenuBloc>();

//     return BlocBuilder<AppMenuBloc, bool>(
//       builder:
//           (context, state) => Navigator(
//             onGenerateRoute: (RouteSettings settings) {
//               return MaterialPageRoute(
//                 builder:
//                     (_) => appMenuBloc.state == false ? HomePage() : MenuPage(),
//               );
//             },
//           ),
//     );
//   }
// }
