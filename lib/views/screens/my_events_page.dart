import 'package:easy_localization/easy_localization.dart';
import 'package:events_app/views/widgets/my_events/old_event_page.dart';
import 'package:events_app/views/widgets/my_events/organithed_event_page.dart';
import 'package:events_app/views/widgets/my_events/soon_event_page.dart';
import 'package:flutter/material.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<Widget> pages = [
    OrganithedEventPage(),
    SoonEventPage(),
    OldEventPage(),
  ];
  bool notification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "mening_tadbirlarim".tr(),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  size: 30,
                ),
                if (notification)
                  const Positioned(
                    right: 5,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              enableFeedback: true,
              isScrollable: true,
              indicatorWeight: 5,
              tabs: [
                Text("tashkil_qilganlarim".tr()),
                Text("yaqinda".tr()),
                Text("ishtirok_etganlarim".tr()),
                Text("bekor_qilganlarim".tr()),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  pages[0],
                  pages[1],
                  pages[2],
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text("index $index"),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
