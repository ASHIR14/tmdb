import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../enum/data_status_enum.dart';
import '../../providers/movie_details_provider.dart';
import '../Utils/app_colors.dart';
import '../widgets/movie_details/md_first_column.dart';
import '../widgets/movie_details/md_second_column.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({required this.movieID, super.key});

  final int movieID;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailsProvider>(
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
              return MediaQuery.of(context).orientation == Orientation.portrait
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 0.6.sh,
                          width: 1.sw,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://image.tmdb.org/t/p/w500${movieDetailsProvider.movie.posterPath}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: MovieDetailsFirstColumn(
                              movieDetailsProvider: movieDetailsProvider),
                        ),
                        Expanded(
                          child: Container(
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 15.h),
                            child: MovieDetailsSecondColumn(
                                movieDetailsProvider: movieDetailsProvider),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          height: 1.sh,
                          width: 0.5.sw,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://image.tmdb.org/t/p/w500${movieDetailsProvider.movie.posterPath}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: MovieDetailsFirstColumn(
                              movieDetailsProvider: movieDetailsProvider),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.sh,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 15.h),
                            child: MovieDetailsSecondColumn(
                                movieDetailsProvider: movieDetailsProvider),
                          ),
                        ),
                      ],
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
