import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../quran_text/model/bookmark_text.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 5;
  static const String tableNote = 'noteTable';
  static const String tableBookmarks = 'bookmarkTable';
  static const String tableBookmarksText = 'bookmarkTextTable';
  static const String tableAzkar = 'azkarTable';
  static const String columnId = 'id';
  static const String columnBId = 'id';
  static const String columnCId = 'id';
  static const String columnTId = 'id';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    // await initDatabase();
    _db = await initDb();
    return _db;
  }

  Future<Database?> initDb() async {
    // if (_db != null) {
    //   debugPrint('not null db');
    //   // return;
    // } else {
    sqfliteFfiInit();
    var androidDatabasesPath = await getDatabasesPath();
    var androidPath = p.join(androidDatabasesPath, 'notesBookmarks.db');
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = p.join(databasePath.path, 'notesBookmarks.db');
    return (Platform.isAndroid)
      ? openDatabase(androidPath,
        version: _version,
        readOnly: false,
        onUpgrade: onUpgrade,
        onCreate: onCreate)
        : (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: _version,
            readOnly: false,
            onUpgrade: onUpgrade,
            onCreate: onCreate))
        : openDatabase(path,
        version: _version,
        readOnly: false,
        onUpgrade: onUpgrade,
        onCreate: onCreate);
    // if(Platform.isAndroid){
    //   var databasesPath = await getDatabasesPath();
    //   var path = p.join(databasesPath, 'notesBookmarks.db');
    //   return openDatabase(path,
    //       version: _version,
    //       readOnly: false,
    //       // onUpgrade: onUpgrade,
    //       onCreate: onCreate);
    // } else {
    //   Directory databasePath = await getApplicationDocumentsDirectory();
    //   var path = p.join(databasePath.path, 'notesBookmarks.db');
    //   return (Platform.isWindows || Platform.isLinux)
    //       ? databaseFactoryFfi.openDatabase(path,
    //       options: OpenDatabaseOptions(
    //           version: _version,
    //           readOnly: false,
    //           // onUpgrade: onUpgrade,
    //           onCreate: onCreate))
    //       : openDatabase(path,
    //       version: _version,
    //       readOnly: false,
    //       // onUpgrade: onUpgrade,
    //       onCreate: onCreate);
    // }
    // var databasesPath = await getDatabasesPath();
    // var path = p.join(databasesPath, 'notesBookmarks.db');
    // Directory databasePath = await getApplicationDocumentsDirectory();
    // var path = p.join(databasePath.path, 'notesBookmarks.db');
    // return (Platform.isWindows || Platform.isLinux)
    //     ? databaseFactoryFfi.openDatabase(path,
    //         options: OpenDatabaseOptions(
    //             version: _version,
    //             readOnly: false,
    //             // onUpgrade: onUpgrade,
    //             onCreate: onCreate))
    //     : openDatabase(path,
    //         version: _version,
    //         readOnly: false,
    //         // onUpgrade: onUpgrade,
    //         onCreate: onCreate);
    /*try {
        var databasesPath = await getDatabasesPath();
        String _path = p.join(databasesPath, 'notesBookmarks.db');
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
              await db.execute(
                  'CREATE TABLE noteTable ('
                      'id INTEGER PRIMARY KEY, '
                      'title TEXT, '
                      'description TEXT)',
              );
              print('create noteTable');
              await db.execute(
                'CREATE TABLE bookmarkTable ('
                  'id INTEGER PRIMARY KEY, '
                  'sorahName TEXT, '
                  'pageNum INTEGER, '
                  'lastRead TEXT)',);
              print('create bookmarkTable');
              await db.execute(
                'CREATE TABLE azkarTable ('
                  'id INTEGER PRIMARY KEY, '
                  'category TEXT, '
                  'count TEXT, '
                  'description TEXT, '
                  'reference TEXT, '
                  'zekr TEXT)',);
              print('create azkarTable');
            }
        );
      } catch (e) {
        print(e);
      }*/
    // }
  }

  Future onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE bookmarkTextTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'sorahNum INTEGER, '
      'pageNum INTEGER, '
      'nomPageF INTEGER, '
      'nomPageL INTEGER, '
      'lastRead TEXT)',
    );
    print('create bookmarkTextTable');
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database onUpgrade');
    /*oldVersion < newVersion ? await db.execute(
      'CREATE TABLE bookmarkTextTable ('
          'id INTEGER PRIMARY KEY, '
          'sorahName TEXT, '
          'sorahNum INTEGER, '
          'pageNum INTEGER, '
          'nomPageF INTEGER, '
          'nomPageL INTEGER, '
          'lastRead TEXT)',
    )
        : print('Database up to date');*/
    // for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
    //   await db.execute(
    //     'CREATE TABLE bookmarkTextTable ('
    //         'id INTEGER PRIMARY KEY, '
    //         'sorahName TEXT, '
    //         'sorahNum INTEGER, '
    //         'pageNum INTEGER, '
    //         'nomPageF INTEGER, '
    //         'nomPageL INTEGER, '
    //         'lastRead TEXT)',
    //   );
    //   // switch (version) {
    //   //   case 1: {
    //   //     //Version 1 - no changes (won't enter here)
    //   //     break;
    //   //   }
    //   //   case 2: {
    //   //     await db.execute(
    //   //       'CREATE TABLE bookmarkTextTable ('
    //   //           'id INTEGER PRIMARY KEY, '
    //   //           'sorahName TEXT, '
    //   //           'sorahNum INTEGER, '
    //   //           'pageNum INTEGER, '
    //   //           'nomPageF INTEGER, '
    //   //           'nomPageL INTEGER, '
    //   //           'lastRead TEXT)',
    //   //     );
    //   //     break;
    //   //   }
    //   // }
    // }
    // switch (newVersion) {
    //   case 3:
    //     await db.execute(
    //       'CREATE TABLE bookmarkTextTable ('
    //           'id INTEGER PRIMARY KEY, '
    //           'sorahName TEXT, '
    //           'sorahNum INTEGER, '
    //           'pageNum INTEGER, '
    //           'nomPageF INTEGER, '
    //           'nomPageL INTEGER, '
    //           'lastRead TEXT)',
    //     );
    //     break;
    // }
    var results = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='bookmarkTextTable'");
    if (results.isEmpty) {
      await db.execute(
        'CREATE TABLE bookmarkTextTable ('
            'id INTEGER PRIMARY KEY, '
            'sorahName TEXT, '
            'sorahNum INTEGER, '
            'pageNum INTEGER, '
            'nomPageF INTEGER, '
            'nomPageL INTEGER, '
            'lastRead TEXT)',
      ); // add new column to existing table.
    }
    //   // await db.execute("ALTER TABLE bookmarkTextTable ADD COLUMN sorahNum TEXT");
    //   print('Database onUpgrade');
    //   // await db.execute("CREATE TABLE NewTable...") // create new Table
    // }
    // if (oldVersion < newVersion) {
    //   db.execute("ALTER TABLE bookmarkTextTable ADD COLUMN sorahNum TEXT;");
    //   print('Database onUpgrade');
    // }
  }

  /// bookmarks Text database
  static Future<int?> addBookmarkText(BookmarksText? bookmarksText) async {
    print('Save Text Bookmarks');
    try {
      return await _db!.insert(tableBookmarksText, bookmarksText!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmarkText(BookmarksText? bookmarksText) async {
    print('Delete Text Bookmarks');
    return await _db!.delete(tableBookmarksText,
        where: '$columnTId = ?', whereArgs: [bookmarksText!.id]);
  }

  static Future<int> updateBookmarksText(BookmarksText bookmarksText) async {
    print('Update Text Bookmarks');
    return await _db!.update(tableBookmarksText, bookmarksText.toJson(),
        where: "$columnTId = ?", whereArgs: [bookmarksText.id]);
  }

  static Future<List<Map<String, dynamic>>> queryT() async {
    print('get Text Bookmarks');
    return await _db!.query(tableBookmarksText);
  }


  Future close() async {
    return await _db!.close();
  }
}
