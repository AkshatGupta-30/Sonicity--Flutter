import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
class SearchShimmer extends StatelessWidget {
  SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: (theme.brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          _title(),
          Gap(10),
          _cell(),
          Gap(20),
          _viewAllTitle(),
          _listView(),
          Gap(20),
          _viewAllTitle(),
          _listView(),
          Gap(20),
        ],
      ),
    );
  }

  Container _title() {
    return Container(// * Top Results Title
      height: 22.0, width: 125,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      )
    );
  }

  Row _viewAllTitle() {
    return Row(// * Songs Title
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 22.0, width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
          )
        ),
        Spacer(),
        Container(
          height: 16.0, width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
          )
        ),
      ],
    );
  }

  Container _cell() {
    return Container(
      width: 140, alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 140, width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            )
          ),
          Gap(2),
          Container(
            height: 14, width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            )
          ),
          Gap(1),
          Container(
            height: 11, width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            )
          )
        ],
      ),
    );
  }

  SizedBox _listView() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: 3, scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _cell(),
      ),
    );
  }
}