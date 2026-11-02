import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/notes_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('notes');
  await Hive.openBox<String>('folders');
  runApp(ChangeNotifierProvider(
    create: (_) => NotesProvider()..load(),
    child: const NotesApp(),
  ));
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(builder: (context, state, _) {
      return MaterialApp(
        title: 'Notes & Knowledge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeScreen(),
      );
    });
  }
}
