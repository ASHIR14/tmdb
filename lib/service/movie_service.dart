import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tmdb/model/movie_model.dart';

import '../model/movie_details_model.dart';
import '../model/movie_video.dart';

class MovieService {
  static String baseURL = "https://api.themoviedb.org/3/movie/";
  static String params = "?api_key=5f160ef33246e37ef292acb27bc1c41f";

  static Future<List<MovieModel>> getMovies() async {
    try {
      Response response = await Dio().get("${baseURL}upcoming$params");

      List<MovieModel> movies = (response.data['results'] as List)
          .map((movieData) => MovieModel.fromJson(movieData))
          .toList();

      return movies;
    } catch (error) {
      log("Error[getMovies][movie_service]: $error");
      return [];
    }
  }

  static Future<MovieDetailsModel> getMovieDetails(
      {required int movieID}) async {
    try {
      Response response = await Dio().get("$baseURL$movieID$params");

      return MovieDetailsModel.fromJson(response.data);
    } catch (error) {
      log("Error[getMovieDetails][movie_service]: $error");
      return MovieDetailsModel();
    }
  }

  static Future<List<MovieVideo>> getVideosByID({required int movieID}) async {
    try {
      Response response = await Dio().get("$baseURL$movieID/videos$params");

      List<MovieVideo> videos = (response.data['results'] as List)
          .map((movieData) => MovieVideo.fromJson(movieData))
          .toList();

      return videos;
    } catch (error) {
      log("Error[getVideosByID][movie_service]: $error");
      return [];
    }
  }
}
