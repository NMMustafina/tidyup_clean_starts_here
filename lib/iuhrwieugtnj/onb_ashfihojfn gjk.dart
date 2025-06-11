import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/botbar_ashgfsafgb.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/color_ashfuoajfdgb.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/moti_adsafusdkjfnbg.dart';

class OnBoDiasdf extends StatefulWidget {
  const OnBoDiasdf({super.key});

  @override
  State<OnBoDiasdf> createState() => _OnBoDiasdfState();
}

class _OnBoDiasdfState extends State<OnBoDiasdf> {
  final PageController _controller = PageController();
  int introIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorasdf.background,
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                introIndex = index;
              });
            },
            children: const [
              OnWid(
                image: '1',
              ),
              OnWid(
                image: '2',
              ),
              OnWid(
                image: '3',
              ),
            ],
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const SlideEffect(
                      dotColor: Color(0xffBF90FF),
                      activeDotColor: Color(0xff8157D8),
                      dotWidth: 12,
                      dotHeight: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 680.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MotiButaslmdf(
                  onPressed: () {
                    if (introIndex != 2) {
                      _controller.animateToPage(
                        introIndex + 1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SSBotomBar(),
                        ),
                        (protected) => false,
                      );
                    }
                  },
                  child: Container(
                    height: 55,
                    width: 300.w,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xffFF77FB),
                          Color(0xff8968FF),
                        ],
                      ),
                      // color: const Color(0xff308AFF),

                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Text(
                        introIndex != 2 ? 'Next' : 'Start',
                        style: const TextStyle(
                          color: Colorasdf.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnWid extends StatelessWidget {
  const OnWid({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/on$image.png',
      height: 812.h,
      width: 305.w,
      fit: BoxFit.cover,
      // alignment: Alignment.bottomCenter,
    );
  }
}
