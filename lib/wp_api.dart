import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:maestraelena_app/State/app_state.dart';
import 'dart:convert';
import 'package:maestraelena_app/post.dart';
import 'package:maestraelena_app/downloaded_posts.dart';

const timeout = 5;

//this function will return a list of every post downloaded during the session ordered by the newest
Future<dynamic> getLatestNumPosts(int num, int page, String addr) async {
  final String address = addr;
  //print("page $page");
  //get the link
  final link = Uri.parse(postsPerPageLink(address, num, page));
  bool internetTimeout = false;

  //inizia il countdown per la return di "Nessuna connessione a internet"
  Future.delayed(const Duration(seconds: timeout)).then((value) {
    if (!online) {
      //inside here if there is no connection at the timeout
      internetTimeout = true;
      //print("TimeoutScaduto - Connessione assente");
    }
  });

  //controlla la connessione a internet ogni tot secondi
  while (!online && !internetTimeout) {
    await Future.delayed(const Duration(seconds: 1));
  }

  //print("Setpoint");
  //print("ConnectionStatus: $connectionStatus");
  if (online) {
    //fetch the data from link
    final response =
        await http.get(link, headers: {"Accept": "application/json"});

    //check connection to server
    if (response.statusCode == 200) {
      //decode data
      var data = jsonDecode(response.body);
      //check for how many posts you got
      int realNum = data.length;
      if (realNum > 0) {
        //create a list and save inside the ID of each post
        var postsList = List.empty(growable: true);
        for (int i = 0; i < realNum; i++) {
          if (data[i]["status"] == "publish") {
            postsList.add(data[i]['id']);
          }
        }

        // add to downloadedPosts the newest post ID
        addNewPostFromID(downloadedPosts, postsList, data);
        //print("Post aggiornati e connessione presente");
        if (!postInitialized) {
          postInitializedSuccesfullTrigger = true;
        }
        return downloadedPosts;
      } else {
        return -1;
      }
    } else {
      if (page == 1) {
        // If the server did not return a 200 OK response, then throw an exception.
        postInitializedTrigger = true;
        return 0;
      } else {
        postInitialized = true;
        return downloadedPosts;
      }
    }
  } else {
    // La connessione a Internet non è disponibile.
    //print("Connessione a internet non dispobile");
    if (page == 1) {
      postInitializedTrigger = true;
      return 3; //Error code
    } else {
      postInitialized = true;
      return downloadedPosts;
    }
  }
}

Future<dynamic> getPostsFromKey(String key, int page, String addr) async {
  int num = 5;

  if (page == 1) {
    downloadedSearchPosts = List.empty(growable: true);
  }
  final String address = addr;

  final link = Uri.parse(postsSearchKeyLink(address, key, num, page));

  bool internetTimeout = false;

  //inizia il countdown per la return di "Nessuna connessione a internet"
  Future.delayed(const Duration(seconds: timeout)).then((value) {
    if (!online) {
      //inside here if there is no connection at the timeout
      internetTimeout = true;
      //print("TimeoutScaduto - Connessione assente");
    }
  });

  //controlla la connessione a internet ogni tot secondi
  while (!online && !internetTimeout) {
    await Future.delayed(const Duration(seconds: 1));
  }

  //print("Setpoint");
  if (online) {
    final response =
        await http.get(link, headers: {"Accept": "application/json"});

    //check connection to server
    if (response.statusCode == 200) {
      //decode data
      var data = jsonDecode(response.body);
      //set realNumber of posts
      int realNum = data.length;
      if (realNum > 0) {
        //create a list and save inside the ID of each post
        var postsList = List.empty(growable: true);
        for (int i = 0; i < realNum; i++) {
          if (data[i]["status"] == "publish") {
            postsList.add(data[i]['id']);
          }
        }

        // add to downloadedPosts the newest post ID
        addNewPostFromID(downloadedSearchPosts, postsList, data);

        return downloadedSearchPosts;
      } else {
        return -1;
      }
    } else {
      if (page == 1) {
        // If the server did not return a 200 OK response, then throw an exception.
        return 0;
      } else {
        return downloadedSearchPosts;
      }
    }
  } else {
    // La connessione a Internet non è disponibile.
    //print("Connessione a internet non dispobile");

    if (page == 1) {
      return 4; //Error code
    } else {
      return downloadedSearchPosts;
    }
  }
}

String postsPerPageLink(String address, int num, int page) {
  String finalString;
  finalString =
      "$address/wp-json/wp/v2/posts?categories=237&per_page=$num&page=$page";
  return finalString;
}

String postsSearchKeyLink(String address, String key, int n, int page) {
  String finalString;
  finalString =
      "$address/wp-json/wp/v2/posts?per_page=$n&search=$key&page=$page";
  return finalString;
}

void addNewPostFromID(downloadedList, list, data) {
  if (downloadedList.length != 0) {
    for (int i = 0; i < list.length; i++) {
      bool flag = false;
      for (int j = 0; j < downloadedList.length && flag == false; j++) {
        if (list[i] == downloadedList[j].id) {
          flag = true;
        }
      }
      if (flag == false) {
        //generate post obj
        Post post = Post(data[i]);
        downloadedList.add(post);

        if (data[i]['_links']['wp:featuredmedia'] != null) {
          post.hasImage = true;
        } else {
          post.hasImage = false;
        }

        if (post.hasImage == true) {
          post.imageLink = data[i]['_links']['wp:featuredmedia'][0]['href'];
          post.image = getImageLink(post.imageLink, post);
        }
      }
    }
  } else {
    for (int i = 0; i < list.length; i++) {
      //generate post obj
      Post post = Post(data[i]);
      downloadedList.add(post);
      if (data[i]['_links']['wp:featuredmedia'] != null) {
        post.hasImage = true;
      } else {
        post.hasImage = false;
      }

      if (post.hasImage == true) {
        post.imageLink = data[i]['_links']['wp:featuredmedia'][0]['href'];
        post.image = getImageLink(post.imageLink, post);
      }
    }
  }

  //order post by latest
  for (int i = 0; i < downloadedList.length - 1; i++) {
    for (int j = i + 1; j < downloadedList.length; j++) {
      if (downloadedList[i].isMoreRecent(downloadedList[j]) == false) {
        Post post = downloadedList[i];
        downloadedList[i] = downloadedList[j];
        downloadedList[j] = post;
      }
    }
  }
}

Future<String> getImageLink(path, postSelected) async {
  final link = Uri.parse(path);
  final response =
      await http.get(link, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    //decode data
    var data = jsonDecode(response.body);

    //here to get image ratio
    int width = data["media_details"]["width"];
    int height = data["media_details"]["height"];
    postSelected.imgRatio = width / height;
    String imageLink = data["guid"]["rendered"];
    return imageLink;
  } else {
    return "-1";
  }
}
