import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maestraelena_app/Pages/single_post.dart';
import 'package:maestraelena_app/post.dart';
import '../Theme/app_style.dart';

/*
  //this one increment the event that permit me to know how many people click on this post
  FirebaseAnalytics.instance.logEvent(
    name: 'post_click',
    parameters: {'post_id': '12345'},
  );
*/

class MyPostSquare extends StatefulWidget {
  final Post child;
  const MyPostSquare({super.key, required this.child});

  @override
  State<MyPostSquare> createState() {
    return _MyPostSquare();
  }
}

class _MyPostSquare extends State<MyPostSquare> {
  // functional variable
  late bool imageLoaded;
  double ar = 10 / 9;
  late double imgAr;
  final double maxHorRatio = 14 / 9;
  final double maxVerRatio = 4 / 6;
  final double ratioTriggerValue = 1.0;
  late bool layoutTrigger;
  late bool imgCanBeLoad;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: widget.child.hasImage
          ? FutureBuilder(
              future: widget.child.image,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //Inside here if image has been loaded
                  if (snapshot.data != "-1") {
                    imgCanBeLoad = true;
                    imageLoaded = true;
                    imgAr = widget.child.imgRatio;
                    widget.child.myImageLink = snapshot.data.toString();
                    // max ratio horizontal
                    if (imgAr > maxHorRatio) {
                      imgAr = maxHorRatio;
                    }
                    //max ratio vertical
                    if (imgAr < maxVerRatio) {
                      imgAr = maxVerRatio;
                    }
                    if (imgAr > ratioTriggerValue) {
                      layoutTrigger = true;
                    } else {
                      layoutTrigger = false;
                    }
                  } else {
                    imgCanBeLoad = false;
                    imageLoaded = true;
                    imgAr = 13 / 9;
                    layoutTrigger = true;
                  }
                } else {
                  //Inside here if image has not been loaded
                  imageLoaded = false;
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 4),
                  child: AspectRatio(
                      aspectRatio: ar,
                      // POST BOX
                      child: GestureDetector(
                          onTap: () => setState(() {
                                if (imageLoaded) {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SinglePostPage(widget.child),
                                        transitionDuration:
                                            const Duration(milliseconds: 100),
                                        reverseTransitionDuration:
                                            const Duration(milliseconds: 100),
                                      ));
                                }
                              }),
                          //
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: postSquareBorderWidth,
                                      color: postSquareBorderColor),
                                  /*
                                  bottom: BorderSide(
                                      width: postSquareBorderWidth,
                                      color: postSquareBorderColor),
                                  */
                                ),
                              ),
                              child: Column(
                                children: [
                                  //TITLE
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: widget.child.title,
                                        style: GoogleFonts.comicNeue(
                                          color: postSquareTitleColor,
                                          fontSize: postSquareTitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //DATE
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: const EdgeInsets.only(top: 2),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: widget.child.dateString,
                                        style: GoogleFonts.comicNeue(
                                          color: postSquareDateColor,
                                          fontSize: postSquareDateSize,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //IMAGE AND DESCRIPTION
                                  //Switch based on the image ratio
                                  imageLoaded
                                      ? layoutTrigger
                                          //Horizontal Image
                                          ? Expanded(
                                              child: widget.child.hasDescription
                                                  ? Column(
                                                      children: [
                                                        //IMAGE
                                                        Expanded(
                                                            child: AspectRatio(
                                                                aspectRatio:
                                                                    imgAr,
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 10.0,
                                                                      bottom: 8,
                                                                      right: 4,
                                                                      left: 4),
                                                                  decoration: imgCanBeLoad
                                                                      ? BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                                                          border: Border.all(
                                                                            color: const Color.fromARGB(
                                                                                183,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                0.7,
                                                                          ),
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(snapshot.data.toString()),
                                                                              onError: (exception, stackTrace) {
                                                                                const CircularProgressIndicator();
                                                                              },
                                                                              fit: BoxFit.cover))
                                                                      : BoxDecoration(
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(12.0)),
                                                                          border:
                                                                              Border.all(
                                                                            color: const Color.fromARGB(
                                                                                183,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            width:
                                                                                0.7,
                                                                          ),
                                                                          image: const DecorationImage(
                                                                              image: AssetImage('assets/images/missing_image.jpg'),
                                                                              fit: BoxFit.fitWidth),
                                                                        ),
                                                                ))),
                                                        //DESCRIPTON
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 6,
                                                                  right: 6,
                                                                  bottom: 6),
                                                          child: RichText(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            maxLines: 6,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            text: TextSpan(
                                                              text: widget.child
                                                                  .description,
                                                              style: GoogleFonts
                                                                  .comicNeue(
                                                                color:
                                                                    postSquareDescriptionColor,
                                                                fontSize:
                                                                    postSquareDescriptionSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Center(
                                                      child: AspectRatio(
                                                          aspectRatio: imgAr,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    bottom: 8,
                                                                    right: 4,
                                                                    left: 4),
                                                            decoration: imgCanBeLoad
                                                                ? BoxDecoration(
                                                                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                                                    border: Border.all(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          183,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      width:
                                                                          0.7,
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(snapshot.data.toString()),
                                                                        onError: (exception, stackTrace) {
                                                                          const CircularProgressIndicator();
                                                                        },
                                                                        fit: BoxFit.cover))
                                                                : BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            12.0)),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          183,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      width:
                                                                          0.7,
                                                                    ),
                                                                    image: const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/missing_image.jpg'),
                                                                        fit: BoxFit
                                                                            .fitWidth),
                                                                  ),
                                                          ))),
                                            )
                                          //Vertical Image
                                          : Expanded(
                                              child: widget.child.hasDescription
                                                  ? Row(
                                                      children: [
                                                        //DESCRIPTON
                                                        Flexible(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 6,
                                                                    right: 6,
                                                                    bottom: 6),
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 13,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: TextSpan(
                                                                text: widget
                                                                    .child
                                                                    .description,
                                                                style: GoogleFonts
                                                                    .comicNeue(
                                                                  color:
                                                                      postSquareDescriptionColor,
                                                                  fontSize:
                                                                      postSquareDescriptionSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //IMAGE
                                                        Expanded(
                                                            child: AspectRatio(
                                                                aspectRatio:
                                                                    imgAr,
                                                                child: Container(
                                                                    margin: const EdgeInsets.only(top: 4, bottom: 8, right: 4, left: 4),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                                                        border: Border.all(
                                                                          color: const Color.fromARGB(
                                                                              183,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          width:
                                                                              0.7,
                                                                        ),
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(snapshot.data.toString()),
                                                                            onError: (exception, stackTrace) {
                                                                              const CircularProgressIndicator();
                                                                            },
                                                                            fit: BoxFit.cover))))),
                                                      ],
                                                    )
                                                  : Center(
                                                      child: AspectRatio(
                                                          aspectRatio: imgAr,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    bottom: 8,
                                                                    right: 4,
                                                                    left: 4),
                                                            decoration: imgCanBeLoad
                                                                ? BoxDecoration(
                                                                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                                                    border: Border.all(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          183,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      width:
                                                                          0.7,
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(snapshot.data.toString()),
                                                                        onError: (exception, stackTrace) {
                                                                          const CircularProgressIndicator();
                                                                        },
                                                                        fit: BoxFit.cover))
                                                                : BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            12.0)),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          183,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      width:
                                                                          0.7,
                                                                    ),
                                                                    image: const DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/missing_image.jpg'),
                                                                        fit: BoxFit
                                                                            .fitWidth),
                                                                  ),
                                                          ))),
                                            )

                                      //IMAGE NOT LOADED YET
                                      : Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 60),
                                            child: CircularProgressIndicator(
                                                color: defaultOperationColor),
                                          ),
                                        ),
                                ],
                              ))

                          //
                          )),
                );
              })
          : Padding(
              //Inside here if post has not an image to load
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 4),
              child: AspectRatio(
                  aspectRatio: ar,
                  // YELLOW BOX
                  child: GestureDetector(
                    onTap: () => setState(() {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SinglePostPage(widget.child),
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 100),
                          ));
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: postSquareBorderWidth,
                              color: postSquareBorderColor),
                          bottom: BorderSide(
                              width: postSquareBorderWidth,
                              color: postSquareBorderColor),
                        ),
                      ),
                      //
                      child: Column(
                        children: [
                          //TITLE
                          Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: widget.child.title,
                                style: GoogleFonts.comicNeue(
                                  color: postSquareTitleColor,
                                  fontSize: postSquareTitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          //DATE
                          Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 2),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: widget.child.dateString,
                                style: GoogleFonts.comicNeue(
                                  color: postSquareDateColor,
                                  fontSize: postSquareDateSize,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                              child: Column(
                            children: [
                              //IMAGE
                              Expanded(
                                  child: AspectRatio(
                                      aspectRatio: 13 / 9,
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 8,
                                              right: 4,
                                              left: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    183, 0, 0, 0),
                                                width: 0.7,
                                              ),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/missing_image.jpg'),
                                                  fit: BoxFit.fitWidth))))),
                              //DESCRIPTON
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 0, left: 6, right: 6, bottom: 6),
                                child: RichText(
                                  textAlign: TextAlign.justify,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: widget.child.description,
                                    style: GoogleFonts.comicNeue(
                                      color: postSquareDescriptionColor,
                                      fontSize: postSquareDescriptionSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  )),
            ),
    );
  }
}
