import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tmdb/enum/data_status_enum.dart';

import '../model/movie_model.dart';

class SearchProvider extends ChangeNotifier {
  List<MovieModel> searchResults = [];

  List<MovieModel> allMovies = [];

  DataStatus _searchStatus = DataStatus.initial;
  DataStatus get searchStatus => _searchStatus;
  set searchStatus(DataStatus status) {
    _searchStatus = status;
    notifyListeners();
  }

  void setMovies(List<MovieModel> movies) {
    allMovies = movies;
    searchResults = movies;
    searchStatus = DataStatus.loaded;
  }

  Future<void> searchMovies(String keyword) async {
    try {
      searchStatus = DataStatus.loading;
      searchResults = allMovies
          .where((movie) =>
              movie.title!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      searchStatus = DataStatus.loaded;
    } catch (error) {
      log("Error[searchMovies][search_provider]: $error");
      searchStatus = DataStatus.error;
    }
  }
}
