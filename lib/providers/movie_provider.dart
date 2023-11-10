import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tmdb/enum/data_status_enum.dart';
import 'package:tmdb/service/movie_service.dart';

import '../model/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  List<MovieModel> movies = [];

  DataStatus _movieStatus = DataStatus.initial;
  DataStatus get movieStatus => _movieStatus;
  set movieStatus(DataStatus status) {
    _movieStatus = status;
    notifyListeners();
  }

  Future<void> getMovies() async {
    try {
      movieStatus = DataStatus.loading;
      movies = await MovieService.getMovies();
      if (movies.isEmpty) {
        movies = await getOfflineMovies();
      } else {
        unawaited(saveMoviesOffline());
      }
      movieStatus = DataStatus.loaded;
    } catch (error) {
      log("Error[getMovies][movie_provider]: $error");
      movieStatus = DataStatus.error;
    }
  }

  Future<void> saveMoviesOffline() async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      await box.write(
        "movies",
        movies.map((final e) => e.toJson()).toList(),
      );
    } catch (error) {
      log("Error[saveMoviesOffline][movie_provider]: $error");
    }
  }

  Future<List<MovieModel>> getOfflineMovies() async {
    try {
      final GetStorage box = GetStorage("moviesDB");
      final List<dynamic> moviesJson = box.read("movies");
      return moviesJson.map((final e) => MovieModel.fromJson(e)).toList();
    } catch (error) {
      log("Error[getOfflineMovies][movie_provider]: $error");
      return [];
    }
  }
}
