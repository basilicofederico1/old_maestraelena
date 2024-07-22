import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maestraelena_app/Pages/post_square.dart';
import 'package:maestraelena_app/State/app_state.dart';
import '../Theme/app_style.dart';
import '../wp_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Future<dynamic> _posts = postLibrary;
  bool fullView = false;
  int lockedView = 0; //0=unlocked, 1=lockDown, 2=lockUp
  bool searchState = false; //bar
  bool searchPost = false;
  bool searchPage = false;
  bool showBackOnTop = false;
  bool loading = false;
  bool canScroll = true;
  bool canAutoLoad = true;
  bool fullLoaded = false;
  late int oldLength;
  late int newLength;
  String result = "";
  int homePageLoadedCount = 1;
  int searchPageLoadedCount = 1;
  late TextEditingController _textController;
  final ScrollController _scrollController = ScrollController();
  late Future<dynamic> searchPostList;
  late Future<dynamic> postShowed;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController.addListener(_scrollAutoLoad);
    _scrollController.addListener(_scrollBackOnTop);
    postShowed = _posts;
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void awaitForPostInitialization() async {
    while (!postInitialized) {
      if (postInitializedSuccesfullTrigger) {
        setState(() {
          _posts = postLibrary;
          postShowed = _posts;
          postInitializedSuccesfullTrigger = false;
          postInitialized = true;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _scrollBackOnTop() {
    if (_scrollController.position.pixels >= 500) {
      setState(() {
        showBackOnTop = true;
        if (lockedView == 0) {
          fullView = true;
        }
        if (lockedView == 1) {
          fullView = false;
        }
        if (lockedView == 2) {
          lockedView = 0;
        }
      });
    } else {
      setState(() {
        showBackOnTop = false;
        if (lockedView == 1) {
          lockedView = 0;
        }
        if (lockedView == 0) {
          fullView = false;
        }
        if (lockedView == 2) {
          fullView = true;
        }
      });
    }
  }

  void _scrollAutoLoad() {
    if (_scrollController.position.maxScrollExtent -
            _scrollController.position.pixels <=
        1000) {
      //need to add a restriction: search and home counter can't upgrade until loading ended;
      if (canAutoLoad == true) {
        if (searchPage == true) {
          setState(() {
            searchPageLoadedCount++;
            postShowed =
                getPostsFromKey(result, searchPageLoadedCount, websiteUrl);
            canAutoLoad = false;
            postShowed.then((value) {
              if (value is int) {
                canAutoLoad = false;
              } else {
                canAutoLoad = true;
                newLength = value.length;
                if (newLength == oldLength) {
                  fullLoaded = true;
                  canAutoLoad = false;
                }
                oldLength = newLength;
              }
            });
          });
        } else {
          setState(() {
            homePageLoadedCount++;
            postShowed = getLatestNumPosts(10, homePageLoadedCount, websiteUrl);
            canAutoLoad = false;
            postShowed.then((value) => canAutoLoad = true);
          });
        }
      }
    }
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void changeView() async {
    setState(() {
      fullView = !fullView;
      searchState = false;
      if (fullView) {
        lockedView = 2;
      } else {
        lockedView = 1;
      }
    });
  }

  void searchBarView() async {
    setState(() {
      searchState = !searchState;
      _textController.clear();
    });
  }

  String chooseImage() {
    Random randomInt = Random();
    String s = "";
    int randomNumber = randomInt.nextInt(1);
    switch (randomNumber) {
      case 0:
        s = 'assets/images/children_home.png';
        break;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    awaitForPostInitialization();
    return Scaffold(
      backgroundColor: homePageBackgroundColor,
      body: Stack(
        children: [
          //Image Children on top
          AnimatedOpacity(
            opacity: fullView ? 0.0 : 1.0,
            duration: const Duration(milliseconds: standardTransitionDuration),
            curve: standardCurveTransition,
            child: Container(
              alignment: Alignment.topCenter,
              child: AspectRatio(
                aspectRatio: homePageTopImageAspectRatio,
                child: Container(
                  margin: EdgeInsets.only(top: homePageTopOffset),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(chooseImage()),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //LOGO on top
          GestureDetector(
            onTap: changeView,
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20 * homePageTopOffset / 25),
              child: AspectRatio(
                aspectRatio: homePageTopLogoAspectRatio,
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
          ),

          //Image Clouds
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity?.compareTo(0) == -1) {
                //swipe down
                if (!fullView) {
                  changeView();
                }
              } else if (details.primaryVelocity?.compareTo(0) == 1) {
                //swipe up
                if (fullView) {
                  changeView();
                }
              }
            },
            onTap: changeView,
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              alignment: Alignment.topCenter,
              margin: fullView
                  ? EdgeInsets.only(top: deviceHeight / 10)
                  : EdgeInsets.only(
                      top: homePageTopImageHeight * 1.1 -
                          homePageTopCloudsOffset),
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
          ),

          //White Background
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity?.compareTo(0) == -1) {
                //swipe down
                if (!fullView) {
                  changeView();
                }
              } else if (details.primaryVelocity?.compareTo(0) == 1) {
                //swipe up
                if (fullView) {
                  changeView();
                }
              }
            },
            onTap: changeView,
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              margin: fullView
                  ? EdgeInsets.only(
                      top: (deviceHeight / 10) + homePageTopCloudsOffset)
                  : EdgeInsets.only(
                      top: (homePageTopImageHeight * 1.1) -
                          0.2 * homePageTopCloudsOffset),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),

          //Post Recenti - Ricerca Scritta
          AnimatedOpacity(
            duration:
                const Duration(milliseconds: standardTransitionDuration ~/ 3),
            curve: standardCurveTransition,
            opacity: fullView
                ? searchState
                    ? 0
                    : 1.0
                : 1.0,
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              alignment: searchState
                  ? fullView
                      ? Alignment.topLeft
                      : Alignment.topCenter
                  : Alignment.topCenter,
              margin: searchState
                  ? EdgeInsets.only(
                      top: fullView
                          ? 3.55 * homePageTopOffset
                          : homePageTopImageHeight * 1.15,
                      left: fullView ? 12 : 0)
                  : EdgeInsets.only(
                      top: fullView
                          ? 3.5 * homePageTopOffset
                          : homePageTopImageHeight * 1.14),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: searchPost ? "Risultati di '$result'" : "Post Recenti",
                  style: GoogleFonts.comicNeue(
                    color: homePageTitleColor,
                    fontSize: homePageTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          //underline
          AnimatedOpacity(
            duration:
                const Duration(milliseconds: standardTransitionDuration ~/ 3),
            curve: standardCurveTransition,
            opacity: fullView
                ? searchState
                    ? 0
                    : 1.0
                : 1.0,
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              alignment: searchState
                  ? fullView
                      ? Alignment.topLeft
                      : Alignment.topCenter
                  : Alignment.topCenter,
              margin: searchState
                  ? EdgeInsets.only(
                      top: fullView
                          ? 3.55 * homePageTopOffset + 20
                          : homePageTopImageHeight * 1.15 + 20,
                      left: fullView ? 12 : 0)
                  : EdgeInsets.only(
                      top: fullView
                          ? 3.5 * homePageTopOffset + 20
                          : homePageTopImageHeight * 1.14 + 20),
              child: Container(
                width: 100,
                height: 2,
                color: defaultOperationColor,
              ),
            ),
          ),

          //Search Bar Button
          AnimatedContainer(
              duration:
                  const Duration(milliseconds: standardTransitionDuration),
              curve: standardCurveTransition,
              alignment: fullView ? Alignment.topRight : Alignment.topCenter,
              margin: EdgeInsets.only(
                  top: fullView
                      ? 3.5 * homePageTopOffset
                      : homePageTopImageHeight * 1.04,
                  right: fullView ? 12 : 0,
                  left: searchState ? deviceWidth / 1.6 : 0),
              child: GestureDetector(
                onTap: searchBarView,
                child: Icon(
                  searchState ? Icons.cancel : Icons.search,
                  color: defaultOperationColor,
                ),
              )),

          //Back on top Button
          showBackOnTop
              ? loading
                  ? Container()
                  : AnimatedContainer(
                      duration: const Duration(
                          milliseconds: standardTransitionDuration),
                      curve: standardCurveTransition,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          top: fullView
                              ? 3.5 * homePageTopOffset
                              : homePageTopImageHeight * 1.12,
                          left: searchPage ? 48 : 12),
                      child: GestureDetector(
                        onTap: _scrollUp,
                        child: Icon(Icons.arrow_upward_rounded,
                            color: defaultOperationColor),
                      ))
              : Container(),

          //Back Button
          searchPost
              ? AnimatedContainer(
                  duration:
                      const Duration(milliseconds: standardTransitionDuration),
                  curve: standardCurveTransition,
                  alignment: fullView ? Alignment.topLeft : Alignment.topLeft,
                  margin: searchState
                      ? EdgeInsets.only(
                          top: fullView
                              ? 3.5 * homePageTopOffset
                              : homePageTopImageHeight * 1.13,
                          left: 14)
                      : EdgeInsets.only(
                          top: fullView
                              ? 3.5 * homePageTopOffset
                              : homePageTopImageHeight * 1.13,
                          left: 14),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchPage = false;
                        fullLoaded = false;
                        canAutoLoad = true;
                        searchPost = false;
                        postShowed = _posts;
                        searchPageLoadedCount = 1;
                        if (canScroll == true) {
                          _scrollUp();
                        }
                      });
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: defaultOperationColor,
                    ),
                  ))
              : AnimatedContainer(
                  duration:
                      const Duration(milliseconds: standardTransitionDuration),
                  curve: standardCurveTransition),

          //Search Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: standardTransitionDuration),
            curve: standardCurveTransition,
            alignment: fullView ? Alignment.topRight : Alignment.topCenter,
            margin: EdgeInsets.only(
                top: fullView
                    ? 3.47 * homePageTopOffset
                    : homePageTopImageHeight * 1.038,
                right: fullView ? 40 : 0),
            child: searchState
                ? SizedBox(
                    height: 26,
                    width: deviceWidth / 1.8,
                    child: TextField(
                        controller: _textController,
                        onSubmitted: (String str) {
                          setState(() {
                            fullLoaded = false;
                            canAutoLoad = true;
                            searchPageLoadedCount = 1;
                            result = str;
                            _textController.clear();
                            searchState = false;
                            searchPost = true;
                            canScroll = true;

                            loading = true;

                            postShowed = getPostsFromKey(
                                str, searchPageLoadedCount, websiteUrl);
                            postShowed.then((value) {
                              loading = false;
                              if (value is int) {
                                canAutoLoad = false;
                              } else {
                                oldLength = value.length;
                                if (oldLength <= 2) {
                                  canAutoLoad = false;
                                  fullLoaded = true;
                                }
                              }
                            });
                            searchPage = true;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Inserisci parola chiave",
                          prefixIcon: const Icon(Icons.search),
                        )))
                : AnimatedContainer(
                    duration: const Duration(
                        milliseconds: standardTransitionDuration),
                    curve: standardCurveTransition,
                  ),
          ),

          // Posts
          AnimatedContainer(
            duration: const Duration(milliseconds: standardTransitionDuration),
            curve: standardCurveTransition,
            margin: fullView
                ? EdgeInsets.only(
                    top: 4.3 * homePageTopOffset,
                  )
                : EdgeInsets.only(
                    top: (homePageTopImageHeight * 1.1) +
                        0.6 * homePageTopCloudsOffset,
                  ),
            child: FutureBuilder(
                future: postShowed,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == -1) {
                      canScroll = false;
                      return Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 48),
                          child: Column(
                            children: [
                              Icon(Icons.warning,
                                  size: 50, color: defaultOperationColor),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Non ho trovato nessun post",
                                  style: GoogleFonts.comicNeue(
                                    color: defaultOperationColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ));
                    } else if (snapshot.data == 0) {
                      canScroll = false;
                      return Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 48),
                          child: Column(
                            children: [
                              Icon(Icons.warning,
                                  size: 50, color: defaultOperationColor),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Impossibie connettersi al server",
                                  style: GoogleFonts.comicNeue(
                                    color: defaultOperationColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ));
                    } else if (snapshot.data == 3 || snapshot.data == 4) {
                      canScroll = false;
                      return Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 48),
                          child: Column(
                            children: [
                              Icon(Icons.warning,
                                  size: 50, color: defaultOperationColor),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      "Connessione a internet non disponibile",
                                  style: GoogleFonts.comicNeue(
                                    color: defaultOperationColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ));
                    } else {
                      canScroll = true;
                      return loading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: defaultOperationColor,
                            ))
                          : Stack(children: [
                              ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 30),
                                  itemCount: (snapshot.data.length + 1),
                                  itemBuilder: (context, index) {
                                    if (index != snapshot.data.length) {
                                      return MyPostSquare(
                                        child: snapshot.data[index],
                                      );
                                    } else {
                                      return fullLoaded
                                          ? Center(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text:
                                                      "Hai caricato tutti i post",
                                                  style: GoogleFonts.comicNeue(
                                                    color:
                                                        defaultOperationColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                ),
                                                CircularProgressIndicator(
                                                    color:
                                                        defaultOperationColor),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text:
                                                        "Sto caricando altri post",
                                                    style:
                                                        GoogleFonts.comicNeue(
                                                      color:
                                                          defaultOperationColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                    }
                                  }),
                            ]);
                    }
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: defaultOperationColor,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Sto scaricando i post dal sito",
                              style: GoogleFonts.comicNeue(
                                color: defaultOperationColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ),
          //
        ],
      ),
    );
  }
}
