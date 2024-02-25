// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      width: media.width/1.25, height: media.width/1.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Shimmer>[
          Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey.shade500, highlightColor: Colors.grey.shade400,
            child: Container(
              width: media.width/1.25, height: media.width/1.25,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12)
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade50,
            direction: ShimmerDirection.ltr,
            period: Duration(milliseconds: 750),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: media.width/2, height: 20, color: Colors.black,),
                  SizedBox(height: 5),
                  Container(width: media.width/3, height: 14, color: Colors.black,),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class ShimmerCell extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  ShimmerCell({super.key, this.crossAxisAlignment = CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              period: Duration(milliseconds: 1000),
              baseColor: Colors.grey.shade500, highlightColor: Colors.grey.shade100,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            )
          ),
          SizedBox(height: 2),
          Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey.shade500, highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Container(width: 85, height: 12, color: Colors.black),
                  SizedBox(height: 1),
                  Container(width: 65, height: 9, color: Colors.black),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShimmerRow extends StatelessWidget {
  ShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade500, highlightColor: Colors.grey.shade100,
                child: Container(width: 60, height: 60, color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Container(height: 26, color: Colors.black),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsets.only(right: 125),
                    child: Container(height: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            Iconify(Ic.sharp_more_vert, size: 35)
          ]
        ),
      ),
    );
  }
}