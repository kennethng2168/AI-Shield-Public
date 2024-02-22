import 'dart:math';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';

import 'models/Detection.dart';
import 'report_details.dart';

class ProductListTile extends StatelessWidget {
  final Detection detection;
  final Function()? onPressed;
  final Function() onDelete;
  const ProductListTile(
      {required this.detection,
      this.onPressed,
      required this.onDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Slidable(
      key: const ValueKey(0), //simple value key
      endActionPane: ActionPane(
        // action pane for right side
        motion: const ScrollMotion(), // scroll motion
        children: [
          SlidableAction(
            onPressed: (c) => onDelete(), // function to delete
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReportDetails(detection: detection),
              // DashboardNUC(server: server),
            ),
          );
        },
        child: Container(
          width: screenSize.width,
          height: 120,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.5),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(10, 20),
                  blurRadius: 10,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.05)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: detection.detectionImageUrl != ""
                    ? Image.network(detection.detectionImageUrl ?? "",
                        height: 80, width: 80, fit: BoxFit.cover)
                    : Lottie.asset("assets/animations/empty_box.json",
                        repeat: false, height: 80, width: 80, fit: BoxFit.fill),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      detection.categories != ""
                          ? detection.categories ?? ""
                          : "Pending",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "Address: ",
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            detection.address ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "latitude: ",
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          detection.latitude,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "Longitude: ",
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          detection.longitude,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "Datetime: ",
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          detection.timestamp,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
