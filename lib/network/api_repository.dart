import 'package:MovieApp/models/movie_response.dart';

import 'api_base_helper.dart';

class MovieRepository {
  final String _apiKey = "78b9f63937763a206bff26c070b94158";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await _helper.get("trending/movie/day?api_key=$_apiKey");
    return MovieResponse.fromJson(response).results;
  }
}
