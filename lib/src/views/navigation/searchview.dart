// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/controllers/searchview_controller.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/search_history_cells.dart';
import 'package:sonicity/utils/widgets/search_widgte.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final searchViewCont = Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return ColoredBox(
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Obx(
              () {
                return Container(
                  width: media.width, height: media.height,
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 55,
                          child: SearchBox(
                            searchController: searchViewCont.searchController,
                            onChanged: (text) => searchViewCont.searchChanged(text),
                            onSubmitted: (text) => searchViewCont.searchSubmitted(text),
                          )
                        ),
                        const SizedBox(height: 12),
                        if(searchViewCont.historyList.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(// * : Heading
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "History",
                                style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 25, ),
                              ),
                            ),
                            Wrap(// * : All History Cells
                              alignment: WrapAlignment.start,
                              children: searchViewCont.historyList.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final String itemText = entry.value;
                                return SearchHistoryCell(
                                  itemText: itemText,
                                  onTap: () => searchViewCont.chipTapped(index),
                                  onRemove: () => searchViewCont.chipRemoved(index),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}