import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/app_style.dart';

class DevelopmentPage extends StatefulWidget {
  const DevelopmentPage({super.key});

  @override
  State<DevelopmentPage> createState() {
    return _DevelopmentPage();
  }
}

class _DevelopmentPage extends State<DevelopmentPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    const logoAR = 8 / 2;
    final topCloudOff = (58 * deviceWidth) / 300;

    return Scaffold(
      backgroundColor: homePageBackgroundColor,
      body: Stack(
        children: [
          //LOGO
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20 * homePageTopOffset / 25),
            child: AspectRatio(
              aspectRatio: logoAR,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/scrittaSolo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          //CLOUDS
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: deviceHeight / 10),
            child: AspectRatio(
              aspectRatio: 10 / 2,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/clouds.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),

          //WHITE BCK
          Container(
            margin: EdgeInsets.only(top: (deviceHeight / 10) + topCloudOff),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),

          //TEXT
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "L'applicazione è al momento in manutenzione. Si prega di riprovare più tardi!",
                  style: GoogleFonts.comicNeue(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
