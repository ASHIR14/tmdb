import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tmdb/providers/movie_details_provider.dart';

import '../../Utils/app_colors.dart';

class MovieDetailsSecondColumn extends StatelessWidget {
  const MovieDetailsSecondColumn(
      {required this.movieDetailsProvider, super.key});

  final MovieDetailsProvider movieDetailsProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Genres",
            style: TextStyle(
              fontSize: 18,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: EdgeInsets.only(right: 5.w, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors
                          .colorList[e.key % AppColors.colorList.length],
                    ),
                    child: Text(
                      "${e.value.name}",
                      style: TextStyle(
                        fontSize: 12,
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
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "${movieDetailsProvider.movie.overview}",
            style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}
