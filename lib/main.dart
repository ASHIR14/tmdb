import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/tickets_provider.dart';

import 'providers/movie_details_provider.dart';
import 'providers/movie_provider.dart';
import 'providers/search_provider.dart';
import 'view/screens/bottom_navigation_screen.dart';

Future<void> main() async {
  await GetStorage.init("moviesDB");
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
          ChangeNotifierProvider<PersistentTabController>(
              create: (_) => PersistentTabController(initialIndex: 0)),
          ChangeNotifierProvider<MovieProvider>(create: (_) => MovieProvider()),
          ChangeNotifierProvider<MovieDetailsProvider>(
              create: (_) => MovieDetailsProvider()),
          ChangeNotifierProvider<SearchProvider>(
              create: (_) => SearchProvider()),
          ChangeNotifierProvider<TicketsProvider>(
              create: (_) => TicketsProvider()),
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
