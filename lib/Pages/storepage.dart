import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maestraelena_app/Pages/product.dart';
import 'package:maestraelena_app/Pages/product_widget.dart';

import '../State/app_state.dart';
import '../Theme/app_style.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() {
    return _StorePageState();
  }
}

class _StorePageState extends State<StorePage> {
  String dropdownValue = "Tutti i prodotti";

  @override
  Widget build(BuildContext context) {
    final List<Product> productList = List.empty(growable: true);
    final List<int> categories = List.empty(growable: true);
    final List<String> categoriesName = List.empty(growable: true);

    //read the products
    if (firebaseInitialized) {
      //categories initialization
      categories.clear();
      categoriesName.clear();
      for (int i = 0; i < products["categories"].length; i++) {
        categories.add(products["categories"][i]["index"]);
        categoriesName.add(products["categories"][i]["name"]);
      }
      //product initialization
      for (int i = 0; i < products["products"].length; i++) {
        productList.add(Product(
            categoriesName[products["products"][i]["category"]],
            products["products"][i]["name"],
            products["products"][i]["link"],
            products["products"][i]["prize"],
            products["products"][i]["imageUrl"],
            products["products"][i]["description"]));
      }
    } else {
      categories.add(0);
      categoriesName.add("Tutti i prodotti");
    }
    return Scaffold(
      backgroundColor: homePageBackgroundColor,
      body: Stack(
        children: [
          //LOGO
          Container(
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
            margin: EdgeInsets.only(
                top: (deviceHeight / 10) + homePageTopCloudsOffset),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),

          //FILTER
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
                top: (deviceHeight / 10) + 0.8 * homePageTopCloudsOffset),
            child: DropdownButton<String>(
              isExpanded: false,
              isDense: true,
              value: dropdownValue,
              enableFeedback: false,
              //icon: const Icon(Icons.arrow_downward),
              iconEnabledColor: defaultOperationColor,
              elevation: 16,
              underline: Container(
                height: 2,
                color: defaultOperationColor,
              ),
              style: GoogleFonts.comicNeue(
                color: maxDarkestAppColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: categoriesName[value],
                  child: Text(categoriesName[value]),
                );
              }).toList(),
            ),
          ),

          //list View
          Container(
            margin: EdgeInsets.only(
                top: (deviceHeight / 10) + 1.5 * homePageTopCloudsOffset),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0, bottom: 30),
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                if (dropdownValue == categoriesName.first) {
                  //showAll
                  return ProductWidget(productList[index]);
                } else {
                  if (dropdownValue == productList[index].category) {
                    //show only correct category
                    return ProductWidget(productList[index]);
                  }
                }
                return Container();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
