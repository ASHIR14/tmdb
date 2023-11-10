import 'dart:developer';

import 'package:flutter/material.dart';
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
      movieStatus = DataStatus.loaded;
    } catch (error) {
      log("Error[getMovies][movie_provider]: $error");
      movieStatus = DataStatus.error;
    }
  }
}
