
// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/views/navigation/searchview.dart';
import 'package:sonicity/utils/contants/colors.dart';

class SearchContainer extends StatelessWidget {
  final Size media;
  const SearchContainer({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => SearchView()),
      child: Container(
        height: 60, width: media.width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF151515),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.search, size: 30, color: Colors.cyanAccent),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                "Songs, albums, genre or artists", overflow: TextOverflow.ellipsis, maxLines: 1,
                style: TextStyle(fontSize: 21, color: Colors.grey)
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SearchBox extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSubmitted, onChanged;
  SearchBox({super.key, required this.onSubmitted, required this.onChanged, required this.searchController});

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Color(0xFF212121),
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.white,
      surfaceTintColor: Color(0xFF212121),
      child: Container(
        height: kBottomNavigationBarHeight,
        alignment: Alignment.center,
        child: TextField(
          controller: searchController,
          focusNode: focusNode,
          maxLines: 1,
          maxLength: 20,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          cursorColor: accentColor,
          style: TextStyle(color: Colors.white),
          onTapOutside: (event) => focusNode.unfocus(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Songs, albums or artists",
            hintStyle: TextStyle(color: Colors.grey),
            counterText: "",
            prefixIcon: BackButton(color: Colors.white,),
            suffixIcon: CloseButton(onPressed: () => searchController.clear(), color: Colors.white),
          ),
          onSubmitted: onSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}