import 'package:firebase_database/firebase_database.dart';

class AddProduct {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('products');

  // Lista produktów do dodania
  List<Map<String, dynamic>> productsList = [
    /*
    {
      "name": "Samsung Galaxy S23 Ultra",
      "category_id": 0,
      "price": 6499.00,
      "details": {
        "display": "6,8\"",
        "resolution": "3088 x 1440",
        "refreshing": "120 Hz",
        "ram": "12 GB",
        "storage": "512 GB",
        "camera": "200 Mpix + 12 Mpix + 10 Mpix + 10 Mpix",
        "cpu": "Qualcomm Snapdragon 8 Gen 2",
        "system": "Android 13",
        "battery": "5000 mAh",
        "sizes": "163,3 x 77,9 x 8,9 mm",
        "weight": "228 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/0_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/0_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/0_3.jpg"
      }
    },
    {
      "name": "Samsung Galaxy S23+",
      "category_id": 0,
      "price": 5499.00,
      "details": {
        "display": "6,6\"",
        "resolution": "2340 x 1080",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "512 GB",
        "camera": "50 Mpix + 12 Mpix + 10 Mpix",
        "cpu": "Qualcomm Snapdragon 8 Gen 2",
        "system": "Android 13",
        "battery": "4700 mAh",
        "sizes": "158 x 76 x 7,5 mm",
        "weight": "195 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/1_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/1_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/1_3.jpg"
      }
    },
    {
      "name": "Samsung Galaxy S23",
      "category_id": 0,
      "price": 4199.00,
      "details": {
        "display": "6,1\"",
        "resolution": "2400 x 1080",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "256 GB",
        "camera": "50 Mpix + 12 Mpix + 10 Mpix",
        "cpu": "Qualcomm Snapdragon 8 Gen 2",
        "system": "Android 13",
        "battery": "3900 mAh",
        "sizes": "146,3 x 70,9 x 7,6 mm",
        "weight": "167 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/2_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/2_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/2_3.jpg"
      }
    },
    {
      "name": "Apple iPhone 15 Pro Max",
      "category_id": 0,
      "price": 8399.00,
      "details": {
        "display": "6,7\"",
        "resolution": "2796 x 1290",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "512 GB",
        "camera": "48 Mpix + 12 Mpix + 12 Mpix",
        "cpu": "Apple A17 Pro",
        "system": "iOS 17",
        "battery": "4422 mAh",
        "sizes": "159,9 x 76,7 x 8,25 mm",
        "weight": "221 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/3_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/3_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/3_3.jpg"
      }
    },
    {
      "name": "Apple iPhone 15 Pro",
      "category_id": 0,
      "price": 7799.00,
      "details": {
        "display": "6,1\"",
        "resolution": "2556 x 1179",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "512 GB",
        "camera": "48 Mpix + 12 Mpix + 12 Mpix",
        "cpu": "Apple A17 Pro",
        "system": "iOS 17",
        "battery": "3274 mAh",
        "sizes": "146,6 x 70,6 x 8,25 mm",
        "weight": "187 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/4_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/4_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/4_3.jpg"
      }
    },
    {
      "name": "Apple iPhone 15",
      "category_id": 0,
      "price": 6499.00,
      "details": {
        "display": "6,1\"",
        "resolution": "2556 x 1179",
        "refreshing": "60 Hz",
        "ram": "6 GB",
        "storage": "512 GB",
        "camera": "48 Mpix + 12 Mpix",
        "cpu": "Apple A16",
        "system": "iOS 17",
        "battery": "3349 mAh",
        "sizes": "147,6 x 71,6 x 7,80 mm",
        "weight": "171 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/5_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/5_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/5_3.jpg"
      }
    },
    {
      "name": "Xiaomi 13",
      "category_id": 0,
      "price": 3799.00,
      "details": {
        "display": "6,36\"",
        "resolution": "2400 x 1080",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "256 GB",
        "camera": "50 Mpix + 12 Mpix + 10 Mpix",
        "cpu": "Qualcomm Snapdragon 8 Gen 2",
        "system": "Android 13",
        "battery": "4500 mAh",
        "sizes": "152,8 x 71,5 x 7,98 mm",
        "weight": "189 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/6_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/6_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/6_3.jpg"
      }
    },
    {
      "name": "Xiaomi 13T",
      "category_id": 0,
      "price": 2499.00,
      "details": {
        "display": "6,67\"",
        "resolution": "2712 x 1220",
        "refreshing": "144 Hz",
        "ram": "8 GB",
        "storage": "256 GB",
        "camera": "50 Mpix + 50 Mpix + 12 Mpix",
        "cpu": "MediaTek Dimensity 8200-Ultra",
        "system": "Android 13",
        "battery": "5000 mAh",
        "sizes": "162,2 x 75,7 x 8,62 mm",
        "weight": "193 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/7_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/7_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/7_3.jpg"
      }
    },
    {
      "name": "Xiaomi Redmi Note 12 Pro+ 5G",
      "category_id": 0,
      "price": 1699.00,
      "details": {
        "display": "6,67\"",
        "resolution": "2400 x 1080",
        "refreshing": "120 Hz",
        "ram": "8 GB",
        "storage": "256 GB",
        "camera": "200 Mpix + 8 Mpix + 2 Mpix",
        "cpu": "MediaTek Dimensity 1080",
        "system": "Android 12",
        "battery": "5000 mAh",
        "sizes": "162,9 x 76 x 8,98 mm",
        "weight": "210 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/8_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/8_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/8_3.jpg"
      }
    },
    {
      "name": "Motorola edge 40 Pro",
      "category_id": 0,
      "price": 3999.00,
      "details": {
        "display": "6,67\"",
        "resolution": "2400 x 1080",
        "refreshing": "165 Hz",
        "ram": "12 GB",
        "storage": "256 GB",
        "camera": "50 Mpix + 50 Mpix + 12 Mpix",
        "cpu": "Qualcomm Snapdragon 8 Gen 2",
        "system": "Android 13",
        "battery": "4600 mAh",
        "sizes": "161,1 x 74 x 8,59 mm",
        "weight": "199 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/9_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/9_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/9_3.jpg"
      }
    },
    {
      "name": "Motorola edge 30 ultra",
      "category_id": 0,
      "price": 2799.00,
      "details": {
        "display": "6,67\"",
        "resolution": "2400 x 1080",
        "refreshing": "144 Hz",
        "ram": "12 GB",
        "storage": "256 GB",
        "camera": "200 Mpix + 50 Mpix + 12 Mpix",
        "cpu": "Qualcomm Snapdragon 8+ Gen 1",
        "system": "Android 12",
        "battery": "4610 mAh",
        "sizes": "161,76 x 73,5 x 8,39 mm",
        "weight": "198 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/10_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/10_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/10_3.jpg"
      }
    },
    {
      "name": "Motorola edge 40 neo",
      "category_id": 0,
      "price": 2899.00,
      "details": {
        "display": "6,55\"",
        "resolution": "2400 x 1080",
        "refreshing": "144 Hz",
        "ram": "12 GB",
        "storage": "256 GB",
        "camera": "50 Mpix + 13 Mpix",
        "cpu": "MediaTek Dimensity 7030",
        "system": "Android 13",
        "battery": "5000 mAh",
        "sizes": "159,6 x 72,0 x 7,80 mm",
        "weight": "170 g"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/11_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/11_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/11_3.jpg"
      }
    },
    */
    /*
    {
      "id": 12,
      "name": "ASUS TUF Gaming F15",
      "category_id": 1,
      "price": 4099.00,
      "details": {
        "display": "15.6\"",
        "resolution": "1920 x 1080 (Full HD)",
        "refreshing": "144 Hz",
        "gpu": "NVIDIA GeForce RTX 3050",
        "ram": "16 GB",
        "storage": "960 GB",
        "cpu": "Intel Core i5-11400H",
        "system": "Microsoft Windows 11 Home"
      },
      "images": {
        "img_1": "gs://mobileapp-ejsiik.appspot.com/12_1.jpg",
        "img_2": "gs://mobileapp-ejsiik.appspot.com/12_2.jpg",
        "img_3": "gs://mobileapp-ejsiik.appspot.com/12_3.jpg"
      }
    },*/
    /*{
      "id": 2,
      "name": "G4M3R HERO PLUS",
      "category_id": 2,
      "price": 10900.00,
      "details": {
        "gpu": "NVIDIA GeForce RTX 4070 Ti",
        "ram": "32 GB (DDR5, 6000MHz)",
        "storage": "2000 GB",
        "cpu": "Intel Core i7-14700KF",
        "psu": "850 W",
        "system": "Microsoft Windows 11 Pro"
      },
      "images": {"img_1": "", "img_2": "", "img_3": ""}
    },
    {
      "id": 3,
      "name": "Sony Playstation 5",
      "category_id": 3,
      "price": 2699.00,
      "details": {
        "gpu": "AMD RDNA 2.0",
        "ram": "16 GB",
        "storage": "825 GB",
        "cpu": "AMD Ryzen Zen 2"
      },
      "images": {"img_1": "", "img_2": "", "img_3": ""}
    },
    {
      "id": 4,
      "name": "Gigabyte M27Q X HDR KVM",
      "category_id": 4,
      "price": 2049.00,
      "details": {
        "display": "27\"",
        "display_type": "IPS",
        "resolution": "2560 x 1440 (WQHD)",
        "refreshing": "240 Hz",
      },
      "images": {"img_1": "", "img_2": "", "img_3": ""}
    },
    {
      "id": 5,
      "name": "Samsung QE85Q80CA",
      "category_id": 5,
      "price": 10999.00,
      "details": {
        "display": "85\"",
        "display_type": "QLED",
        "resolution": "3840 x 2160 (UHD 4K)",
        "refreshing": "120 Hz",
        "ambilight": "Nie",
        "size": "1893 x 1144 x 327"
      },
      "images": {"img_1": "", "img_2": "", "img_3": ""}
    }
    */
  ];

  // Konstruktor klasy
  AddProduct() {
    addProductsToDatabase();
  }

  // Dodawanie listy produktów do tabeli 'products'
  void addProductsToDatabase() {
    for (int i = 0; i < productsList.length; i++) {
      // Użyj metody push() do automatycznego generowania klucza (ID)
      DatabaseReference newProductRef = ref.push();
      // Pobierz klucz i dodaj go jako pole "id" do mapy produktu
      String? productId = newProductRef.key;
      productsList[i]['id'] = productId;
      // Dodaj mapę produktu do bazy danych
      newProductRef.set(productsList[i]);

      //ref.push().set(productsList[i]);
    }
  }
}
