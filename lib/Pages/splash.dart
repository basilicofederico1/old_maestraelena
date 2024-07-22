import 'package:flutter/material.dart';
import 'package:maestraelena_app/Pages/pages_controller.dart';
import 'package:maestraelena_app/Theme/app_style.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return const PagesController();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //set background color
        backgroundColor: paletteThird,
        body: Stack(children: [
          //logo fitted into round shape
          Container(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 200),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: paletteFifth),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          //brand name positioned bottom
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 26),
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/scrittaSolo.png'),
                      fit: BoxFit.fitHeight)),
            ),
          ),
        ]));
  }
}
