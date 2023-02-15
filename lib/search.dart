import 'dart:convert';
import 'dart:io';
import 'package:alquranalkareem/quran_text/model/QuranModel.dart';
import 'package:alquranalkareem/quran_text/text_page_view.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class SearchQuranScreen extends StatefulWidget {
  SearchQuranScreen({Key? key}) : super(key: key);
  @override
  State<SearchQuranScreen> createState() => _SearchQuranScreenState();
}
class _SearchQuranScreenState extends State<SearchQuranScreen> {
  TextEditingController controller = TextEditingController();
  List <AyahDetails>serchList = [];
  Map tafMap = {};
  List myMap=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  textAlign: TextAlign.start,
                  onSubmitted: (v){controller.clear();
                  controller.text='';
                    setState(() {

                    });
                    },
                  onTap: () {
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

                  },
                  onChanged: (v) async {

                    List myMap = await readJsonFile();
                    tafMap = await readJsonFile2();
                    controller.text = v;
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                    serchList =await getAyaDetailsListRelatedToSearchQuery(v);
                    // serchList.where((element) =>
                    // ( element.aya_text_emlaey.toString().replaceAll(" ", "").contains(v.replaceAll(" ", ""))|| element.aya_text_emlaey.toString().replaceAll(" ", "").endsWith(v.replaceAll(" ", ""))|| element.aya_text_emlaey.toString().replaceAll(" ", "").startsWith(v.replaceAll(" ", ""))))
                    //     .toList();
                    setState(() {});
                    print(
                        myMap.where((element) =>  element["kalemah_no_tashkeel"].toString().contains(v)).toList()
                    );
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'البحث',
                    prefixIcon: Icon(
                      Icons.search_outlined,
                    ),
                 )

                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context,int index)=> Divider(),
                itemCount: serchList.length,
                itemBuilder: (context, index) {
                  // List serchList=  myMap.where((element) =>  element["kalemah_no_tashkeel"].toString().contains(v)).toList();
                  // print(tafMap["data"]["surahs"]
                //         [int.parse(serchList[index].sura_no.toString()) - 1]["ayahs"]
                  //     [int.parse(serchList[index].aya_no.toString())];
                  Map ayat = tafMap["data"]["surahs"]
                          [int.parse(serchList[index].sura_no.toString()) - 1]["ayahs"]
                      [int.parse(serchList[index].aya_no.toString()) - 1];

                  Map<String, dynamic> sura = tafMap["data"]["surahs"]
                      [int.parse(serchList[index].sura_no.toString()) - 1];
                  return InkWell(
                    onTap: () {
                      // print(ayat);
                      // print(ayat["page"]);
                      Navigator.of(context).push(animatRoute(TextPageView(
                        surah: SurahText.fromJson(sura),
                        // surah[index],
                        nomPageF: int.parse(ayat["page"].toString()),
                        nomPageL: int.parse(ayat["page"].toString()),
                      )));
                      // print("surah: ${surah[index]}");
                      // print("nomPageF: ${surah[index].ayahs!.first.page!}");
                      // print("nomPageL: ${surah[index].ayahs!.last.page!}");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [





                          Text('اسم السورة : ${serchList[index].sura_name_ar}',textAlign: TextAlign.end,style: TextStyle(
                          fontWeight: FontWeight.bold),),
                          Text(' الايه : ${serchList[index].aya_text_emlaey}',textAlign: TextAlign.end,style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),

                          // Text(ayat["text"]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<Database> getQuranAyahDetailsDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "app.db");
// Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
// Should happen only the first time you launch your application
      print("Creating new copy from asset");
// Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
// Copy from asset
      ByteData data =
      await rootBundle.load(join("assets/json", "search.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    var database = await openDatabase(path, readOnly: false, version: 1);
    return database;
  }
   Future<List<AyahDetails>> getAyaDetailsListRelatedToSearchQuery(
      String ayaQuery) async {
    Database ayaDetailsDatabase = await getQuranAyahDetailsDatabase();
    List<Map<String, dynamic>> maps = await ayaDetailsDatabase.query('quraan',
        where: 'aya_text_emlaey LIKE "$ayaQuery%" OR aya_text_emlaey LIKE "%$ayaQuery%"');
    return List.generate(maps.length, (i) {
      return AyahDetails(
          id: maps[i]['id'],
          jozz: maps[i]['jozz'],
          sura_no: maps[i]['sura_no'],
          sura_name_en: maps[i]['sura_name_en'],
          sura_name_ar: maps[i]['sura_name_ar'],
          page: maps[i]['page'],
          line_start: maps[i]['line_start'],
          line_end: maps[i]['line_end'],
          aya_no: maps[i]['aya_no'],
          aya_text: maps[i]['aya_text'],
          aya_text_emlaey: maps[i]['aya_text_emlaey'],
          aya_pos_in_file: maps[i]['aya_pos_in_file']
      );
    });
  }
  var tafser;
  Future readJsonFile() async {
    tafser = await rootBundle.loadString('assets/json tafser words/qw-1.json');
    // print("asasasasaaajsonAfterEdits${tafser}");
    var jsonAfterEdit = await jsonDecode(tafser);
    // print("jsonAfterEdit$jsonAfterEdit");
    // items.add(jsonAfterEdit);
    // print("asasasasasaasxxa${jsonAfterEdit}");
    return jsonAfterEdit;
    // String tafserAfterEdit = tafser;
    //  .replaceAll('ref_number', 'ref');
    //     .replaceAll('word_w_tashkeel', '')
    //     .replaceAll('kalemah_tafseer', '')
    //     .replaceAll('sorah_name', '')
    //     .replaceAll('kalemah_root', '')
    //     .replaceAll('kalemah_no_tashkeel', '')
    //     .replaceAll('kalemah_num_in_ayah', '')
    //     .replaceAll('kalemat_count_in_ayah', '')
    //     .replaceAll('sorah_number', '');
  }
  Future readJsonFile2() async {
    tafser = await rootBundle.loadString('assets/json/quran.json');
    // print("asasasasaaajsonAfterEdits${tafser}");
    var jsonAfterEdit = await jsonDecode(tafser);
    // print("jsonAfterEdit$jsonAfterEdit");
    // items.add(jsonAfterEdit);
    // print("asasasasasaasxxa${jsonAfterEdit}");
    return jsonAfterEdit;
    // String tafserAfterEdit = tafser;
    //  .replaceAll('ref_number', 'ref');
    //     .replaceAll('word_w_tashkeel', '')
    //     .replaceAll('kalemah_tafseer', '')
    //     .replaceAll('sorah_name', '')
    //     .replaceAll('kalemah_root', '')
    //     .replaceAll('kalemah_no_tashkeel', '')
    //     .replaceAll('kalemah_num_in_ayah', '')
    //     .replaceAll('kalemat_count_in_ayah', '')
    //     .replaceAll('sorah_number', '');
  }
}
class AyahDetails {
  final int id;
  final int jozz;
  final int sura_no;
  final String sura_name_en;
  final String sura_name_ar;
  final int page;
  final int line_start;
  final int line_end;
  final int aya_no;
  final String aya_text;
  final String aya_text_emlaey;
  final String aya_pos_in_file;
  AyahDetails({
    required this.id,
    required this.jozz,
    required this.sura_no,
    required this.sura_name_en,
    required this.sura_name_ar,
    required this.page,
    required this.line_start,
    required this.line_end,
    required this.aya_no,
    required this.aya_text,
    required this.aya_text_emlaey,
    required this.aya_pos_in_file
  });
  // Convert an Object into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jozz': jozz,
      'sura_no': sura_no,
      'sura_name_en': sura_name_en,
      'sura_name_ar': sura_name_ar,
      'page': page,
      'line_start': line_start,
      'line_end': line_end,
      'aya_no': aya_no,
      'aya_text': aya_text,
      'aya_text_emlaey': aya_text_emlaey,
      'aya_pos_in_file': aya_pos_in_file
    };
  }
  // Implement toString to make it easier to see information about
  //each dog when using the print statement.
  @override
  String toString() {
    return 'AyahDetails{id: $id, jozz: $jozz, sura_no: $sura_no, sura_name_ar: $sura_name_ar, page: $page, aya_no: $aya_no, aya_text: $aya_text, aya_text_emlaey: $aya_text_emlaey, aya_pos_in_file: $aya_pos_in_file }';
  }
}
Widget defaultFormField(
    context, {
      required TextEditingController controller,
      required TextInputType type,
      String? Function(String?)? onSubmit,
      String? Function(String?)? onChange,
      Function()? onTap,
      bool isPassword = false,
      required String? Function(String?)? validate,
      required String label,
      required IconData prefix,
      IconData? suffix,
      Function()? suffixPressed,
      bool isClickable = true,
    }) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
            color: Colors.grey,
          ),
        )
            : null,
      ),
      style: Theme.of(context).textTheme.bodyText1,
    );