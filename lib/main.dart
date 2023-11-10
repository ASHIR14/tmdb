import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/movie_details_provider.dart';
import 'package:tmdb/providers/movie_provider.dart';

import 'view/screens/bottom_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider<MovieProvider>(create: (_) => MovieProvider()),
          ChangeNotifierProvider<MovieDetailsProvider>(
              create: (_) => MovieDetailsProvider()),
        ],
        child: MaterialApp(
          title: 'TMDB 1020',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const BottomNavigationScreen(),
        ),
      ),
    );
  }
}
