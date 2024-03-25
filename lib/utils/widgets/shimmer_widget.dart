import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

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
            baseColor: Colors.grey,
            highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade600 :  Colors.grey.shade400,
            child: Container(
              width: media.width/1.25, height: media.width/1.25,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12)
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300,
            highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
            direction: ShimmerDirection.ltr,
            period: Duration(milliseconds: 750),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 0, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(10),
                  Row(children: [
                    Spacer(),
                    Iconify(
                      Ic.sharp_more_vert, size: 32,
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
                    ),
                    Gap(6)
                    ]
                  ),
                  Spacer(),
                  Container(
                    width: media.width/2, height: 20,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                  ),
                  Gap(5),
                  Container(
                    width: media.width/3, height: 14,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                  ),
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
              baseColor: Colors.grey,
              highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            )
          ),
          Gap(2),
          Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey,
            highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Container(width: 85, height: 12, color: Colors.black),
                  Gap(1),
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
        baseColor: Colors.grey,
        highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
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
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Container(height: 26, color: Colors.black),
                  ),
                  Gap(3),
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