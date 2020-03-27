import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/api_response.dart';
import 'package:MovieApp/network/movie_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrendingMovies extends StatefulWidget {
  @override
  _TrendingMoviesState createState() => _TrendingMoviesState();
}

class _TrendingMoviesState extends State<TrendingMovies> {
  MovieBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MovieBloc();
  }

  Widget _buildStarsWidget(dynamic rating) {
    bool half = false;
    double no = rating / 2;
    int stars = no.toInt(); // Whole no
    double decimal = no - stars;
    if ((0.75 - decimal) > 0)
      half = true; // Checking if decimal is closer to 0.5 or 1
    if (!half) stars += 1; // If decimal is closer to 1, star will increase by 1

    print(no);
    print(half);
    return Row(
      children: <Widget>[
        (stars >= 1)
            ? Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  SizedBox(width: 8.0),
                ],
              )
            : SizedBox.shrink(),
        (stars >= 2)
            ? Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  SizedBox(width: 8.0),
                ],
              )
            : SizedBox.shrink(),
        (stars >= 3)
            ? Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  SizedBox(width: 8.0),
                ],
              )
            : SizedBox.shrink(),
        (stars >= 4)
            ? Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  SizedBox(width: 8.0),
                ],
              )
            : SizedBox.shrink(),
        (stars == 5)
            ? Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.white,
                size: 20.0,
              )
            : SizedBox.shrink(),
        half
            ? Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.white,
                size: 20.0,
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTrendingMovies(List<Movie> movies) {
    return Container(
      width: double.infinity,
      height: 500.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext buildContext, int index) {
          Movie movie = movies[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  child: Image(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.9,
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w342${movie.posterPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    child: Container(
                      height: 250.0,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 40.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movie.title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.0),
                          _buildStarsWidget(movie.voteAverage),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.fire,
                      color: Theme.of(context).primaryColorDark,
                      size: 20.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Hot right now',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<ApiResponse<List<Movie>>>(
            stream: _bloc.movieListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return CircularProgressIndicator();
                    break;
                  case Status.COMPLETED:
                    return _buildTrendingMovies(snapshot.data.data);
                    break;
                  case Status.ERROR:
                    return Text('error');
                    break;
                }
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
