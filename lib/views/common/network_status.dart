// Persistent Internet Banner
import 'package:flutter/material.dart';

Widget buildNoInternetBanner() {
  return Container(
    width: double.infinity, // Ensure it takes full width
    padding: const EdgeInsets.all(10),
    color: Colors.red,
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 20,),
            SizedBox(width: 12),
            Text(
              "No Internet Connection.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13,
                  fontStyle: FontStyle.normal, decoration: TextDecoration.none),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Live data updates are unavailable.",
          style: TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.normal,
              decoration: TextDecoration.none),
          textAlign: TextAlign.center, // Ensure proper alignment
        ),
      ],
    ),
  );
}