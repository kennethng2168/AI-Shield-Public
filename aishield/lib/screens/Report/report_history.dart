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
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
