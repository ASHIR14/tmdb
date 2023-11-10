import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/View/Utils/app_colors.dart';
import 'package:tmdb/providers/movie_details_provider.dart';
import 'package:tmdb/view/screens/video_player_screen.dart';

import '../../enum/data_status_enum.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({required this.movieID, super.key});

  final int movieID;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieDetailsProvider>(
      builder: (context, movieDetailsProvider, child) {
        switch (movieDetailsProvider.movieStatus) {
          case DataStatus.initial:
            WidgetsBinding.instance.addPostFrameCallback((final _) {
              movieDetailsProvider.getMovieDetails(movieID: widget.movieID);
            });
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          case DataStatus.loading:
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          case DataStatus.loaded:
            return Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 0.6.sh,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movieDetailsProvider.movie.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                            child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 15.w),
                              Icon(
                                Icons.arrow_back_ios,
                                size: 18.sp,
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Watch",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        )),
                        Container(
                          width: 1.sw,
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "In Theaters ${DateFormat.yMMMMd().format(DateTime.parse(movieDetailsProvider.movie.releaseDate!))}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size(243.w, 50.h)),
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.blueColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Get Tickets",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              OutlinedButton.icon(
                                onPressed: () {
                                  try {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                            videoKey: movieDetailsProvider
                                                .trailer!.key!),
                                      ),
                                    );
                                  } catch (error) {
                                    log("Error[movie_details_Screen]:$error");
                                  }
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: AppColors.whiteColor,
                                ),
                                label: Text(
                                  'Watch Trailer',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size(243.w, 50.h)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Genres",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              direction: Axis.horizontal,
                              children: movieDetailsProvider.movie.genres!
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 5.h),
                                      margin: EdgeInsets.only(
                                          right: 5.w, bottom: 5.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        color: AppColors.colorList[
                                            e.key % AppColors.colorList.length],
                                      ),
                                      child: Text(
                                        "${e.value.name}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(height: 10.h),
                            Divider(color: AppColors.lightGreyColor),
                            SizedBox(height: 10.h),
                            Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "${movieDetailsProvider.movie.overview}",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
    );
  }
}
