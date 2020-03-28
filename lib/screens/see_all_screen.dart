import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';
import 'package:MovieApp/widgets/see_all_movie_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SeeAllScreen extends StatefulWidget {
  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  Future<MovieResponse> _future;
  MovieRepository _movieRepository;

  @override
  void initState() {
    super.initState();
    _movieRepository = MovieRepository();
    _future = _movieRepository.fetchPopularMovies(1);
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
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 40.0, 0.0),
                width: double.infinity,
                height: 100.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.fire,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Hot right now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
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
