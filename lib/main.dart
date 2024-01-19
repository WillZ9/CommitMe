import 'package:commit_me/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'themes.dart';
import 'db/DatabaseHelperCommit.dart';
import 'authentication/loginScreen.dart';
import 'tabs/Profile.dart';
import 'tabs/Journal.dart';
import 'tabs/Decoration.dart';
import 'tabs/Menu.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _decorationNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _journalNavigatorKey = GlobalKey<NavigatorState>();
final _menuNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/menu',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _decorationNavigatorKey,
          routes: [
            GoRoute(
              path: '/decoration',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Decorations(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _menuNavigatorKey,
          routes: [
            GoRoute(
              path: '/menu',
              builder: (context, state) => MainMenu(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _journalNavigatorKey,
          routes: [
            GoRoute(
              path: '/journal',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Journal(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
                path: '/profile', builder: (context, state) => const Profile()),
          ],
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(const MyApp(isLogin: false));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isLogin});
  final bool isLogin;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late DatabaseHelper dbHelper;

  @override
  Widget build(BuildContext context) {
    if (widget.isLogin) {
      return MaterialApp.router(
        theme: Themes.dark,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      );
    } else {
      return MaterialApp(
        theme: Themes.dark,
        themeMode: ThemeMode.dark,
        home: const LoginScreen(),
      );
    }
  }
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ScaffoldWithNavigationBar(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
              label: 'Decoration',
              icon: Icon(Icons.add_box, color: Colors.white)),
          NavigationDestination(
              label: 'Menu', icon: Icon(Icons.home, color: Colors.white)),
          NavigationDestination(
              label: 'Journal', icon: Icon(Icons.book, color: Colors.white)),
          NavigationDestination(
              label: 'Profile', icon: Icon(Icons.person, color: Colors.white)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
