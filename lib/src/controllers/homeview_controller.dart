import 'package:get/get.dart';
import 'package:sonicity/src/models/home.dart';
import 'package:sonicity/src/services/home_view_api.dart';

class HomeViewController extends GetxController {
  final home = Home.empty().obs;

  @override
  void onReady() {
    getHome();
    super.onReady();
  }

  void getHome() async {
    Home data = await HomeViewApi.get();
    home.value = data;
  }
}