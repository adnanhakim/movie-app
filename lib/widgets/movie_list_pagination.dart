import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';
import 'package:MovieApp/screens/movie_detail_screen.dart';
import 'package:MovieApp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieListPagination extends StatefulWidget {
  final MovieResponse movieResponse;

  const MovieListPagination({this.movieResponse});

  @override
  _MovieListPaginationState createState() => _MovieListPaginationState();
}

class _MovieListPaginationState extends State<MovieListPagination> {
  ScrollController _scrollController = ScrollController();
  List<Movie> movies;
  int currentPage = 1;
  MovieRepository _movieRepository;

  bool onNotificationListener(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        _movieRepository.fetchPopularMovies(currentPage + 1).then((value) {
          currentPage = value.page;
          setState(() {
            movies.addAll(value.results);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    movies = widget.movieResponse.results;
    _movieRepository = MovieRepository();
  }

  Widget _buildStarsWidget(dynamic rating) {
    bool half = false;
    double no = rating / 2;
    int stars = no.toInt(); // Whole no
    double decimal = no - stars;
    if ((0.75 - decimal) > 0)
      half = true; // Checking if decimal is closer to 0.5 or 1
    if (!half) stars += 1; // If decimal is closer to 1, star will increase by 1

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
                size: 16.0,
              )
            : SizedBox.shrink(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: NotificationListener(
          onNotification: onNotificationListener,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              Movie movie = movies[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(movie: movie),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  height: 300.0,
                  child: Stack(
                    children: <Widget>[
                      movie.posterPath != null
                          ? Hero(
                              tag: movie.posterPath,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                child: Image(
                                  width: double.infinity,
                                  image: NetworkImage(Constants.IMAGE_BASE_URL +
                                      movie.posterPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        left: 0.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          child: Container(
                            height: 300.0,
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  movie.title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
