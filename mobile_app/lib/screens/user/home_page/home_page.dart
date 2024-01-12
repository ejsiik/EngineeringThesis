import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
//import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/service/authentication/auth.dart';
//import 'package:mobile_app/database/add_product_data.dart';
//import 'package:mobile_app/service/database/shop_location_data.dart';
import 'package:mobile_app/service/database/category_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/category_products_page/category_products_page.dart';
import 'package:mobile_app/screens/user/home_page/coupon_card.dart';
import 'package:mobile_app/screens/user/home_page/qr_code_popup.dart';
import 'package:shimmer/shimmer.dart';
import '../../../service/connection/connection_check.dart';
import '../category_products_page/product_search_model.dart';
import 'welcome_banner.dart';
//import '../category_products_page/product_search_model.dart';
import '../category_products_page/product_search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference? couponUsedRef;
  bool isListVisible = false;
  bool showWelcomeBanner = false;
  List<ProductSearchModel> displayList = [];
  UserDataProvider userDataProvider = UserDataProvider();
  Data userData = Data();
  CategoryData categoryData = CategoryData();
  //ShopLocationData shopLocationData = ShopLocationData();
  //AddProduct addProductData = AddProduct();
  //List<ProductSearchModel> displayList = [];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  final List<String> sliderImagesList = [
    "0_1.jpg",
    "12_1.jpg",
    "24_1.jpg",
    "36_1.jpg",
    "41_1.jpg",
    "53_1.jpg"
  ];

  Widget buildGridItem(int index, List categoriesList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(
              index,
              categoriesList[index],
            ),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              categoriesList[index],
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  /*Widget buildDay(String day, Map<dynamic, dynamic> dayData) {
    String openTime = dayData['open']!.toString();
    String closedTime = dayData['closed']!.toString();
    String hours = "";

    if (openTime.isEmpty || closedTime.isEmpty) {
      hours = "nieczynne";
    } else {
      hours = "$openTime - $closedTime";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            hours,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }*/

  @override
  void initState() {
    super.initState();
    // Set up a listener for changes in the database
    getCategories();
    userDataProvider.isUserCreatedWithin14Days().then((value) {
      setState(() {
        showWelcomeBanner = value;
      });
    });
    couponUsedRef = Data().getCouponUsedReference(Auth().userId());
    couponUsedRef!.onValue.listen((event) {
      if (event.snapshot.value is bool) {
        setState(() {
          showWelcomeBanner = event.snapshot.value == false;
        });
      }
    });
  }

  Future<String> getUserName() async {
    try {
      String? userName = await userData.getUserName();
      return userName ?? '';
    } catch (error) {
      _showSnackBar('Błąd podczas pobierania nazwy użytkownika');
      return 'Nieznany użytkownik';
    }
  }

  Future<List<Uint8List>> loadImages(List<String> imageUrls) async {
    List<Uint8List> loadedImages = [];

    if (!await checkInternetConnectivity()) {
      return loadedImages;
    }

    await Future.wait(
      imageUrls.map((imageUrl) async {
        final ref = FirebaseStorage.instance.ref().child(imageUrl);
        final data = await ref.getData();
        loadedImages.add(Uint8List.fromList(data!));
      }),
    );

    return loadedImages;
  }

  Future<List> getCategories() async {
    if (!await checkInternetConnectivity()) {
      return [];
    }

    return categoryData.getAllCategories();
  }

  void updateProductSearchList(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => ProductSearchResult(value)),
    );
  }

  void openPopupScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: const QRCodePopup(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // User name and coupons
                  FutureBuilder<String>(
                    future: getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Use shimmer effect while loading
                        return Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                              width: double.infinity,
                              height: 60.0,
                              color: backgroundColor),
                        );
                      } else {
                        String userName =
                            snapshot.data ?? 'Nieznany użytkownik';
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                color: backgroundColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Witaj $userName ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: textColor,
                                          ),
                                        ),
                                        Icon(
                                          Icons.waving_hand,
                                          size: 20,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.credit_score,
                                        color: primaryColor,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        openPopupScreen(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  // Show the WelcomeBanner only if conditions are met
                  if (showWelcomeBanner)
                    WelcomeBanner(
                      onButtonPressed: () {
                        openPopupScreen(context);
                      },
                    ),

                  // product searching bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: backgroundColor,
                          child: TextField(
                            onSubmitted: (value) =>
                                updateProductSearchList(value),
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Wyszukaj w sklepie",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const CouponCardWidget(),

                  // slider with special offers, popular products etc
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: loadImages(sliderImagesList),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Use shimmer effect while loading
                              return Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 350.0,
                                  color: backgroundColor,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              List<Uint8List> loadedImages =
                                  snapshot.data as List<Uint8List>;

                              return CarouselSlider(
                                items: loadedImages.map((image) {
                                  return Image.memory(
                                    image,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  height: 350.0,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // categories of products
                  FutureBuilder<List>(
                    future: getCategories(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Use shimmer effect while loading
                        return Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: 6, // Adjust the itemCount as needed
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Container(
                                        width: 50.0,
                                        height: 20.0,
                                        color: backgroundColor),
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Handle the error case.
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Categories have been fetched successfully, use them in the GridView.builder.
                        List? categoriesList = snapshot.data;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: categoriesList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildGridItem(index, categoriesList!);
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
