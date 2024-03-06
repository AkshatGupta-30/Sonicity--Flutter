import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonicity/utils/widgets/iconify.dart';

class SearchShimmer extends StatelessWidget {
  SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: (Theme.of(context).brightness == Brightness.light) ? Colors.grey.shade900 : Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Container(// * Top Results Title
            height: 27.0, width: 125,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            )
          ),
          Gap(10),
          _listTile(),
          Gap(20),
          Row(// * Songs Title
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 27.0, width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              Spacer(),
              Container(
                height: 16.0, width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ],
          ),
          _listTile(), _listTile(), _listTile(),
          Gap(20),
          Row(// * Albums Title
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 27.0, width: 95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              Spacer(),
              Container(
                height: 16.0, width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ],
          ),
          _listTile(), _listTile(), _listTile(),
          Gap(20),
          Row(// * Artists Title
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 27.0, width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              Spacer(),
              Container(
                height: 16.0, width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ],
          ),
          _listTile(), _listTile(), _listTile(),
          Gap(20),
          Row(// * Playlists Title
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 27.0, width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              Spacer(),
              Container(
                height: 16.0, width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ],
          ),
          _listTile(), _listTile(), _listTile(),
        ],
      ),
    );
  }

  ListTile _listTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 60, width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        )
      ),
      title: Container(
        height: 18, margin: EdgeInsets.only(right: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        )
      ),
      subtitle: Container(
        height: 14, margin: EdgeInsets.only(right: 90),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        )
      ),
      trailing: Iconify(Ic.sharp_more_vert, size: 30),
    );
  }
}