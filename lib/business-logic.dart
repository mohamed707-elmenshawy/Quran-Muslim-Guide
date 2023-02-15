// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:math' as math;
//
//
//
// class BusinessLogic extends ChangeNotifier {
//   List items = [];
//   String tafser = '';
//   List<Widget> quranPage = [];
//   dynamic value;
//   dynamic number;
//   String? response;
//   PageController pageViewCtr = PageController();
//   double _MinNumber = 0.008;
//   String mySouranum = "";
//   List<String> tafseerInPage = [];
//
//   /// This method responsaple for display quran pages
//   Future parseData({context}) async {
//     // print("inmmmj");
//     for (int index = 1; index <= 604; index++) {
//       response =
//           await rootBundle.loadString('assets/Quran Pages/page$index.txt');
//       mySouranum = response.toString();
//       // print(jsonDecode(response.toString())["sora"]);
//       var change = response
//           .toString()
//           .replaceAll('*2*', '')
//           .replaceAll('0', '٠')
//           .replaceAll("@", '')
//           .replaceAll("S", '')
//           .replaceAll("\u200F", "")
//           .replaceAll('1', '١')
//           .replaceAll("\u200F", "")
//           .replaceAll("{", "")
//           .replaceAll("}", "")
//           .replaceAll('2', '٢')
//           .replaceAll("\u200F", "")
//           .replaceAll('3', '٣')
//           .replaceAll("\u200F", "")
//           .replaceAll('4', '٤')
//           .replaceAll("\u200F", "")
//           .replaceAll('5', '٥')
//           .replaceAll("\u200F", "")
//           .replaceAll('6', '٦')
//           .replaceAll("\u200F", "")
//           .replaceAll('7', '٧')
//           .replaceAll("\u200F", "")
//           .replaceAll('8', '٨')
//           .replaceAll("\u200F", "")
//           .replaceAll('9', '٩')
//           .replaceAll('2‏S', '')
//           .replaceAll(RegExp(' +'), ' ');
//       var concatenate = StringBuffer();
//
//       // print("change$change");
//       change.split(' ').forEach((element) {
//         if (RegExp(r'^[0-9]+$').hasMatch(element)) {
//           element = '5';
//         }
//         element = element + ' ';
//         index == 1 || index == 2 ? print(element) : null;
//         concatenate.write(element);
//       });
//       var lines = await concatenate.toString().split('\n');
//       // print("concatenate $concatenate");
//       var word = number = index;
//       // index == 1 ? print("lines $lines") : null;
//
//       List<Widget> textLines = [];
//       for (var i in lines) {
//         // i = i.split('(').first;
//         //   print("aaaaaaaaaaaaaaaaaaaaaa2 $i");
//
//         textLines.add(
//           Center(
//             child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: index == 0 || index == 1
//                     ? Column(
//                         children: [
//                           WordSelectableText(
//                             text: i,
//
//                             onWordTapped: (word, inde) async {
//                               List mytafs = await getAyatInPage(index);
//
// // print(mytafs);
//
//                               // print(Arabic_Tools().RemoveTashkeel(word));
//
//                               Map aya = mytafs.firstWhere((element) =>
//                                   element['aya_text_emlaey']
//                                       .toString()
//                                       .contains(
//                                           Arabic_Tools().RemoveTashkeel(word)));
//                               print(aya);
//                               getTafseerMuyassar(aya["sura_no"], aya["aya_no"])
//                                   .then(
//                                 (value) => showDialog(
//                                     context: context,
//                                     builder: (x) {
//                                       // print("the value ${value}");
//
//                                       return Dialog(
//                                         child: Text(value),
//                                       );
//                                     }),
//                               );
//
//                               // print(
//                               //     "aya in pagess   ${mytafs}");
//                             },
//                             // textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontFamily: 'Schyler',
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       )
//                     : Expanded(
//                       child: Container(
//                         width: MediaQuery.of(context).size.width *0.93,
//                         color: Colors.blue,
//                         child: Center(
//                           child: FittedBox(
//                             child: WordSelectableText(
//                               text: i,
//                               onWordTapped: (word, i) async {
//                                 /// progres
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                           height: 30,
//                                           width: 30,
//                                           child: CircularProgressIndicator()),
//                                     ],
//                                   ),
//                                 );
//                                 List ayatDetails = await getAyatInPage(index);
//
//                                 List trfs = await readJsonFile();
//
//                                 Navigator.pop(context);
//
//                                 showModalBottomSheet(
//                                   context: context,
//                                   builder: (context) {
//                                     return Padding(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Text(
//                                         "${trfs.firstWhere((element) => element["word_w_tashkeel"].toString().contains(word) && element["soura_nu"].toString() == ayatDetails[0]["sura_no"].toString())["word_w_tashkeel"].toString()} : ${trfs.firstWhere((element) => element["word_w_tashkeel"].toString().contains(word) && element["soura_nu"].toString() == ayatDetails[0]["sura_no"].toString())["kalemah_tafseer"].toString()}",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//
//                               // textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 fontFamily: 'Schyler',
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )),
//           ),
//         );
//       }
//
//       // textLines.add((Container(
//       //     decoration: BoxDecoration(
//       //         color: Colors.amber, borderRadius: BorderRadius.circular(8)),
//       //     child: Text(
//       //       number.toString(),
//       //       style: const TextStyle(
//       //         fontSize: 15,
//       //         color: Colors.black,
//       //       ),
//       //     )),));
//       quranPage.add(
//         flap(
//             Size(MediaQuery.of(context).size.height,
//                 MediaQuery.of(context).size.width),
//             index == 1 || index == 2
//                 ? SafeArea(
//                     child: Container(
//                     height: MediaQuery.of(context).size.height,
//                     child: Stack(
//                       children: [
//                         Image(
//                           image: AssetImage("assets/images/edit.jpeg"),
//                         ),
//                         Container(
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: textLines),
//                         )
//                       ],
//                     ),
//                   ))
//                 : Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Stack(
//                       children: [
//                         Image(
//                           height: MediaQuery.of(context).size.height,
//                           width: MediaQuery.of(context).size.width,
//                           image: const AssetImage("assets/images/j.jpeg"),
//                         ),
//                         // Image(
//                         //   height: MediaQuery.of(context).size.height,
//                         //   width: MediaQuery.of(context).size.width,
//                         //   image: const AssetImage("assets/pages-png/000604.png"),
//                         // ),
//                         // Image(
//                         //   height: MediaQuery.of(context).size.height,
//                         //   width: MediaQuery.of(context).size.width,
//                         //   image: const AssetImage("assets/pages-png/00604.png"),
//                         // ),
//
//                         Container(
//                           height: double.infinity,
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: textLines),
//                         )
//                       ],
//                     ),
//                   )),
//       );
//       notifyListeners();
//     }
//     notifyListeners();
//   }
//
//   /// This method responsaple for animation package
//   Widget flap(Size size, Widget page) {
//     GlobalKey<FlipWidgetState> flipKey = GlobalKey();
//     Offset oldPosition = Offset.zero;
//     bool visible = true;
//     return Column(
//       children: [
//         Visibility(
//           visible: visible,
//           child: Expanded(
//             child: Container(
//               child: GestureDetector(
//                 child: FlipWidget(
//                   key: flipKey,
//                   //textureSize: size * 2,
//                   child: Container(
//                     child: Center(child: page),
//                   ),
//                 ),
//                 onHorizontalDragStart: (details) {
//                   oldPosition = details.globalPosition;
//                   flipKey.currentState?.startFlip();
//                 },
//                 onHorizontalDragUpdate: (details) {
//                   Offset off = details.globalPosition - oldPosition;
//                   double tilt = 1 / _clampMin((-off.dy + 20) / 100);
//                   double percent = math.max(0,- off.dx / size.width * 1.4);
//                   percent = percent - percent / 2 * (1 - 1 / tilt);
//                   // if (details.delta.dx > 0) {
//                   //   percent = -percent;
//                   //   tilt=-tilt;
//                   // }
//                   flipKey.currentState?.flip(percent, tilt);
//                   print('/////////////////////////////////');
//
//                   print(details.delta.dx);
//                 },
//                 onHorizontalDragEnd: (details) {
//                   flipKey.currentState?.stopFlip();
//                   //   print(details.primaryVelocity);
//                   if (details.primaryVelocity! < -300) {
//                     // pageViewCtr.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
//                     if ((pageViewCtr.page ?? 0) < 604)
//                       pageViewCtr.jumpToPage(pageViewCtr.page!.toInt() + 1);
//                   } else if (details.primaryVelocity! > 300) {
//                     if ((pageViewCtr.page ?? 0) > -1)
//                       pageViewCtr.jumpToPage(pageViewCtr.page!.toInt() - 1);
//                   }
//                 },
//                 onHorizontalDragCancel: () {
//                   flipKey.currentState?.stopFlip();
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// ///This method related animation package
// double _MinNumber = 0.008;
// var tafser;
// var items;
//
// double _clampMin(double v) {
//   if (v < _MinNumber && v > -_MinNumber) {
//     if (v >= 0) {
//       v = _MinNumber;
//     } else {
//       v = -_MinNumber;
//     }
//   }
//   return v;
// }
//
// Future readJsonFile() async {
//   tafser = await rootBundle.loadString('assets/json tafser words/qw-1.json');
//   // print("asasasasaaajsonAfterEdits${tafser}");
//
//   var jsonAfterEdit = await jsonDecode(tafser);
//   // print("jsonAfterEdit$jsonAfterEdit");
//   // items.add(jsonAfterEdit);
//
//   // print("asasasasasaasxxa${jsonAfterEdit}");
//   return jsonAfterEdit;
//   // String tafserAfterEdit = tafser;
//   //  .replaceAll('ref_number', 'ref');
//   //     .replaceAll('word_w_tashkeel', '')
//   //     .replaceAll('kalemah_tafseer', '')
//   //     .replaceAll('sorah_name', '')
//   //     .replaceAll('kalemah_root', '')
//   //     .replaceAll('kalemah_no_tashkeel', '')
//   //     .replaceAll('kalemah_num_in_ayah', '')
//   //     .replaceAll('kalemat_count_in_ayah', '')
//   //     .replaceAll('sorah_number', '');
// }
