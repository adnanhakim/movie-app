import 'package:MovieApp/models/cast_response.dart';
import 'package:MovieApp/models/tv_detail_response.dart';
import 'package:MovieApp/models/tv_response.dart';
import 'package:MovieApp/utils/constants.dart';

import 'api_base_helper.dart';

class TvRepository {
  final String _apiKey = Constants.API_KEY;

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<TvResponse> fetchPopularSeries(int page) async {
    final response = await _helper
        .get('tv/popular?api_key=$_apiKey&language=en-US&page=$page');
    return TvResponse.fromJson(response);
  }

  Future<TvDetailResponse> fetchSeriesDetails(int tvId) async {
    final response =
        await _helper.get('tv/$tvId?api_key=$_apiKey&language=en-US');
    return TvDetailResponse.fromJson(response);
  }

  Future<List<Cast>> fetchSeriesCastList(int tvId) async {
    final response =
        await _helper.get('tv/$tvId/credits?api_key=$_apiKey&language=en-US');
    return CastResponse.fromJson(response).results;
  }

//  Future<MovieResponse> searchMovies(String searchText) async {
//    final response = await _helper.get(
//        'search/movie?api_key=$_apiKey&language=en-US&query=$searchText&page=1');
//    return MovieResponse.fromJson(response);
//  }
}
