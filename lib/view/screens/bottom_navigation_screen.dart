import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/View/Utils/app_colors.dart';
import 'package:tmdb/view/utils/text_styles.dart';

import 'home_screen.dart';
import 'media_library_screen.dart';
import 'more_screen.dart';
import 'search_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: Provider.of<PersistentTabController>(context, listen: false),
      screens: const [
        HomeScreen(),
        SearchScreen(),
        MediaLibraryScreen(),
        MoreScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Image.asset(
            "lib/assets/images/dashboard.png",
            color: AppColors.whiteColor,
          ),
          inactiveIcon: Image.asset("lib/assets/images/dashboard.png"),
          title: 'Dashboard',
          activeColorPrimary: AppColors.whiteColor,
          inactiveColorPrimary: AppColors.greyColor,
          textStyle: TextStyles.bottomNavTextStyle,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: 'Search',
          activeColorPrimary: AppColors.whiteColor,
          inactiveColorPrimary: AppColors.greyColor,
          textStyle: TextStyles.bottomNavTextStyle,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset(
            "lib/assets/images/media.png",
            color: AppColors.whiteColor,
          ),
          inactiveIcon: Image.asset("lib/assets/images/media.png"),
          title: 'Media Library',
          activeColorPrimary: AppColors.whiteColor,
          inactiveColorPrimary: AppColors.greyColor,
          textStyle: TextStyles.bottomNavTextStyle,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset(
            "lib/assets/images/more.png",
            color: AppColors.whiteColor,
          ),
          inactiveIcon: Image.asset("lib/assets/images/more.png"),
          title: 'More',
          activeColorPrimary: AppColors.whiteColor,
          inactiveColorPrimary: AppColors.greyColor,
          textStyle: TextStyles.bottomNavTextStyle,
        ),
      ],
      navBarStyle: NavBarStyle.style6,
      backgroundColor: AppColors.primaryColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(27.r),
      ),
      navBarHeight: 75.h,
    );
  }
}
