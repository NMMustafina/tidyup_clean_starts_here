import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/dok_askbfgkahsdgbjs.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/moti_adsafusdkjfnbg.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/pro_idashfsjkdnfb.dart';

class Nfgjnj extends StatelessWidget {
  const Nfgjnj({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: const Color(0xff8157D8),
            fontSize: 28.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: MotiButaslmdf(
                onPressed: () {
                  lauchUrl(context, DokSS.priPoli);
                },
                child: Image.asset(
                  'assets/images/1.png',
                  width: 280.w,
                  height: 80.h,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            MotiButaslmdf(
              onPressed: () {
                lauchUrl(context, DokSS.priPoli);
              },
              child: Image.asset(
                'assets/images/2.png',
                width: 280.w,
                height: 80.h,
                // fit: BoxFit.cover,
              ),
            ),
            MotiButaslmdf(
              onPressed: () {
                lauchUrl(context, DokSS.priPoli);
              },
              child: Image.asset(
                'assets/images/3.png',
                width: 280.w,
                height: 80.h,
                // fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
