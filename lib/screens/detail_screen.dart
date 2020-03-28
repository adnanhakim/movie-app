import 'package:MovieApp/models/genre_model.dart';
import 'package:MovieApp/models/movie_cast_response.dart';
import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  DetailScreen({this.movie});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Genre genre = Genre();

  @override
  void initState() {
    super.initState();
    genre = Genre();
    _buildGenreObjects();
    print(genreWidgets.length);
  }

//  Widget _buildGenres(List<int> genres) {
//
//    return Container(
//      child: ListView.builder(
//        itemCount: genres.length,
//        itemBuilder: (BuildContext context, int index) {
//          String genreName = genre.genreMap[genres[index]];
//          print(genreName);
//          return Text(genreName);
//        },
//      ),
//    );
//  }

  String _getRecommendation(dynamic rating) {
    if (rating >= 8.5)
      return 'A definite must watch!';
    else if (rating >= 8)
      return 'Highly recommended';
    else if (rating >= 7.5)
      return 'Recommended';
    else if (rating >= 6)
      return 'Above average';
    else if (rating >= 5)
      return 'Watchable';
    else if (rating >= 4)
      return 'Watchable with breaks';
    else if (rating >= 3)
      return 'Not recommended';
    else if (rating >= 2)
      return 'Alcohol required';
    else if (rating >= 1)
      return 'Only for high spirited souls';
    else
      return 'A complete disaster';
  }

  List<Widget> genreWidgets = List<Widget>();
  _buildGenreObjects() {
    for (int id in widget.movie.genreIds) {
      String genreName = genre.genreMap[id];
      genreWidgets.add(
        Text(
          genreName.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
      print('Added');
    }
  }

  Widget _buildCasts(List<Cast> castList) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
          child: Center(
            child: Text(
              'WHO ARE THE MAIN ACTORS?',
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 130.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              Cast cast = castList[index];
              String firstName = cast.name.split(' ')[0];
              return Center(
                child: Container(
                  width: 100.0,
                  height: 110.0,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(
                            'https://image.tmdb.org/t/p/w342${cast.profilePath}'),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        firstName,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
          child: Stack(
            children: <Widget>[
              Hero(
                tag:
                    'https://image.tmdb.org/t/p/w342${widget.movie.posterPath}',
                child: Image(
                  width: double.infinity,
                  height: double.infinity,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w342${widget.movie.posterPath}'),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: DraggableScrollableSheet(
                    builder: (context, controller) {
                      dynamic voteAvg = widget.movie.voteAverage;
                      String rating =
                          '${((voteAvg * 10).toInt()).toString()}% people recommend this movie';
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: ListView(
                          controller: controller,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30.0, horizontal: 20.0),
                              child: Center(
                                child: Text(
                                  widget.movie.title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'ONE SENTENCE REVIEW',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      _getRecommendation(
                                          widget.movie.voteAverage),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'WHAT IS THIS MOVIE ABOUT?',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      widget.movie.overview,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ),
//                            Padding(
//                              padding:
//                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
////                              child: Container(
////                                width: double.infinity,
////                                height: 500.0,
////                                padding: EdgeInsets.all(20.0),
////                                decoration: BoxDecoration(
////                                    color: Colors.white,
////                                    borderRadius: BorderRadius.circular(20.0)),
//////                                child: ListView.builder(
//////                                  scrollDirection: Axis.horizontal,
//////                                  itemCount: widget.movie.genreIds.length,
//////                                  itemBuilder:
//////                                      (BuildContext context, int index) {
//////                                    String genreName = genre
//////                                        .genreMap[widget.movie.genreIds[index]];
//////                                    print(genreName.toUpperCase());
//////                                    return Container(
//////                                      padding: EdgeInsets.symmetric(
//////                                          horizontal: 20.0, vertical: 10.0),
//////                                      decoration: BoxDecoration(
//////                                          color: Theme.of(context)
//////                                              .primaryColorDark,
//////                                          borderRadius:
//////                                              BorderRadius.circular(20.0)),
//////                                      child: Text(
//////                                        genreName.toUpperCase(),
//////                                        style: TextStyle(
//////                                          color: Colors.white,
//////                                          fontSize: 16.0,
//////                                        ),
//////                                      ),
//////                                    );
//////                                  },
//////                                ),
////                                child: Column(children: genreWidgets),
////                              ),
//                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'HOW ARE THE REVIEWS?',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      rating,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder<List<Cast>>(
                              future: MovieRepository()
                                  .fetchMovieCastList(widget.movie.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return CircularProgressIndicator();
                                    case ConnectionState.done:
                                      return _buildCasts(snapshot.data);
                                  }
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
