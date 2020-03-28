import 'dart:async';

import 'package:MovieApp/models/movie_cast_response.dart';
import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';

import 'api_response.dart';

class MovieBloc {
  MovieRepository _movieRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<List<Movie>>> get movieListSink =>
      _movieListController.sink;

  Stream<ApiResponse<List<Movie>>> get movieListStream =>
      _movieListController.stream;

  MovieBloc(int page) {
    _movieListController = StreamController<ApiResponse<List<Movie>>>();
    _movieRepository = MovieRepository();
    fetchMovieList(page);
  }

  fetchMovieList(int page) async {
    movieListSink.add(ApiResponse.loading('Fetching Popular Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchPopularMovies(page);
      movieListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      movieListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieListController?.close();
  }
}

class CastBloc {
  MovieRepository _movieRepository;

  StreamController _castListController;

  StreamSink<ApiResponse<List<Cast>>> get castListSink =>
      _castListController.sink;

  Stream<ApiResponse<List<Cast>>> get castListStream =>
      _castListController.stream;

  CastBloc(int movieId) {
    _castListController = StreamController<ApiResponse<List<Cast>>>();
    _movieRepository = MovieRepository();
    fetchMovieCastList(movieId);
  }

  fetchMovieCastList(int movieId) async {
    castListSink.add(ApiResponse.loading('Fetching Cast'));
    try {
      List<Cast> casts = await _movieRepository.fetchMovieCastList(movieId);
      castListSink.add(ApiResponse.completed(casts));
    } catch (e) {
      castListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _castListController?.close();
  }
}
