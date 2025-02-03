import 'package:flutter/material.dart';
import 'screens/movie_list_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MovieTrackerApp());
}

class MovieTrackerApp extends StatefulWidget {
  @override
  _MovieTrackerAppState createState() => _MovieTrackerAppState();
}

class _MovieTrackerAppState extends State<MovieTrackerApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MovieListScreen(onThemeToggle: toggleTheme),
    );
  }
}
