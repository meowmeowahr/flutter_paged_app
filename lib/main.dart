import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Paged App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue,
            brightness: Brightness.light,
          ),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const RootPage(title: 'Paged Demo App'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var bottomBarBehavior = NavigationDestinationLabelBehavior.alwaysShow;

  void setBottomBarBehavior(NavigationDestinationLabelBehavior? behavior) {
    if (behavior != null) {
      bottomBarBehavior = behavior;
      notifyListeners();
    }
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.title});

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            label: "Options",
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: appState.bottomBarBehavior,
      ),
      body: [
        Container(
          alignment: Alignment.center,
          child: const Text('Page 1'),
        ),
        const OptionsPage(),
      ][_selectedIndex],
    );
  }
}

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        const Divider(),
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              children: [
                const Icon(Icons.navigation),
                const SizedBox(width: 10),
                Text(
                  'Navigation Bar',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        DropdownMenu(
          label: const Text("Navigation Behavior"),
          enableSearch: false,
          dropdownMenuEntries: const [
            DropdownMenuEntry(
                label: "Always Show",
                value: NavigationDestinationLabelBehavior.alwaysShow),
            DropdownMenuEntry(
                label: "Always Hide",
                value: NavigationDestinationLabelBehavior.alwaysHide),
            DropdownMenuEntry(
                label: "Show Selected",
                value: NavigationDestinationLabelBehavior.onlyShowSelected),
          ],
          onSelected: (NavigationDestinationLabelBehavior? behavior) {
            appState.setBottomBarBehavior(behavior);
          },
        )
      ],
    );
  }
}
