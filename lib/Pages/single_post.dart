import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../State/app_state.dart';
import '../Theme/app_style.dart';
import '../post.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class SinglePostPage extends StatefulWidget {
  final Post post;
  const SinglePostPage(this.post, {super.key});

  @override
  State<SinglePostPage> createState() {
    return _SinglePostPage();
  }
}

class _SinglePostPage extends State<SinglePostPage> {
  @override
  Widget build(BuildContext context) {
    String title = widget.post.title;
    String date = widget.post.dateString;
    bool hasMainImage = widget.post.hasImage;
    String link = widget.post.link;
    late String mainImage;
    late double mainImageRatio;
    late bool mainImageIsVertical;
    if (hasMainImage) {
      mainImage = widget.post.myImageLink;
      mainImageRatio = widget.post.imgRatio;
      if (mainImageRatio < 1) {
        mainImageIsVertical = true;
      } else {
        mainImageIsVertical = false;
      }
    } else {}

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    const logoAR = 8 / 2;
    final topCloudOff = (58 * deviceWidth) / 300;

    //this one increment the event that permit me to know how many people click on this post
    if (online && firebaseInitialized) {
      FirebaseAnalytics.instance.logEvent(
        name: 'post_clicks',
        parameters: {'post_title': title},
      );
    }

    return Scaffold(
      backgroundColor: homePageBackgroundColor,
      body: Stack(
        children: [
          //LOGO
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: deviceHeight / 27),
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

          //BACK BUTTON
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(top: deviceHeight / 15, left: 12),
              child: const Icon(Icons.arrow_back_rounded),
            ),
          ),

          //POST
          Container(
            margin: EdgeInsets.only(top: deviceHeight / 5.2),
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 6, right: 6),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0.0, bottom: 30),
              children: [
                Column(
                  children: [
                    //date
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: date,
                        style: GoogleFonts.comicNeue(
                          color: const Color.fromARGB(255, 129, 129, 129),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    //title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: title,
                          style: GoogleFonts.comicNeue(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //WEB ICON
                    IconButton(
                      onPressed: () {
                        _launchUrl(link);
                      },
                      icon: const Icon(Icons.link),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    //image
                    hasMainImage
                        ? Column(children: [
                            Container(
                                margin: mainImageIsVertical
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 25.0)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                child: AspectRatio(
                                    aspectRatio: mainImageRatio,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    183, 0, 0, 0),
                                                width: 0.7,
                                              ),
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(mainImage),
                                                  onError:
                                                      (exception, stackTrace) {
                                                    const CircularProgressIndicator();
                                                  },
                                                  fit: BoxFit.cover))),
                                    ))),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                            ),
                          ])
                        : Container(),
                    //Content
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      //to be replaced with the widget of the http page
                      child: Html(
                        data: widget.post.contentRaw,
                        style: {
                          "p": Style(
                            fontSize: const FontSize(15.0),
                            textAlign: TextAlign.center,
                          ),
                          "li": Style(
                            fontSize: const FontSize(15.0),
                            textAlign: TextAlign.justify,
                          ),
                        },
                        onAnchorTap: (_, __, data, ___) {
                          //something to get the link "clear"
                          String hyperlink;
                          if (isDownloadLink(data)) {
                            hyperlink = data["data-downloadurl"]!;
                            _launchUrl(hyperlink);
                          } else {
                            hyperlink = data["href"]!;
                            _launchUrl(hyperlink);
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                    ),
                    //View this post on the website
                    GestureDetector(
                      onTap: () {
                        _launchUrl(link);
                      },
                      child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 250, 229),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 45, 21, 0),
                                      width: 0.5),
                                ),
                              ),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        "Premi per visualizzare questo post sul sito",
                                    style: GoogleFonts.comicNeue(
                                      color:
                                          const Color.fromARGB(255, 45, 21, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool isDownloadLink(link) {
  String s = link["href"];
  if (s == '#') {
    return true;
  } else {
    return false;
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
