import 'dart:async';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:launch_tracker/widgets/custom_text.dart';
import '../controller/spacex_api.dart';
import 'package:flutter_share/flutter_share.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  var launch;
  late Timer timer;
  String days = '0';
  String hours = '0';
  String minutes = '0';
  String seconds = '0';
  late String date;

  Widget currentPage =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  Future<void> share(mission, date) async {
    await FlutterShare.share(
        title: 'Next Mission Launch', text: 'Mission: $mission, Date: $date');
  }

  getNextLaunch() async {
    final api = Spacex();
    launch = await api.nextLaunch();

    date = launch.date;
    var launchDate = DateTime.parse(date);
    var now = DateTime.now();
    var differenceInSeconds = (launchDate.difference(now).inSeconds);

    Duration duration = Duration(seconds: differenceInSeconds);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        final _seconds = duration.inSeconds - 1;
        duration = Duration(seconds: _seconds);

        days = (duration.inDays.remainder(7)).toString();
        hours = (duration.inHours.remainder(24)).toString();
        minutes = (duration.inMinutes.remainder(60)).toString();
        seconds = (duration.inSeconds.remainder(60)).toString();
        currentPage = buildContent();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNextLaunch();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }

  buildContent() {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 53, 57, 1),
      appBar: AppBar(
        title: Text(launch.mission),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color.fromRGBO(79, 190, 184, 1),
                Color.fromRGBO(84, 112, 122, 1)
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(days.toString(),
                  style: const TextStyle(fontSize: 60, color: Colors.white))),
          Center(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'DAYS',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Center(
              child: Text(hours.toString(),
                  style: const TextStyle(fontSize: 60, color: Colors.white))),
          Center(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'HOURS',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Center(
              child: Text(minutes.toString(),
                  style: TextStyle(fontSize: 60, color: Colors.white))),
          Center(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'MINUTES',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Center(
              child: Text(
            seconds.toString(),
            style: const TextStyle(fontSize: 60, color: Colors.white),
          )),
          Center(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'SECONDS',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                share(launch.mission, Jiffy(launch.date).format('dd/MM/yy'));
              },
              child: Column(
                children: const [
                   Icon(Icons.ios_share,color: Colors.white,),
                   CustomText(text: 'Share')
                ],
              ))
        ],
      ),
    );
  }
}
