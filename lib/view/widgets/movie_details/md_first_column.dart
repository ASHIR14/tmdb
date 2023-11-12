import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tmdb/providers/movie_details_provider.dart';
import 'package:tmdb/view/screens/get_tickets_screen.dart';
import 'package:tmdb/view/widgets/app_button.dart';

import '../../Utils/app_colors.dart';
import '../../screens/video_player_screen.dart';

class MovieDetailsFirstColumn extends StatelessWidget {
  const MovieDetailsFirstColumn(
      {required this.movieDetailsProvider, super.key});

  final MovieDetailsProvider movieDetailsProvider;

  Widget getTicketsButton(context) {
    return AppButton(
      text: "Get Tickets",
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GetTicketsScreen(
                movieName: movieDetailsProvider.movie.title!,
                movieDate: movieDetailsProvider.movie.releaseDate!),
          ),
        );
      },
      fixedSize: MediaQuery.of(context).orientation == Orientation.portrait
          ? MaterialStateProperty.all(Size(243.w, 50.h))
          : null,
    );
  }

  Widget watchTrailerButton(context) {
    return OutlinedButton.icon(
      onPressed: () {
        try {
          if (movieDetailsProvider.trailer != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                    videoKey: movieDetailsProvider.trailer!.key!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Trailer not found"),
              ),
            );
          }
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
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.whiteColor,
        ),
      ),
      style: ButtonStyle(
        fixedSize: MediaQuery.of(context).orientation == Orientation.portrait
            ? MaterialStateProperty.all(Size(243.w, 50.h))
            : null,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  size: 18,
                  color: AppColors.whiteColor,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Watch",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 1.sw,
          padding: EdgeInsets.only(bottom: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "In Theaters ${DateFormat.yMMMMd().format(DateTime.parse(movieDetailsProvider.movie.releaseDate!))}",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColor,
                ),
              ),
              SizedBox(height: 15.h),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Column(
                      children: [
                        getTicketsButton(context),
                        SizedBox(height: 10.h),
                        watchTrailerButton(context),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(child: getTicketsButton(context)),
                        SizedBox(width: 5.w),
                        Expanded(child: watchTrailerButton(context)),
                        SizedBox(width: 5.w),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
