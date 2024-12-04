import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloflutter/screens/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const FlixPro());
}

class FlixPro extends StatelessWidget {
  //Whats super.key?
  const FlixPro({super.key});

  //@override
  Widget build2(BuildContext context) {
    WebViewController controller = WebViewController()..loadRequest(
        //Uri.parse('http://127.0.0.1:5500/lib/html/home.html'),
        Uri.dataFromString("""
    <iframe src="https://www.2embed.cc/embed/tt10676048"
      width="100%" height="100%" frameborder="0" scrolling="no"
      allowfullscreen></iframe>""", mimeType: "text/html"));
    return MaterialApp(
      title: 'Flix Pro',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontSize: 24),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .copyWith(surface: Colors.black),
          fontFamily: GoogleFonts.ptSans().fontFamily,
          useMaterial3: true),
      home: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }

  //Whats BuildContext?
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flix Pro',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontSize: 24),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .copyWith(surface: Colors.black),
          fontFamily: GoogleFonts.ptSans().fontFamily,
          useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
