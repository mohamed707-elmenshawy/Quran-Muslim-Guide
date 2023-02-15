import 'dart:async';
import 'package:alquranalkareem/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../quran_text/text_page_view.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';




class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(SoundPageState());

  static QuranCubit get(context) => BlocProvider.of(context);


  late PageController pageController;
  late int currentPage;
  int? current;
  late int currentIndex;
  bool isShowControl = true;
  bool isShowBookmark = true;
  String translateAyah = '';
  String translate = '';
  String textTranslate = '';
  String? value;
  double? height;
  double width = 800;
  double height2 = 2000;
  double width2 = 4000;
  String? title;
  bool? isPageNeedChange;
  late int radioValue;
  int? tafseerValue;
  int tafIbnkatheer = 1;
  int tafBaghawy = 2;
  int tafQurtubi = 3;
  int tafSaadi = 4;
  int tafTabari = 5;
  var showTaf;
  late Database database;
  PageController? dPageController;
  String? lastSorah;

  ///The controller of sliding up panel
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController controller;
  late Animation<Offset> offset;
  SharedPreferences? prefs;
  String? sorahName;
  String? soMName;
  Locale? initialLang;
  bool opened = false;
  late int cuMPage;
  late int lastBook;



// Save & Load Font Size
  saveTafseer(int radioValue) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setInt("tafseer_val", radioValue);
    emit(SharedPreferencesState());
  }

  loadTafseer() async {
    SharedPreferences prefs = await _prefs;
    radioValue = prefs.getInt('tafseer_val') ?? 0;
    print('get tafseer value ${prefs.getInt('tafseer_val')}');
    print('get radioValue $radioValue');
    emit(SharedPreferencesState());
  }
  /// Shared Preferences


  // Save & Load Quran Text Font Size
  saveQuranFontSize(double fontSizeArabic) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_quran_size", fontSizeArabic);
    emit(SharedPreferencesState());
  }
  loadQuranFontSize() async {
    SharedPreferences prefs = await _prefs;
    TextPageView.fontSizeArabic = prefs.getDouble('font_quran_size') ?? 18;
    print('get font size ${prefs.getDouble('font_quran_size')}');
    emit(SharedPreferencesState());
  }


  // Save & Load Last Page For Quran Page
  saveLang(String lan) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString("lang", lan);
    emit(SharedPreferencesState());
  }
  loadLang() async {
    SharedPreferences prefs = await _prefs;
    initialLang = prefs.getString("lang") == null ? const Locale('ar', 'AE')
        : Locale(prefs.getString("lang")!);
    print('get lang $initialLang');
    emit(SharedPreferencesState());
  }




  showControl() {
    isShowControl = !isShowControl;
    emit(QuranPageState());
  }




  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
          scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    isShowControl = false;
    isShowBookmark = false;
    title = null;
    isPageNeedChange = false;
    loadLang();
    emit(QuranPageState());
  }



  @override
  void dispose() {
    dPageController?.dispose();
    emit(QuranPageState());
  }


  bool isShowBottomSheet = false;
  IconData searchFabIcon = Icons.search_outlined;
  IconData sorahFabIcon = Icons.list_alt_outlined;
  IconData bookmarksFabIcon = Icons.bookmarks_outlined;



  void sorahCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    sorahFabIcon = icon;
    emit(CloseBottomShowState());
  }
  void searchCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(CloseBottomShowState());
  }
  void sorahChangeBottomSheetState({
  required bool isShow,
    required IconData icon,
}){
    isShowBottomSheet = isShow;
    sorahFabIcon = icon;
    emit(ChangeBottomShowState());
  }
  void searchChangeBottomSheetState({
  required bool isShow,
    required IconData icon,
}){
    isShowBottomSheet = isShow;
    searchFabIcon = icon;
    emit(ChangeBottomShowState());
  }


  /// Time

  // var now = DateTime.now();
  String lastRead = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";


}
