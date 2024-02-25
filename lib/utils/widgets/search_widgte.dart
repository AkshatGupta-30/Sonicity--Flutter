
// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/icon_park_twotone.dart';
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
        width: media.width/1.4, height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF151515),
          border: Border.all(color: accentColor.withOpacity(0.4), width: 2),
          borderRadius: BorderRadius.circular(50)
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GlowText(
                  "S", blurRadius: 25,
                  style: GoogleFonts.audiowide(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor, letterSpacing: 10,
                  )
                )
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GlowContainer(
                  blurRadius: 25,
                  child: Iconify(
                    IconParkTwotone.search,
                    color: accentColor, size: 32,
                  )
                )
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GlowText(
                  "nicity", blurRadius: 25,
                  style: GoogleFonts.audiowide(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor, letterSpacing: 10,
                  )
                )
              )
            ]
          ),
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