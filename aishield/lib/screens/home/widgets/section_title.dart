import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:social_share/social_share.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Flexible(
            child: Text(
              "$title ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFFEBEBEB),
            ),
            child: Icon(
              LineAwesomeIcons.arrow_right,
              size: 16,
            ),
          ),
          const Spacer(),
          title == "Risks"
              ? GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        "Share Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.share)
                    ],
                  ),
                  onTap: () async {
                    Position _currentLocation =
                        await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                    SocialShare.shareOptions("Emergency Current Location: " +
                        'https://www.google.com/maps/search/?api=1&query=${_currentLocation.latitude},${_currentLocation.longitude}');
                  },
                )
              : Container(),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
