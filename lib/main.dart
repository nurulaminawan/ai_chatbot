import 'package:ai_chatbot/provider/chat_provider.dart';
import 'package:ai_chatbot/provider/models_provider.dart';
import 'package:ai_chatbot/screens/intro_page.dart';
import 'package:ai_chatbot/screens/splash_screen.dart';
import 'package:ai_chatbot/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showIntroScreen = false;

  @override
  void initState() {
    super.initState();
    _checkIfFirstLaunch();
  }

  Future<void> _checkIfFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (isFirstLaunch) {
      setState(() {
        _showIntroScreen = true;
      });
      prefs.setBool('firstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(color: AppColors.cardColor),
        ),
        // home: _showIntroScreen ? IntroPage() : CategoryScreen(),
        home: _showIntroScreen ? IntroPage() : SplashScreen(),
      ),
    );
  }
}
