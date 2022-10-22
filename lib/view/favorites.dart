import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:launch_tracker/widgets/custom_text.dart';
import '../controller/spacex_api.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late List launches;
  var favorites;
  Widget currentPage = const Center(child: CircularProgressIndicator());
  getFavoriteLaunches() async {
    final api = Spacex();
    launches = await api.getFavoriteLaunches();
    setState(() {
      currentPage = buildContent();
    });
  }

  Future<void> removeFavorite(launchModel, context) async {
    final api = Spacex();
    await api.removeFavorites(launchModel, context);
    setState(() {
      getFavoriteLaunches();
    });
  }

  @override
  void initState() {
    super.initState();
    getFavoriteLaunches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 34, 48),
        appBar: AppBar(
          title: const Text('Favorites'),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromARGB(255, 60, 0, 165),
                  Color.fromARGB(255, 7, 0, 70)
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
          title:CustomText(text: 'Mission'), 
          trailing: CustomText(text: 'Date (UTC)')
          
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
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await removeFavorite(launches[index], context);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.remove_circle_rounded,
                            label: 'Remove',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: 
                        CustomText(text: launches[index]['mission']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(text: Jiffy(launches[index]['date']).format('dd/MM/yy')),
                            const SizedBox(width: 5,),
                            const Icon(
                              Icons.swipe_left_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        )
                          
                        
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
