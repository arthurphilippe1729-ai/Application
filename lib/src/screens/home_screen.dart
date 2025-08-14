dart
import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    final pages = const [TasksScreen(), ScheduleScreen()];
    return Scaffold(
      appBar: AppBar(title: Text(idx == 0 ? 'Tâches' : 'Emploi du temps')),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: pages[idx]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Tâches'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Agenda'),
        ],
      ),
    );
  }
}