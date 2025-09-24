import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/bills_screen.dart';
import 'services/api_service.dart';
import 'screens/bill_calculator_screen.dart';

void main() {
  runApp(const JunglePowerApp());
}

class JunglePowerApp extends StatefulWidget {
  const JunglePowerApp({super.key});

  @override
  State<JunglePowerApp> createState() => _JunglePowerAppState();
}

class _JunglePowerAppState extends State<JunglePowerApp> {
  bool _darkMode = false;

  void toggleTheme() {
    setState(() => _darkMode = !_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
      create: (_) => ApiService(),
      child: MaterialApp(
        title: 'Jungle Power',
        debugShowCheckedModeBanner: false,
        themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
        ),
        home: MainShell(darkMode: _darkMode, toggleTheme: toggleTheme),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool darkMode;
  final VoidCallback toggleTheme;
  const MainShell({
    super.key,
    required this.darkMode,
    required this.toggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;

// Remove the 'const' from this line:
  final _pages = [
    DashboardScreen(),
    BillsScreen(),
    BillCalculatorScreen(),
    HistoryScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.jpg', // Ensure this is added in pubspec.yaml
              height: 50,
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'SMART ELECTRIC POWER REGULATION',
                style: TextStyle(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.darkMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: widget.darkMode ? 'Switch to Light' : 'Switch to Dark',
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long),
                  label: Text('Bills'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calculate),
                  label: Text('Calculator'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('History'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.notifications),
                  label: Text('Alerts'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _pages[_index],
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Bills',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Calculator',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Alerts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
