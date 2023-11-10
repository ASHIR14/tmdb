import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
      movie = await getOfflineMovieDetails(movieID: movieID);
      if (movie.id == null) {
        movie = await MovieService.getMovieDetails(movieID: movieID);
        if (movie.id != null) {
          unawaited(saveMovieDetailsOffline());
        }
      }
      videos = await getOfflineMovieVideos(movieID: movieID);
      if (videos.isEmpty) {
        videos = await MovieService.getVideosByID(movieID: movieID);
        if (videos.isNotEmpty) {
          unawaited(saveMovieVideosOffline());
        }
      }
      findTrailer();
      if (movie.id == null) {
        movieStatus = DataStatus.error;
      } else {
        movieStatus = DataStatus.loaded;
      }
    } catch (error) {
      log("Error[getMovieDetails][movie_details_provider]: $error");
      movieStatus = DataStatus.error;
    }
  }

  void findTrailer() {
    try {
      trailer = videos.firstWhere((video) => video.type == "Trailer");
    } catch (error) {
      log("Error[findTrailer][movie_details_provider]: $error");
    }
  }

  Future<void> saveMovieDetailsOffline() async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      await box.write(
        "movie-${movie.id}",
        movie.toJson(),
      );
    } catch (error) {
      log("Error[saveMovieDetailsOffline][movie_details_provider]: $error");
    }
  }

  Future<MovieDetailsModel> getOfflineMovieDetails(
      {required int movieID}) async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      final Map<String, dynamic> movieJson = box.read("movie-$movieID");
      return MovieDetailsModel.fromJson(movieJson);
    } catch (error) {
      log("Error[getOfflineMovieDetails][movie_details_provider]: $error");
      return MovieDetailsModel();
    }
  }

  Future<void> saveMovieVideosOffline() async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      await box.write(
        "movie-${movie.id}-videos",
        videos.map((final e) => e.toJson()).toList(),
      );
    } catch (error) {
      log("Error[saveMovieVideosOffline][movie_details_provider]: $error");
    }
  }

  Future<List<MovieVideo>> getOfflineMovieVideos({required int movieID}) async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      final List<dynamic> videosJson = box.read("movie-$movieID-videos");
      return videosJson.map((final e) => MovieVideo.fromJson(e)).toList();
    } catch (error) {
      log("Error[getOfflineMovieVideos][movie_details_provider]: $error");
      return [];
    }
  }
}
