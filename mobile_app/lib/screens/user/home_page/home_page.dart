import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/database/data.dart';
import 'package:mobile_app/screens/user/home_page/coupon_card.dart';
import 'package:mobile_app/screens/user/home_page/qr_code_popup.dart';
import '../../../authentication/auth.dart';
import 'welcome_banner.dart';
import 'product_search_model.dart';
import 'product_search_result.dart';
import 'shop_location_model.dart';
import 'image_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool isListVisible = false;
  bool showWelcomeBanner = false;
  Data data = Data();
  UserDataProvider userData = UserDataProvider();
  final CarouselController _carouselController = CarouselController();
  List<ProductSearchModel> displayList = [];

  final List<ProductSearchModel> productsList = [
    ProductSearchModel(
      "GigaTelefon1",
      "assets/s23.jpg",
      "1999 PLN",
    ),
    ProductSearchModel(
      "GigaMegaTelefon2",
      "assets/s23.jpg",
      "2999 PLN",
    ),
    ProductSearchModel(
      "OKTelefon3",
      "assets/s23.jpg",
      "3999 PLN",
    ),
    ProductSearchModel(
      "SpokoTelefon4",
      "assets/s23.jpg",
      "4999 PLN",
    ),
    ProductSearchModel(
      "SpokoOkTelefon5",
      "assets/s23.jpg",
      "5999 PLN",
    ),
  ];

  final List<ShopLocationModel> locationsList = [
    ShopLocationModel(
      location: "Kasztanowa 1/2, 44-100 Gliwice",
      monday: "08:00 - 20:00",
      tuesday: "08:00 - 20:00",
      wednesday: "08:00 - 20:00",
      thursday: "08:00 - 20:00",
      friday: "08:00 - 20:00",
      saturday: "08:00 - 16:00",
      sunday: "nieczynne",
      isExpanded: false,
    ),
    ShopLocationModel(
      location: "Ogórkowa 1/3, 44-100 Gliwice",
      monday: "08:00 - 20:00",
      tuesday: "08:00 - 20:00",
      wednesday: "08:00 - 20:00",
      thursday: "08:00 - 20:00",
      friday: "08:00 - 20:00",
      saturday: "08:00 - 16:00",
      sunday: "nieczynne",
      isExpanded: false,
    ),
    ShopLocationModel(
      location: "Kasztelanowa 1/4, 44-100 Gliwice",
      monday: "08:00 - 20:00",
      tuesday: "08:00 - 20:00",
      wednesday: "08:00 - 20:00",
      thursday: "08:00 - 20:00",
      friday: "08:00 - 20:00",
      saturday: "08:00 - 16:00",
      sunday: "nieczynne",
      isExpanded: false,
    ),
  ];

  final List<ImageModel> imagesList = [
    ImageModel("assets/s23.jpg"),
    ImageModel("assets/s23.jpg"),
    ImageModel("assets/s23.jpg"),
    ImageModel("assets/s23.jpg"),
    ImageModel("assets/s23.jpg"),
  ];

  Widget buildGridItem(int index, List categoriesList) {
    return Card(
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
    );
  }

  Widget buildDay(String day, String hours) {
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
  }

  @override
  void initState() {
    super.initState();
    // Set up a listener for changes in the database
    getCategories();
    userData.isUserCreatedWithin14Days().then((value) {
      setState(() {
        showWelcomeBanner = value;
      });
    });
  }

  void signOut() async {
    await Auth().signOut();
  }

  Future<String> getUserName() async {
    String? userName = await data.getUserName();

    if (userName != null) {
      return userName;
    } else {
      return 'Unknown User';
    }
  }

  Future<List> getCategories() async {
    List list = await data.getAllCategories();
    //categoriesList = list;
    return list;
  }

  void updateProductSearchList(String value) {
    setState(() {
      displayList = productsList
          .where((element) => element.name
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => ProductSearchResult(displayList)),
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
    const Color logoutColor = AppColors.logout;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // User name and logout
                  FutureBuilder<String>(
                    future: getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String userName = snapshot.data ?? 'Unknown User';
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
                                      icon: const Icon(
                                        Icons.credit_score,
                                        color: logoutColor,
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
                              hintText: "Wyszukaj w sklepie, np \"tel\"",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Show the WelcomeBanner only if conditions are met
                  if (showWelcomeBanner)
                    WelcomeBanner(
                      onButtonPressed: () {
                        openPopupScreen(context);
                      },
                    ),

                  const CouponCardWidget(),

                  // shop locations header
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                          color: backgroundColor,
                          child: Text(
                            'Jesteśmy dostępni lokalnie:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Store location
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionPanelList(
                          elevation: 1,
                          expandedHeaderPadding: const EdgeInsets.all(0),
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              for (var i = 0; i < locationsList.length; i++) {
                                if (i != index) {
                                  locationsList[i].isExpanded = false;
                                } else {
                                  locationsList[i].isExpanded =
                                      !locationsList[i].isExpanded;
                                }
                              }
                            });
                          },
                          children: locationsList.map<ExpansionPanel>(
                            (ShopLocationModel item) {
                              return ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(item.location),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildDay('Poniedziałek:', item.monday),
                                      buildDay('Wtorek:', item.tuesday),
                                      buildDay('Środa:', item.wednesday),
                                      buildDay('Czwartek:', item.thursday),
                                      buildDay('Piątek:', item.friday),
                                      buildDay('Sobota:', item.saturday),
                                      buildDay('Niedziela:', item.sunday),
                                    ],
                                  ),
                                ),
                                isExpanded: item.isExpanded,
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),

                  // slider with special offers, popular products etc
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: imagesList.length,
                          options: CarouselOptions(
                            height: 150,
                            enlargeCenterPage: true,
                            viewportFraction: 0.6,
                          ),
                          carouselController: _carouselController,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                imagesList[index].imageAsset,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  FutureBuilder<List>(
                    future: getCategories(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Return a loading indicator while data is being fetched.
                        return const CircularProgressIndicator();
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
