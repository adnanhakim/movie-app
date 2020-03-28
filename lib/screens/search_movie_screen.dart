import 'package:flutter/material.dart';

class SearchMovieScreen extends StatefulWidget {
  final String searchText;

  SearchMovieScreen({this.searchText});

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
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
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 40.0, 0.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
