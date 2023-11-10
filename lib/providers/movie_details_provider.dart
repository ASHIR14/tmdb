import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tmdb/enum/data_status_enum.dart';
import 'package:tmdb/model/movie_details_model.dart';
import 'package:tmdb/service/movie_service.dart';

import '../model/movie_video.dart';

class MovieDetailsProvider extends ChangeNotifier {
  MovieDetailsModel movie = MovieDetailsModel();

  List<MovieVideo> videos = [];

  MovieVideo? trailer;

  DataStatus _movieStatus = DataStatus.initial;
  DataStatus get movieStatus => _movieStatus;
  set movieStatus(DataStatus status) {
    _movieStatus = status;
    notifyListeners();
  }

  Future<void> getMovieDetails({required int movieID}) async {
    try {
      movieStatus = DataStatus.loading;
      movie = await MovieService.getMovieDetails(movieID: movieID);
      videos = await MovieService.getVideosByID(movieID: movieID);
      findTrailer();
      movieStatus = DataStatus.loaded;
    } catch (error) {
      log("Error[getMovies][movie_provider]: $error");
      movieStatus = DataStatus.error;
    }
  }

  void findTrailer() {
    try {
      trailer = videos.firstWhere((video) => video.type == "Trailer");
    } catch (error) {
      log("Error[findTrailer][movie_provider]: $error");
    }
  }
}
