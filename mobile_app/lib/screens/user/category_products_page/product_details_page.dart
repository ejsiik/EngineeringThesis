import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_app/service/database/data.dart';

class ProductDetailsPage extends StatefulWidget {
  final int categoryId;
  final String productId;
  final String name;
  final int price;
  final Map<String, dynamic> details;
  final Map<String, dynamic> images;
  final String routeName;

  const ProductDetailsPage(this.categoryId, this.productId, this.name,
      this.price, this.details, this.images, this.routeName,
      {super.key});

  @override
  State<ProductDetailsPage> createState() {
    return _ProductDetailsPageState();
  }
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Data userData = Data();

  Future<List<Uint8List>> loadImages(Map<String, dynamic> images) async {
    List<Uint8List> loadedImages = [];

    for (String imageUrl in images.values) {
      final ref = FirebaseStorage.instance.ref().child(imageUrl);
      final data = await ref.getData();
      loadedImages.add(Uint8List.fromList(data!));
    }
    return loadedImages;
  }

  Container buildListTile(String label, String content, bool color) {
    return Container(
      color: color ? Colors.grey.withOpacity(0.3) : null,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addToShoppingCart(String productId) async {
      await userData.addToShoppingCart(productId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: loadImages(widget.images),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
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
                  Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                    child: Text('Cena: ${widget.price} zł',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                    child: const Text(
                      'Szczegóły produktu:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.categoryId == 0) ...[
                    buildListTile(
                        'Wyświetlacz', widget.details['display'], true),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], false),
                    buildListTile('Odświeżanie ekranu',
                        widget.details['refreshing'], true),
                    buildListTile('Aparat', widget.details['camera'], false),
                    buildListTile('Procesor', widget.details['cpu'], true),
                    buildListTile('Pamieć RAM', widget.details['ram'], false),
                    buildListTile('Pojemność', widget.details['storage'], true),
                    buildListTile(
                        'System operacyjny', widget.details['system'], false),
                    buildListTile(
                        'Pojemność baterii', widget.details['battery'], true),
                    buildListTile('Wymiary', widget.details['sizes'], false),
                    buildListTile('Waga', widget.details['weight'], true),
                  ] else if (widget.categoryId == 1) ...[
                    buildListTile(
                        'Wyświetlacz', widget.details['display'], true),
                    buildListTile(
                        'Rodzaj ekranu', widget.details['display_type'], false),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], true),
                    buildListTile('Odświeżanie ekranu',
                        widget.details['refreshing'], false),
                    buildListTile('Procesor', widget.details['cpu'], true),
                    buildListTile(
                        'Karta graficzna', widget.details['gpu'], false),
                    buildListTile('Pamieć RAM', widget.details['ram'], true),
                    buildListTile('Rodzaj pamięci RAM',
                        widget.details['ram_type'], false),
                    buildListTile('Pojemność i rodzaj dysku',
                        widget.details['storage'], true),
                    buildListTile(
                        'System operacyjny', widget.details['system'], false),
                    buildListTile(
                        'Pojemność baterii', widget.details['battery'], true),
                    buildListTile('Wymiary', widget.details['sizes'], false),
                    buildListTile('Waga', widget.details['weight'], true),
                  ] else if (widget.categoryId == 2) ...[
                    buildListTile('Współpracujący system operacyjny',
                        widget.details['system'], true),
                    buildListTile('Wymiary', widget.details['sizes'], false),
                    buildListTile(
                        'Pulsometr', widget.details['heart_monitor'], true),
                    buildListTile(
                        'Akcelerometr', widget.details['accelerometer'], false),
                    buildListTile(
                        'Żyroskop', widget.details['gyroscope'], true),
                    buildListTile('Stoper', widget.details['stoper'], false),
                    buildListTile('Alarm', widget.details['alarm'], true),
                    buildListTile(
                        'Odbiornik GPS', widget.details['gps'], false),
                    buildListTile('Informacje pogodowe',
                        widget.details['weather_info'], true),
                    buildListTile('Funkcja odbierania połączeń',
                        widget.details['receiving_calls'], false),
                    buildListTile('System płatności',
                        widget.details['payment_system'], true),
                  ] else if (widget.categoryId == 3) ...[
                    buildListTile('Procesor', widget.details['cpu'], true),
                    buildListTile(
                        'Karta graficzna', widget.details['gpu'], false),
                    buildListTile('Pamięć RAM', widget.details['ram'], true),
                    buildListTile(
                        'Pojemność dysku', widget.details['disc'], false),
                    buildListTile(
                        'Dysk optyczny', widget.details['optical_drive'], true),
                    buildListTile('Wymiary', widget.details['size'], false),
                    buildListTile('Waga', widget.details['weight'], true),
                    buildListTile('Zasilanies', widget.details['power'], false),
                  ] else if (widget.categoryId == 4) ...[
                    buildListTile(
                        'Rozmiar ekranu', widget.details['display'], true),
                    buildListTile(
                        'Format ekranu', widget.details['format'], false),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], true),
                    buildListTile('Częstotliwość odświeżanie ekranu',
                        widget.details['refresh_rate'], false),
                    buildListTile('Typ matrycy', widget.details['type'], true),
                    buildListTile('Czas reakcji matrycy',
                        widget.details['reaction_time'], false),
                    buildListTile('Liczba wyświetlanych kolorów',
                        widget.details['number_of_colors'], true),
                    buildListTile('HDR', widget.details['hdr'], false),
                    buildListTile('Wymiary', widget.details['size'], true),
                    buildListTile('Weight', widget.details['weight'], false),
                  ] else if (widget.categoryId == 5) ...[
                    buildListTile(
                        'Rozmiar ekranu', widget.details['display'], true),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], false),
                    buildListTile('Częstotliwość odświeżanie ekranu',
                        widget.details['refresh_rate'], true),
                    buildListTile('Typ matrycy', widget.details['type'], false),
                    buildListTile('HDR', widget.details['hdr'], true),
                    buildListTile(
                        'Smart TV', widget.details['smart_tv'], false),
                    buildListTile('System', widget.details['system'], true),
                    buildListTile('Wi-fi', widget.details['wifi'], false),
                    buildListTile('Montaż na ścianie',
                        widget.details['wall_montage'], true),
                    buildListTile('Wymiary z podstawą',
                        widget.details['size_with_base'], false),
                    buildListTile('Wymiary bez podstawy',
                        widget.details['size_without_base'], true),
                    buildListTile('Waga z podstawą',
                        widget.details['weight_with_base'], false),
                    buildListTile('Waga bez podstawy',
                        widget.details['weight_without_base'], true),
                  ],
                ],
              ),
            ),
          ),
          if (widget.routeName != '/shoppingCartPage' &&
              widget.routeName != '/ordersPage')
            Container(
              padding: EdgeInsets.all(12.0), // Dodaj Padding dookoła
              color: Colors.orange,
              child: GestureDetector(
                onTap: () {
                  addToShoppingCart(widget.productId);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Dodaj do koszyka',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
