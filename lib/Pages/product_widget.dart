import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maestraelena_app/Pages/product.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Theme/app_style.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  const ProductWidget(this.product, {super.key});

  @override
  State<ProductWidget> createState() {
    return _Product();
  }
}

class _Product extends State<ProductWidget> {
  bool showMore = false;

  String priceCorrection(double p) {
    String s;
    s = p.toStringAsFixed(2);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.product.name;
    final String mainImage = widget.product.mainImage;
    final String description = widget.product.description;
    final double price = widget.product.price;
    final String link = widget.product.link;

    String priceString = priceCorrection(price);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
          onTap: () {
            setState(() {
              showMore = !showMore;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: maxDarkestAppColor, width: 0.5),
              )),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  //NAME
                  GestureDetector(
                    onTap: () {
                      _launchUrl(link);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: name,
                        style: GoogleFonts.comicNeue(
                          color: defaultOperationColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //PRICE
                  Container(
                    margin: const EdgeInsets.only(top: 3.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "$priceString euro",
                        style: GoogleFonts.comicNeue(
                          color: primaryAppColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),

                  showMore
                      ? Column(
                          children: [
                            //IMAGE
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: AspectRatio(
                                    aspectRatio: 3 / 4.5,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 8,
                                            right: 4,
                                            left: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12.0)),
                                            border: Border.all(
                                              color: maxDarkestAppColor,
                                              width: 0.7,
                                            ),
                                            image: DecorationImage(
                                                image: NetworkImage(mainImage),
                                                onError:
                                                    (exception, stackTrace) {
                                                  const CircularProgressIndicator();
                                                },
                                                fit: BoxFit.cover))))),
                            //BUY
                            GestureDetector(
                                onTap: () {
                                  _launchUrl(link);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 15),
                                  child: Container(
                                    width: 200,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: paletteFirst,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0)),
                                      border: Border.all(
                                          color: maxDarkestAppColor,
                                          width: 0.6),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: "Compralo su Amazon!",
                                          style: GoogleFonts.comicNeue(
                                            color: maxDarkestAppColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),

                            //DESCRIPTION
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: description,
                                  style: GoogleFonts.comicNeue(
                                    color: maxDarkestAppColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              //IMAGE
                              Expanded(
                                  child: AspectRatio(
                                      aspectRatio: 3 / 4.5,
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 4,
                                              bottom: 8,
                                              right: 4,
                                              left: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              border: Border.all(
                                                color: maxDarkestAppColor,
                                                width: 0.7,
                                              ),
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(mainImage),
                                                  onError:
                                                      (exception, stackTrace) {
                                                    const CircularProgressIndicator();
                                                  },
                                                  fit: BoxFit.cover))))),
                              //DESCRIPTION
                              Flexible(
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 30),
                                  child: RichText(
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: description,
                                      style: GoogleFonts.comicNeue(
                                        color: maxDarkestAppColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                  //BUY
                  showMore
                      ? GestureDetector(
                          onTap: () {
                            _launchUrl(link);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: 200,
                              height: 30,
                              decoration: BoxDecoration(
                                color: paletteFirst,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                border: Border.all(
                                    color: maxDarkestAppColor, width: 0.6),
                              ),
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Compralo su Amazon!",
                                    style: GoogleFonts.comicNeue(
                                      color: maxDarkestAppColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      : Container(),
                  //LOAD MORE
                  Container(
                    padding: EdgeInsets.only(top: showMore ? 25.0 : 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: showMore
                            ? "Tocca per vedere meno"
                            : "Tocca per scoprire di più",
                        style: GoogleFonts.comicNeue(
                          color: maxDarkestAppColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //END MARGIN
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                ],
              ))),
    );
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
