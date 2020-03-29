import 'package:MovieApp/models/movie_cast_response.dart';
import 'package:MovieApp/models/movie_detail_response.dart';
import 'package:MovieApp/models/movie_response.dart';

import 'api_base_helper.dart';

class MovieRepository {
  final String _apiKey = "7f1c5b6bcdc0417095c1df13c485f647";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MovieResponse> fetchPopularMovies(int page) async {
    final response = await _helper
        .get('movie/popular?api_key=$_apiKey&language=en-US&page=$page');
    return MovieResponse.fromJson(response);
  }

  Future<MovieDetailResponse> fetchMovieDetails(int movieId) async {
    final response =
        await _helper.get('movie/$movieId?api_key=$_apiKey&language=en-US');
    return MovieDetailResponse.fromJson(response);
  }

  Future<List<Cast>> fetchMovieCastList(int movieId) async {
    final response =
        await _helper.get('movie/$movieId/credits?api_key=$_apiKey');
    return MovieCastResponse.fromJson(response).results;
  }

  Future<MovieResponse> searchMovies(String searchText) async {
    final response = await _helper.get(
        'search/movie?api_key=$_apiKey&language=en-US&query=$searchText&page=1');
    return MovieResponse.fromJson(response);
  }
}
