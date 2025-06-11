import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidyup_clean_starts_here_272_a/ifrusdhubh/jfgriwhvb.dart';
import 'package:tidyup_clean_starts_here_272_a/ifrusdhubh/nfgjnjofjngb.dart';
import 'package:tidyup_clean_starts_here_272_a/ifrusdhubh/ufsbgvh.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/color_ashfuoajfdgb.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/moti_adsafusdkjfnbg.dart';

import '../screens/chores_main_screen.dart';

class SSBotomBar extends StatefulWidget {
  const SSBotomBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<SSBotomBar> createState() => SSBotomBarState();
}

class SSBotomBarState extends State<SSBotomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 115.h,
        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          color: Colorasdf.background,
          // borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colorasdf.black,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
          // border: Border(
          //     top: BorderSide(
          //   color: Color(0xff308AFF),
          // )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildNavItem(
                0,
                'assets/icons/1.png',
                'assets/icons/11.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                1,
                'assets/icons/2.png',
                'assets/icons/22.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                2,
                'assets/icons/3.png',
                'assets/icons/33.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                3,
                'assets/icons/4.png',
                'assets/icons/44.png',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath, String ima2) {
    bool isActive = _currentIndex == index;

    return MotiButaslmdf(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        // width: isActive ? 130.w : 60.w,
        color: Colors.transparent,
        // decoration: BoxDecoration(
        //   color: isActive ? Colorasdf.blue : Colors.white.withOpacity(0.0),
        //   borderRadius: BorderRadius.circular(14),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isActive ? 1 : 0.5,
                child: Image.asset(
                  iconPath,
                  // width: 86.w,
                  // height: 61.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _pages = <Widget>[
    const ChoresMainScreen(),
    const Askfmgjn(),
    Jfg(),
    const Nfgjnj(),
  ];
}
