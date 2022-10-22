import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:launch_tracker/models/launch_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Spacex {
  Future upcomingLaunches() async {
    try {
      var url = Uri.parse('https://api.spacexdata.com/v4/launches/upcoming');
      var response = await http.get(
        url,
      );
      List launches = [];
      var data = json.decode(response.body);

      for (var i = 0; i < data.length; i++) {
        launches.add(
            LaunchModel(mission: data[i]['name'], date: data[i]['date_local']));
      }
      return launches;
    } catch (exception) {
      return(exception.toString());

    }
  }

  Future nextLaunch() async {
    try {
      var url = Uri.parse('https://api.spacexdata.com/v4/launches/next');
      var response = await http.get(
        url,
      );
      var next_launch;
      var data = json.decode(response.body);
      next_launch =
          LaunchModel(mission: data['name'], date: data['date_local']);
      return next_launch;
    } catch (exception) {
      return(exception.toString());

    }
  }

  Future addFavorites(launchModel, context) async {
    final prefs = await SharedPreferences.getInstance();
    String? favorites = prefs.getString('favorites');
    final snackBar = SnackBar(
      content: const Text('Added to favorites'),
      backgroundColor: (Color.fromARGB(138, 90, 0, 78)),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );

    if (favorites == null) {
      List allFavourites = [launchModel.toJson()];
      await prefs.setString('favorites', jsonEncode(allFavourites));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      List allFavourites = jsonDecode(favorites);
      allFavourites.add(launchModel.toJson());
      await prefs.setString('favorites', jsonEncode(allFavourites));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future removeFavorites(launchModel, context) async {
    final prefs = await SharedPreferences.getInstance();
    String? favorites = prefs.getString('favorites');
    final snackBar = SnackBar(
      content: const Text('Removed from favorites'),
      backgroundColor: (const Color.fromARGB(137, 35, 0, 90)),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );

    List allFavourites = jsonDecode(favorites!);
    allFavourites.removeWhere((item) => item['mission'] == launchModel['mission'] &&  item['date'] == launchModel['date']);
    await prefs.setString('favorites', jsonEncode(allFavourites));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future getFavoriteLaunches() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? launches = prefs.getString('favorites');
      if (launches == null) {
        return [];
      }
      return jsonDecode(launches);
    } catch (exception) {
      return(exception.toString());

    }
  }
}
