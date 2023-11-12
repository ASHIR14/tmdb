import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/View/Utils/app_colors.dart';
import 'package:tmdb/providers/movie_provider.dart';

import '../../enum/data_status_enum.dart';
import '../../providers/movie_details_provider.dart';
import '../../providers/search_provider.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(() {
      Provider.of<SearchProvider>(context, listen: false)
          .searchMovies(searchController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52.h,
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: AppColors.lightGreyColor,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Icon(Icons.search, color: AppColors.darkBlue),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkBlue,
                      ),
                      decoration: InputDecoration(
                        hintText: 'TV shows, movies and more',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchController.clear();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Icon(
                        Icons.close,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  switch (searchProvider.searchStatus) {
                    case DataStatus.initial:
                      WidgetsBinding.instance.addPostFrameCallback((final _) {
                        searchProvider.setMovies(
                            Provider.of<MovieProvider>(context, listen: false)
                                .movies);
                      });
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor),
                      );
                    case DataStatus.loading:
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor),
                      );
                    case DataStatus.loaded:
                      return searchProvider.searchResults.isEmpty
                          ? Center(
                              child: Text(
                                "We couldn't find any matching results for your query",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  bottom: 30.h, right: 15.w, left: 15.w),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.6,
                                ),
                                itemCount: searchProvider.searchResults.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      try {
                                        Provider.of<MovieDetailsProvider>(
                                                context,
                                                listen: false)
                                            .movieStatus = DataStatus.initial;
                                        pushNewScreen(
                                          context,
                                          screen: MovieDetailsScreen(
                                              movieID: searchProvider
                                                  .searchResults[index].id!),
                                          withNavBar: false,
                                        );
                                      } catch (error) {
                                        log("Error[search_screen]: $error");
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 15.w, bottom: 15.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            'https://image.tmdb.org/t/p/w500${searchProvider.searchResults[index].backdropPath}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "${searchProvider.searchResults[index].title}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
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
            ),
          ],
        ),
      ),
    );
  }
}
