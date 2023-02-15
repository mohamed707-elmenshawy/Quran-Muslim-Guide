import 'dart:convert';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../data/model/sorah.dart';
import '../data/repository/sorah_repository.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/widgets.dart';
import 'text_page_view.dart';
import 'model/QuranModel.dart';
import 'repository/quranApi.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart' as rootBundle;

class SorahListText extends StatefulWidget {
  const SorahListText({super.key});

  @override
  _SorahListTextState createState() => _SorahListTextState();
}

class _SorahListTextState extends State<SorahListText>
    with SingleTickerProviderStateMixin {
  SorahRepository sorahRepository = SorahRepository();
  List<Sorah>? sorahList;
  final ScrollController controller = ScrollController();
  var sorahListKey = GlobalKey<ScaffoldState>();
  Widget? textPage;

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getList() async {
    sorahRepository.all().then((values) {
      setState(() {
        sorahList = values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    QuranServer quranServer = QuranServer();
    ArabicNumbers arabicNumber = ArabicNumbers();
    return Scaffold(
      key: TScaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                      future: quranServer.QuranData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<SurahText> surah = snapshot.data!;
                          return sorahList == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: CircularProgressIndicator()),
                                    ],
                                  ),
                                )
                              : AnimationLimiter(
                                  child: Scrollbar(
                                    controller: controller,
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: surah.length,
                                        controller: controller,
                                        itemBuilder: (_, index) {
                                          Sorah? sorahT = sorahList?[index];
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 450),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        animatRoute(
                                                            TextPageView(

                                                      surah: surah[index],
                                                      nomPageF: surah[index]
                                                          .ayahs!
                                                          .first
                                                          .page!,
                                                      nomPageL: surah[index]
                                                          .ayahs!
                                                          .last
                                                          .page!,
                                                    )));
                                                    print(
                                                        "surah: ${surah[index]}");
                                                    print(
                                                        "nomPageF: ${surah[index].ayahs!.first.page!}");
                                                    print(
                                                        "nomPageL: ${surah[index].ayahs!.last.page!}");
                                                  },
                                                  child: Container(
                                                      height: 60,
                                                      color: (index % 2 == 0
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .background
                                                          : Theme.of(context)
                                                              .dividerColor
                                                              .withOpacity(.3)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/svg/sora_num.svg',
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .surface,
                                                                    )),
                                                                Text(
                                                                    arabicNumber.convert(surah[
                                                                            index]
                                                                        .number
                                                                        .toString()),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .surface,
                                                                    )),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/svg/surah_name/00${index + 1}.svg',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface,
                                                                  width: 100,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child: Text(
                                                                    sorahT?.nameEn ??
                                                                        "",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "kufi",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          10,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .surface,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "| عدد الآيات |",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "uthman",
                                                                    fontSize:
                                                                        12,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "| ${arabicNumber.convert(sorahT?.ayaCount ?? "0")} |",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "kufi",
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                );
                        } else {
                          return Center(
                            child: Lottie.asset('assets/lottie/loading.json',
                                width: 200, height: 200),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<SurahText>> QuranData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/quran.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => SurahText.fromJson(e)).toList();
  }
}
