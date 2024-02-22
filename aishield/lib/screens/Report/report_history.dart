import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../models/Detection.dart';
import '../../project_list_tile.dart';
import '../../providers.dart';
import '../../utils/snackbars.dart';

class ReportHistory extends ConsumerStatefulWidget {
  const ReportHistory({Key? key}) : super(key: key);

  @override
  _ReportHistoryState createState() => _ReportHistoryState();
}

class _ReportHistoryState extends ConsumerState<ReportHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Detection>>(
      stream: ref.read(databaseProvider)?.getDetection(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        } else if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text("No Data Found"),
                Lottie.asset("assets/animations/datanotfound.json",
                    width: 300, repeat: true),
              ],
            ));
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final detection = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.5),
                child: ProductListTile(
                    detection: detection,
                    onDelete: () async {
                      deleteIconSnackBar(
                        context,
                        "Deleting item...",
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      );
                      await ref
                          .read(databaseProvider)!
                          .deleteDetection(detection.id!);
                    }),
              );

              // return NotificationItem(
              //   title: "test",
              //   icon: Icons.warning,
              //   day: 'Sun',
              //   shortContent: "",
              //   type: 'Fire Breakout Reports',
              //   isRead: false,
              // );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      // stream: (
      // color: Colors.white,
      // child: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     return NotificationItem(
      //       title: 'Fire Breakout in Balakong',
      //       icon: Icons.warning,
      //       day: 'Sun',
      //       shortContent:
      //           'Thanks for your information and your report has been verified',
      //       type: 'Fire Breakout Reports',
      //       isRead: false,
      //     );
      //   },
      // ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String type, title, shortContent, day;
  final IconData icon;
  final bool isRead;

  const NotificationItem(
      {Key? key,
      required this.type,
      required this.icon,
      required this.title,
      required this.shortContent,
      required this.day,
      required this.isRead})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              color: Color(0xFFFAD9D7),
              padding: EdgeInsets.all(10),
              child: Icon(
                icon,
                color: Colors.orange,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  shortContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
