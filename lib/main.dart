import 'dart:io';
import 'package:alquranalkareem/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wakelock/wakelock.dart';
import 'data/data_client.dart';
import 'data/tafseer_data_client.dart';
import 'myApp.dart';
import 'bookmarks_notes_db/databaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.setAppGroupId('group.com.your-bundle-identifier');
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  // databaseFactory = databaseFactoryFfi;
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual, overlays: SystemUiOverlay.values, //This line is used for showing the bottom bar
  // );
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    windowSize();
  }
  Wakelock.enable();

  init();
  Bloc.observer = MyBlocObserver();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp(theme: ThemeData.light()));
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    String counter = '';
    await HomeWidget.getWidgetData<String>('_counter')
        .then((value) {
      counter = value!;
      // counter++;
    });
    await HomeWidget.saveWidgetData<String>('_counter', counter);
    await HomeWidget.updateWidget(
      //this must the class name used in .Kt
        name: 'HomeScreenWidgetProvider',
        iOSName: 'HomeScreenWidgetProvider');
  }
}

Future windowSize() async {
  await DesktopWindow.setMinWindowSize(const Size(900, 840));
}

init() async {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  databaseHelper.database;
  DataBaseClient dataBaseClient = DataBaseClient.instance;
  dataBaseClient.initDatabase();
  TafseerDataBaseClient tafseerDataBaseClient = TafseerDataBaseClient.instance;
  tafseerDataBaseClient.initDatabase();
}
