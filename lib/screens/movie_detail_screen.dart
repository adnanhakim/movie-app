import 'package:MovieApp/models/genre_model.dart';
import 'package:MovieApp/models/language_model.dart';
import 'package:MovieApp/models/movie_cast_response.dart';
import 'package:MovieApp/models/movie_detail_response.dart';
import 'package:MovieApp/models/movie_response.dart';
import 'package:MovieApp/network/movie_repository.dart';
import 'package:MovieApp/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  DetailScreen({this.movie});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<List<Cast>> _futureCast;
  Future<MovieDetailResponse> _futureDetails;
  MovieRepository _movieRepository;
  Genre genre = Genre();

  @override
  void initState() {
    super.initState();
    genre = Genre();
    _movieRepository = MovieRepository();
    _futureCast = _movieRepository.fetchMovieCastList(widget.movie.id);
    _futureDetails = _movieRepository.fetchMovieDetails(widget.movie.id);
  }

  Widget _buildTagline(String tagline) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Center(
        child: Text(
          tagline.toUpperCase(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

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

  Widget _buildGenre(String genreName) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Theme.of(context).primaryColorDark,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Text(
        genreName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  List<Widget> _buildGenreList() {
    List<Widget> widgets = List<Widget>();
    for (int genreId in widget.movie.genreIds) {
      String genreName = genre.genreMap[genreId];
      widgets.add(_buildGenre(genreName));
    }
    return widgets;
  }

  Widget _buildCasts(List<Cast> castList) {
    return Container(
      width: double.infinity,
      height: 130.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: castList.length > 10 ? 10 : castList.length,
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
                    backgroundImage: cast.profilePath != null
                        ? NetworkImage(
                            Constants.IMAGE_BASE_URL + cast.profilePath)
                        : NetworkImage(Constants.PROFILE_IMAGE_NOT_FOUND),
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
    );
  }

  String _formatMoney(int no) {
    String money = '';
    if (no >= 1000000000) {
      money = '${(no / 1000000000).toStringAsFixed(2)}b';
    } else if (no >= 1000000) {
      money = '${(no / 1000000).toStringAsFixed(2)}m';
    } else if (no >= 1000) {
      money = '${(no / 1000).toStringAsFixed(2)}k';
    } else if (no > 0) {
      money = no.toString();
    } else {
      return 'No data';
    }
    return money;
  }

  String _formatTime(int duration) {
    int hour = duration ~/ 60;
    int minutes = duration % 60;
    return '${hour}h ${minutes}m';
  }

  Widget _buildStatsWidget(String header, dynamic value) {
    double width = MediaQuery.of(context).size.width * 0.42;

    String _value = '';
    if (header == Constants.BUDGET || header == Constants.REVENUE) {
      _value = _formatMoney(value);
    } else if (header == Constants.LANGUAGE) {
      Language language = Language();
      if (language.languageMap.containsKey(value.toString().toLowerCase())) {
        _value = language.languageMap[value.toString().toLowerCase()];
      } else {
        _value = value.toString().toUpperCase();
      }
    } else if (header == Constants.RUNTIME) {
      _value = _formatTime(value);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 0.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            _value,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(MovieDetailResponse details) {
    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          _buildStatsWidget(Constants.LANGUAGE, details.originalLanguage),
          _buildStatsWidget(Constants.RUNTIME, details.runtime),
          _buildStatsWidget(Constants.BUDGET, details.budget),
          _buildStatsWidget(Constants.REVENUE, details.revenue),
        ],
      ),
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
              widget.movie.posterPath != null
                  ? Hero(
                      tag: widget.movie.posterPath,
                      child: Image(
                        width: double.infinity,
                        height: double.infinity,
                        image: NetworkImage(
                            Constants.IMAGE_BASE_URL + widget.movie.posterPath),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Theme.of(context).primaryColorDark,
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
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          controller: controller,
                          child: Column(
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
                              FutureBuilder<MovieDetailResponse>(
                                future: _futureDetails,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        return Container(
                                          height: 100.0,
                                          width: double.infinity,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      case ConnectionState.done:
                                        String tagline = snapshot.data.tagline;
                                        if (tagline != null && tagline != '')
                                          return _buildTagline(
                                              snapshot.data.tagline);
                                        else
                                          return SizedBox.shrink();
                                    }
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      height: 100.0,
                                      width: double.infinity,
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
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
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'WHAT ARE THE GENRES?',
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
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: _buildGenreList(),
                                      )
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
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
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 5.0, 20.0, 10.0),
                                    child: Center(
                                      child: Text(
                                        'WHO ARE THE MAIN ACTORS?',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<List<Cast>>(
                                    future: _futureCast,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            return Container(
                                              height: 130.0,
                                              width: double.infinity,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          case ConnectionState.done:
                                            return _buildCasts(snapshot.data);
                                        }
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          height: 130.0,
                                          width: double.infinity,
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 5.0, 20.0, 10.0),
                                    child: Center(
                                      child: Text(
                                        'FOR THE STAT FREAKS',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<MovieDetailResponse>(
                                    future: _futureDetails,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            return Container(
                                              height: 100.0,
                                              width: double.infinity,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          case ConnectionState.done:
                                            return _buildStats(snapshot.data);
                                        }
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          height: 100.0,
                                          width: double.infinity,
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
