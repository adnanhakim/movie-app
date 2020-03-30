import 'package:MovieApp/screens/search_movie_screen.dart';
import 'package:MovieApp/widgets/popular_movies.dart';
import 'package:MovieApp/widgets/popular_series.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greeting = _getGreeting(DateTime.now().hour);
  String searchText = '';

  void _validateSearch(BuildContext context) {
    if (searchText == '') {
      _showToast(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchMovieScreen(
            searchText: searchText,
          ),
        ),
      );
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Search query is required!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  static String _getGreeting(int hour) {
    print(hour);
    if (hour > 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 40.0),
                  child: Text(
                    _greeting,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 40.0),
                  child: Text(
                    'What would you like to find today?',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for a movie',
                          ),
                          onChanged: (String value) => searchText = value,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        iconSize: 30.0,
                        onPressed: () => _validateSearch(context),
                      )
                    ],
                  ),
                ),
                PopularMovies(),
                SizedBox(height: 20.0),
                PopularSeries(),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      }),
    );
  }
}
