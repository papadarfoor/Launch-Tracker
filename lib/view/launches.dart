import 'package:flutter/material.dart';
import 'package:launch_tracker/controller/spacex_api.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:launch_tracker/widgets/custom_text.dart';

class UpcomingLaunches extends StatefulWidget {
  const UpcomingLaunches({super.key});

  @override
  State<UpcomingLaunches> createState() => _UpcomingLaunchesState();
}

class _UpcomingLaunchesState extends State<UpcomingLaunches> {
  late List launches;
  var favorites;
  Widget currentPage = const Center(child: CircularProgressIndicator());
  getUpcomingLaunches() async {
    final api = Spacex();
    launches = await api.upcomingLaunches();
    setState(() {
      currentPage = buildContent();
    });
  }

  Future<void> addFavorite(launchModel, context) async {
    final api = Spacex();
    await api.addFavorites(launchModel, context);
  }

  @override
  void initState() {
    super.initState();
    getUpcomingLaunches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(48, 38, 52, 1),
        appBar: AppBar(
          title: const Text('Upcoming Launches'),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(156, 76, 130, 1),
                  Color.fromRGBO(75, 29, 92, 1)
                ],
              ),
            ),
          ),
        ),
        body: currentPage);
  }

  buildContent() {
    return Column(
      children: [
        const ListTile(
          title: Text(
            'Mission',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          trailing: Text(
            'Date(UTC)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 2,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: launches.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await addFavorite(launches[index], context);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.favorite,
                            label: 'Favorite',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          launches[index].mission,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Jiffy(launches[index].date).format('dd/MM/yy'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 5,),
                            const Icon(
                              Icons.swipe_left_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
