import 'package:MovieApp/models/tv_response.dart';
import 'package:MovieApp/network/tv_repository.dart';
import 'package:MovieApp/screens/tv_detail_screen.dart';
import 'package:MovieApp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopularSeries extends StatefulWidget {
  @override
  _PopularSeriesState createState() => _PopularSeriesState();
}

class _PopularSeriesState extends State<PopularSeries> {
  Future<TvResponse> _future;
  TvRepository _tvRepository;

  @override
  void initState() {
    super.initState();
    _tvRepository = TvRepository();
    _future = _tvRepository.fetchPopularSeries(1);
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

  Widget _buildTrendingSeries(List<TVSeries> tvSeriesList) {
    return Container(
      width: double.infinity,
      height: 500.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: tvSeriesList.length,
        itemBuilder: (BuildContext buildContext, int index) {
          TVSeries tvSeries = tvSeriesList[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TvDetailScreen(tvSeries: tvSeries),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  tvSeries.posterPath != null
                      ? Hero(
                          tag: tvSeries.posterPath,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            child: Image(
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width * 0.9,
                              image: NetworkImage(Constants.IMAGE_BASE_URL +
                                  tvSeries.posterPath),
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
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
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
                              tvSeries.name.toUpperCase(),
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
                            _buildStarsWidget(tvSeries.voteAverage),
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
                      'Hot TV series right now',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
//                GestureDetector(
////                  onTap: () => Navigator.push(
////                    context,
////                    MaterialPageRoute(
////                      builder: (_) => SeeAllScreen(),
////                    ),
////                  ),
//                  child: Text(
//                    'See All',
//                    style: TextStyle(
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.bold,
//                      color: Theme.of(context).primaryColorDark,
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
          FutureBuilder<TvResponse>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    break;
                  case ConnectionState.done:
                    return _buildTrendingSeries(snapshot.data.results);
                    break;
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
  }
}
