import 'package:MovieApp/models/movie_cast_response.dart';
import 'package:MovieApp/models/movie_response.dart';

import 'api_base_helper.dart';

class MovieRepository {
  final String _apiKey = "7f1c5b6bcdc0417095c1df13c485f647";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await _helper.get("trending/movie/day?api_key=$_apiKey");
    return MovieResponse.fromJson(response).results;
  }

  Future<List<Cast>> fetchMovieCastList(int _movieId) async {
    final response =
        await _helper.get("movie/$_movieId/credits?api_key=$_apiKey");
    return MovieCastResponse.fromJson(response).results;
  }
}
