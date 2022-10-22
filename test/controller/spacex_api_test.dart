import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launch_tracker/controller/spacex_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MockBuildContext extends Spacex implements BuildContext {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  var api = Spacex();

  test('Get upcoming launches', () async {
    var launches = await api.upcomingLaunches();
    expect(launches.isNotEmpty, equals(true));
  });

  test('Get next launch', () async {
    var launch = await api.nextLaunch();
    expect(jsonEncode(launch).isNotEmpty, equals(true));
  });

  test('Get favorite launches', () async {
    var fav_launches = await api.getFavoriteLaunches();
    expect(fav_launches != null, equals(true));
  });

}
