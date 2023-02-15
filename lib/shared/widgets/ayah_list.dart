import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../data/model/ayat.dart';
import '../../quran_text/cubit/audio/cubit.dart';
import '../../quran_text/cubit/quran_text_cubit.dart';

class AyahList extends StatefulWidget {
  int? pageNum;
  AyahList({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<AyahList> createState() => _AyahListState();
}

class _AyahListState extends State<AyahList> {
  double? isSelected;
  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    QuranTextCubit quranTextCubit = QuranTextCubit.get(context);
    return FutureBuilder<List<Ayat>>(
        future: quranTextCubit
            .handleRadioValueChanged(cubit.radioValue)
            .getPageTranslate(widget.pageNum!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Ayat>? ayat = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      border: Border.all(
                          color: ThemeProvider.themeOf(context).id == 'blue'
                              ? Theme.of(context).dividerColor.withOpacity(.6)
                              : const Color(0xffcdba72),
                          width: 2)),
                  child: Center(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: ayat!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, position) {
                        Ayat? aya = ayat![position];
                        return Opacity(
                          opacity: isSelected == position ? 1.0 : .5,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                cubit.translateAyah = "${aya.ayatext!}";
                                cubit.translate = "${aya.translate!}";
                                audioCubit.ayahNum = '${aya.ayaNum!}';
                                audioCubit.sorahName = '${aya.suraNum!}';
                                print(audioCubit.ayahNum);
                                isSelected = position.toDouble();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/ayah_no.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${arabicNumber.convert(aya.ayaNum)}",
                                    // "1",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Lottie.asset('assets/lottie/search.json',
                  width: 100, height: 40),
            );
          }
        });
  }
}
