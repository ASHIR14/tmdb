import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/View/Utils/app_colors.dart';
import 'package:tmdb/enum/data_status_enum.dart';
import 'package:tmdb/providers/movie_details_provider.dart';

import '../../providers/movie_provider.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Watch',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: AppColors.darkBlue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<PersistentTabController>(context, listen: false)
                  .index = 1;
            },
            icon: Icon(
              Icons.search,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          switch (movieProvider.movieStatus) {
            case DataStatus.initial:
              WidgetsBinding.instance.addPostFrameCallback((final _) {
                movieProvider.getMovies();
              });
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            case DataStatus.loading:
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            case DataStatus.loaded:
              return movieProvider.movies.isEmpty
                  ? Center(
                      child: Text(
                        'Unable to fetch data',
                        style: TextStyle(color: AppColors.redColor),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: ListView.builder(
                        itemCount: movieProvider.movies.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                Provider.of<MovieDetailsProvider>(context,
                                        listen: false)
                                    .movieStatus = DataStatus.initial;
                                pushNewScreen(
                                  context,
                                  screen: MovieDetailsScreen(
                                      movieID: movieProvider.movies[index].id!),
                                  withNavBar: false,
                                );
                              } catch (error) {
                                log("Error[home_screen]: $error");
                              }
                            },
                            child: Container(
                              height: 180.h,
                              width: 1.sw,
                              margin: EdgeInsets.only(
                                  bottom: 15.h, right: 15.w, left: 15.w),
                              padding:
                                  EdgeInsets.only(left: 15.w, bottom: 15.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    'https://image.tmdb.org/t/p/w500${movieProvider.movies[index].backdropPath}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${movieProvider.movies[index].title}",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    );
            case DataStatus.error:
              return Center(
                child: Text(
                  'Unable to fetch data',
                  style: TextStyle(color: AppColors.redColor),
                ),
              );
          }
        },
      ),
    );
  }
}
