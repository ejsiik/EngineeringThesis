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
                        'Display', widget.details['display'], Icons.tv),
                    buildListTile('Resolution', widget.details['resolution'],
                        Icons.aspect_ratio),
                    buildListTile('Refreshing Rate',
                        widget.details['refreshing'], Icons.refresh),
                    buildListTile(
                        'Camera', widget.details['camera'], Icons.camera),
                    buildListTile('CPU', widget.details['cpu'], Icons.memory),
                    buildListTile('RAM', widget.details['ram'], Icons.memory),
                    buildListTile(
                        'Storage', widget.details['storage'], Icons.storage),
                    buildListTile(
                        'System', widget.details['system'], Icons.settings),
                    buildListTile('Battery', widget.details['battery'],
                        Icons.battery_full),
                    buildListTile('Sizes', widget.details['sizes'],
                        Icons.photo_size_select_large),
                    buildListTile('Weight', widget.details['weight'],
                        Icons.fitness_center),
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
