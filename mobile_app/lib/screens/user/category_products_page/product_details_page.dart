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

  ListTile buildListTile(String label, String content, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            content,
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
                  const SizedBox(height: 16.0),
                  Text('Cena: ${widget.price} zł',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Szczegóły:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  if (widget.categoryId == 0) ...[
                    buildListTile(
                        'Wyświetlacz', widget.details['display'], Icons.tv),
                    buildListTile('Rozdzielczość', widget.details['resolution'],
                        Icons.aspect_ratio),
                    buildListTile('Odświeżanie ekranu',
                        widget.details['refreshing'], Icons.refresh),
                    buildListTile(
                        'Aparat', widget.details['camera'], Icons.camera),
                    buildListTile(
                        'Procesor', widget.details['cpu'], Icons.memory),
                    buildListTile(
                        'Pamieć RAM', widget.details['ram'], Icons.memory),
                    buildListTile(
                        'Pojemność', widget.details['storage'], Icons.storage),
                    buildListTile('System operacyjny', widget.details['system'],
                        Icons.settings),
                    buildListTile('Pojemność baterii',
                        widget.details['battery'], Icons.battery_full),
                    buildListTile('Wymiary', widget.details['sizes'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'Waga', widget.details['weight'], Icons.fitness_center),
                  ] else if (widget.categoryId == 1) ...[
                    buildListTile(
                        'Wyświetlacz', widget.details['display'], Icons.tv),
                    buildListTile('Rodzaj ekranu',
                        widget.details['display_type'], Icons.tv),
                    buildListTile('Rozdzielczość', widget.details['resolution'],
                        Icons.aspect_ratio),
                    buildListTile('Odświeżanie ekranu',
                        widget.details['refreshing'], Icons.refresh),
                    buildListTile(
                        'Procesor', widget.details['cpu'], Icons.memory),
                    buildListTile(
                        'Karta graficzna', widget.details['gpu'], Icons.memory),
                    buildListTile(
                        'Pamieć RAM', widget.details['ram'], Icons.memory),
                    buildListTile('Rodzaj pamięci RAM',
                        widget.details['ram_type'], Icons.memory),
                    buildListTile('Pojemność i rodzaj dysku',
                        widget.details['storage'], Icons.storage),
                    buildListTile('System operacyjny', widget.details['system'],
                        Icons.settings),
                    buildListTile('Pojemność baterii',
                        widget.details['battery'], Icons.battery_full),
                    buildListTile('Wymiary', widget.details['sizes'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'Waga', widget.details['weight'], Icons.fitness_center),
                  ] else if (widget.categoryId == 2) ...[
                    buildListTile('Współpracujący system operacyjny',
                        widget.details['system'], Icons.settings),
                    buildListTile('Wymiary', widget.details['sizes'],
                        Icons.photo_size_select_large),
                    buildListTile('Pulsometr', widget.details['heart_monitor'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'Akcelerometr',
                        widget.details['accelerometer'],
                        Icons.photo_size_select_large),
                    buildListTile('Żyroskop', widget.details['gyroscope'],
                        Icons.photo_size_select_large),
                    buildListTile('Stoper', widget.details['stoper'],
                        Icons.photo_size_select_large),
                    buildListTile('Alarm', widget.details['alarm'],
                        Icons.photo_size_select_large),
                    buildListTile('Odbiornik GPS', widget.details['gps'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'Informacje pogodowe',
                        widget.details['weather_info'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'Funkcja odbierania połączeń',
                        widget.details['receiving_calls'],
                        Icons.photo_size_select_large),
                    buildListTile(
                        'System płatności',
                        widget.details['payment_system'],
                        Icons.photo_size_select_large),
                  ] else if (widget.categoryId == 3) ...[
                    buildListTile(
                        'Procesor', widget.details['cpu'], Icons.settings),
                    buildListTile('Karta graficzna', widget.details['gpu'],
                        Icons.settings),
                    buildListTile(
                        'Pamięć RAM', widget.details['ram'], Icons.settings),
                    buildListTile('Pojemność dysku', widget.details['disc'],
                        Icons.settings),
                    buildListTile('Dysk optyczny',
                        widget.details['optical_drive'], Icons.settings),
                    buildListTile(
                        'Wymiary', widget.details['size'], Icons.settings),
                    buildListTile(
                        'Waga', widget.details['weight'], Icons.settings),
                    buildListTile(
                        'Zasilanies', widget.details['power'], Icons.settings),
                  ] else if (widget.categoryId == 4) ...[
                    buildListTile('Rozmiar ekranu', widget.details['display'],
                        Icons.settings),
                    buildListTile('Format ekranu', widget.details['format'],
                        Icons.settings),
                    buildListTile('Rozdzielczość', widget.details['resolution'],
                        Icons.settings),
                    buildListTile('Częstotliwość odświeżanie ekranu',
                        widget.details['refresh_rate'], Icons.settings),
                    buildListTile(
                        'Typ matrycy', widget.details['type'], Icons.settings),
                    buildListTile('Czas reakcji matrycy',
                        widget.details['reaction_time'], Icons.settings),
                    buildListTile('Liczba wyświetlanych kolorów',
                        widget.details['number_of_colors'], Icons.settings),
                    buildListTile('HDR', widget.details['hdr'], Icons.settings),
                    buildListTile(
                        'Wymiary', widget.details['size'], Icons.settings),
                    buildListTile(
                        'Weight', widget.details['weight'], Icons.settings),
                  ] else if (widget.categoryId == 5) ...[
                    buildListTile('Rozmiar ekranu', widget.details['display'],
                        Icons.settings),
                    buildListTile('Rozdzielczość', widget.details['resolution'],
                        Icons.settings),
                    buildListTile('Częstotliwość odświeżanie ekranu',
                        widget.details['refresh_rate'], Icons.settings),
                    buildListTile(
                        'Typ matrycy', widget.details['type'], Icons.settings),
                    buildListTile('HDR', widget.details['hdr'], Icons.settings),
                    buildListTile(
                        'Smart TV', widget.details['smart_tv'], Icons.settings),
                    buildListTile(
                        'System', widget.details['system'], Icons.settings),
                    buildListTile(
                        'Wi-fi', widget.details['wifi'], Icons.settings),
                    buildListTile('Montaż na ścianie',
                        widget.details['wall_montage'], Icons.settings),
                    buildListTile('Wymiary z podstawą',
                        widget.details['size_with_base'], Icons.settings),
                    buildListTile('Wymiary bez podstawy',
                        widget.details['size_without_base'], Icons.settings),
                    buildListTile('Waga z podstawą',
                        widget.details['weight_with_base'], Icons.settings),
                    buildListTile('Waga bez podstawy',
                        widget.details['weight_without_base'], Icons.settings),
                  ],
                ],
              ),
            ),
          ),
          if (widget.routeName != '/shoppingCartPage' &&
              widget.routeName != '/ordersPage')
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange,
              child: GestureDetector(
                onTap: () {
                  addToShoppingCart(widget.productId);
                },
                child: const ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Dodaj do koszyka'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
