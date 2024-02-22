// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sonicity/src/views/navigation/homeview.dart';
import 'package:sonicity/utils/contants/colors.dart';
import 'package:sonicity/utils/widgets/bottom_nab_bar_tab.dart';
import 'package:sonicity/src/views/library/library_view.dart';

class NavigationView extends StatefulWidget {
  NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> with SingleTickerProviderStateMixin {
  int _selectedTab = 1;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: _selectedTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(child: Text("Queue", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
          HomeView(),
          LibraryView()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: TabBar(
        controller: tabController,
        indicatorColor: Colors.transparent,
        dividerHeight: 0,
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
        labelColor: accentColor,
        unselectedLabelColor: Colors.white,
        isScrollable: false,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        onTap: (value) => setState(() => _selectedTab = value),
        tabs: [
          Tabs(thisTab: 0, selectedTab: _selectedTab, icon: Icons.queue_music_rounded, label: "Queue"),
          Tabs(thisTab: 1, selectedTab: _selectedTab, icon: Icons.home_rounded, label: "Home"),
          Tabs(thisTab: 2, selectedTab: _selectedTab, icon: Icons.library_music_rounded, label: "Library"),
        ],
      ),
    ),
    );
  }
}