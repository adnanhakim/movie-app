import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';
import 'package:MovieApp/widgets/movie_list.dart';
import 'package:flutter/material.dart';

class SearchMovieScreen extends StatefulWidget {
  final String searchText;

  SearchMovieScreen({this.searchText});

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  Future<MovieResponse> _future;
  MovieRepository _movieRepository;

  @override
  void initState() {
    super.initState();
    _movieRepository = MovieRepository();
    _future = _movieRepository.searchMovies(widget.searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).primaryColorDark,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 40.0, 0.0),
                width: double.infinity,
                height: 100.0,
                child: Text(
                  '\'${widget.searchText}\' Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
              FutureBuilder<MovieResponse>(
                future: _future,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('error');
                      } else {
                        return MovieList(movieResponse: snapshot.data);
                      }
                      break;
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
