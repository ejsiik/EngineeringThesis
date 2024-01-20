import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';

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

  Future<void> addOrRemoveFromWishlist(String productId) async {
    if (!await checkInternetConnectivity()) {
      showSnackBarSimpleMessage(connection);
    } else {
      bool data = await userData.addOrRemoveFromWishlist(productId);
      showSnackBarWishList(data);
    }
  }

  Future<bool> isProductInShoppingCart(id) async {
    bool data = await userData.isProductInShoppingCart(id);
    return data;
  }

  Future<void> removeFromShoppingCart(String productId) async {
    if (!await checkInternetConnectivity()) {
      showSnackBarSimpleMessage(connection);
    } else {
      await userData.removeFromShoppingCart(productId);
    }
  }

  Future<List<Uint8List>> loadImages(Map<String, dynamic> images) async {
    if (!await checkInternetConnectivity()) {
      return [];
    }

    List<Uint8List> loadedImages = [];

    for (String imageUrl in images.values) {
      final ref = FirebaseStorage.instance.ref().child(imageUrl);
      final data = await ref.getData();
      loadedImages.add(Uint8List.fromList(data!));
    }
    return loadedImages;
  }

  Future<void> addToShoppingCart(String productId) async {
    if (!await checkInternetConnectivity()) {
      showSnackBarSimpleMessage(connection);
    } else {
      await userData.addToShoppingCart(productId);
      setState(() {});
    }
  }

  void _showDescriptionDialog(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String description = LabelDescriptionData.data[label] ?? 'Brak opisu';
        return AlertDialog(
          title: Text(label),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }

  void showSnackBarWishList(bool addOrRemove) {
    Utils.showSnackBarWishList(context, addOrRemove);
  }

  void showSnackBarSimpleMessage(String message) {
    Utils.showSnackBarSimpleMessage(context, message);
  }

  Container buildListTile(String label, String content, bool color) {
    return Container(
      color: color ? Colors.grey.withOpacity(0.3) : null,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                _showDescriptionDialog(context, label);
              },
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
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

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
                        return Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: double.infinity,
                            height: 350.0,
                            color: Colors.white,
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
                  Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                    child: Row(
                      children: [
                        Text(
                          'Cena: ${widget.price} zł',
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            addOrRemoveFromWishlist(widget.productId);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.grey,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                    child: const Text(
                      'Szczegóły produktu:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.categoryId == 0) ...[
                    buildListTile('Przekątna wyświetlacza',
                        widget.details['display'], true),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], false),
                    buildListTile('Częstotliwość odświeżania ekranu',
                        widget.details['refreshing'], true),
                    buildListTile('Aparat', widget.details['camera'], false),
                    buildListTile('Procesor', widget.details['cpu'], true),
                    buildListTile('Pamięć RAM', widget.details['ram'], false),
                    buildListTile(
                        'Pojemność dysku', widget.details['storage'], true),
                    buildListTile(
                        'System operacyjny', widget.details['system'], false),
                    buildListTile(
                        'Pojemność baterii', widget.details['battery'], true),
                    buildListTile('Wymiary', widget.details['sizes'], false),
                    buildListTile('Waga', widget.details['weight'], true),
                  ] else if (widget.categoryId == 1) ...[
                    buildListTile('Przekątna wyświetlacza',
                        widget.details['display'], true),
                    buildListTile(
                        'Typ matrycy', widget.details['display_type'], false),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], true),
                    buildListTile('Częstotliwość odświeżania ekranu',
                        widget.details['refreshing'], false),
                    buildListTile('Procesor', widget.details['cpu'], true),
                    buildListTile(
                        'Karta graficzna', widget.details['gpu'], false),
                    buildListTile('Pamięć RAM', widget.details['ram'], true),
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
                    buildListTile('Rozmiar', widget.details['sizes'], false),
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
                    buildListTile('Pobór mocy', widget.details['power'], false),
                  ] else if (widget.categoryId == 4) ...[
                    buildListTile('Przekątna wyświetlacza',
                        widget.details['display'], true),
                    buildListTile(
                        'Format ekranu', widget.details['format'], false),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], true),
                    buildListTile('Częstotliwość odświeżania ekranu',
                        widget.details['refresh_rate'], false),
                    buildListTile('Typ matrycy', widget.details['type'], true),
                    buildListTile('Czas reakcji matrycy',
                        widget.details['reaction_time'], false),
                    buildListTile('Liczba wyświetlanych kolorów',
                        widget.details['number_of_colors'], true),
                    buildListTile('HDR', widget.details['hdr'], false),
                    buildListTile('Wymiary', widget.details['size'], true),
                    buildListTile('Waga', widget.details['weight'], false),
                  ] else if (widget.categoryId == 5) ...[
                    buildListTile(
                        'Rozmiar ekranu', widget.details['display'], true),
                    buildListTile(
                        'Rozdzielczość', widget.details['resolution'], false),
                    buildListTile('Częstotliwość odświeżania ekranu',
                        widget.details['refresh_rate'], true),
                    buildListTile('Typ matrycy', widget.details['type'], false),
                    buildListTile('HDR', widget.details['hdr'], true),
                    buildListTile(
                        'Smart TV', widget.details['smart_tv'], false),
                    buildListTile('System', widget.details['system'], true),
                    buildListTile('Wi-Fi', widget.details['wifi'], false),
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
          if (widget.routeName == '/categoryProductsPage' ||
              widget.routeName == '/productSearchResultPage' ||
              widget.routeName == '/bannerLink')
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.orange,
              child: GestureDetector(
                onTap: () async {
                  if (!await checkInternetConnectivity()) {
                    showSnackBarSimpleMessage(connection);
                  } else {
                    if (await userData
                        .isProductInShoppingCart(widget.productId)) {
                      await removeFromShoppingCart(widget.productId);
                    } else {
                      await addToShoppingCart(widget.productId);
                    }
                    setState(() {});
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    FutureBuilder<bool>(
                      future:
                          userData.isProductInShoppingCart(widget.productId),
                      builder: (context, snapshot) {
                        bool isProductInCart = snapshot.data ?? false;
                        return Text(
                          isProductInCart
                              ? 'Usuń z koszyka'
                              : 'Dodaj do koszyka',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        );
                      },
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

class LabelDescriptionData {
  static Map<String, String> data = {
    'Przekątna wyświetlacza':
        'Odległość między dwoma przeciwnymi narożnikami ekranu urządzenia, mierzona w calach lub centymetrach. Jest to kluczowa cecha, definiująca rozmiar ekranu i wpływająca na doznania wizualne podczas korzystania z urządzenia. Im większa przekątna, tym zazwyczaj większa powierzchnia wyświetlacza, co może wpływać na komfort użytkowania, zwłaszcza w przypadku multimediów i gier.',
    'Rozdzielczość':
        'Liczba pikseli, które mogą być wyświetlone na ekranie.  Im wyższa rozdzielczość, tym obraz jest bardziej szczegółowy i ostro wyświetlany, co ma znaczący wpływ na jakość wizualną.',
    'Częstotliwość odświeżania ekranu':
        'Liczba razy, w jakich obraz na ekranie jest odświeżany w ciągu jednej sekundy, wyrażana w hercach (Hz). Wyższa wartość częstotliwości odświeżania przekłada się na płynniejszy ruch obrazu oraz lepszą responsywność ekranu, co jest szczególnie istotne podczas korzystania z gier komputerowych, filmów z wysoką klatkowością lub dynamicznych aplikacji. ',
    'Aparat':
        'Jego jakość zazwyczaj jest określana przez liczbę megapikseli, oprogramowanie oraz dodatkowe funkcje, takie jak tryby fotograficzne czy stabilizacja obrazu. Współczesne smartfony często wyposażone są w zaawansowane aparaty, umożliwiające tworzenie wysokiej jakości zdjęć i filmów, co stanowi istotny element doświadczenia użytkownika.',
    'Procesor':
        'Zwany również jednostką centralną (CPU), to kluczowy komponent komputera odpowiedzialny za wykonywanie operacji obliczeniowych. Jego szybkość wpływa na ogólną wydajność systemu. Procesory różnią się architekturą, liczbą rdzeni oraz technologią wykonania, co ma wpływ na ich zdolność obsługi zadań wielozadaniowych i specyficznych zastosowań.',
    'Pamięć RAM':
        'Rodzaj pamięci, która umożliwia tymczasowe przechowywanie danych, z których aktywnie korzysta aktualnie działający system operacyjny i programy. Jej szybki dostęp i odczyt pozwala na natychmiastowe wykonywanie operacji, co przyczynia się do ogólnej wydajności komputera.',
    'Pojemność dysku':
        'Ilość dostępnej przestrzeni do przechowywania danych na danym nośniku, najczęściej mierzona w gigabajtach (GB) lub terabajtach (TB). Im większa pojemność dysku, tym więcej informacji, plików, programów czy multimediów można na nim przechowywać.',
    'System operacyjny':
        'Oprogramowanie, które zarządza zasobami urządzenia oraz umożliwia z nim interakcję. Pełni kluczową rolę w kontrolowaniu procesów, zarządzaniu pamięcią, obsłudze urządzeń wejścia/wyjścia i zapewnianiu interfejsu użytkownika.',
    'Pojemność baterii':
        'Ilość energii elektrycznej, którą bateria może przechowywać i dostarczać do urządzenia elektronicznego. Jest zazwyczaj mierzona w amperogodzinach (mAh) lub watogodzinach (Wh). Im wyższa pojemność baterii, tym dłużej urządzenie może pracować na jednym naładowaniu, przy założeniu, że inne czynniki, takie jak efektywność energetyczna urządzenia, pozostają stałe. Pojemność baterii jest kluczowym parametrem w przypadku przenośnych urządzeń elektronicznych, takich jak smartfony, tablety czy laptopy.',
    'Wymiary':
        'Parametry, które określają rozmiary danego urządzenia, najczęściej wyrażane są w milimetrach (mm).',
    'Waga':
        'Parametr określający masę danego urządzenia, najczęściej wyrażana w gramach (g) lub kilogramach (kg).',
    'Typ matrycy':
        'Jedna z kluczowych cech wyświetlacza, która wpływa na jakość obrazu, kąty widzenia, kontrast oraz inne parametry. Istnieje kilka popularnych rodzajów matryc, a trzy z najczęściej spotykanych to IPS, VA i TN.',
    'Karta graficzna':
        'Komponent komputera odpowiedzialny za przetwarzanie grafiki i generowanie obrazu, który jest wyświetlany na monitorze. Karty graficzne są kluczowymi elementami w systemach, zwłaszcza w kontekście gier komputerowych, grafiki 3D, edycji wideo i innych zadań związanych z intensywnym przetwarzaniem grafiki.',
    'Rodzaj pamięci RAM':
        'Istnieje kilka różnych rodzajów pamięci RAM, z których aktualnie wykorzystywanym standardem są DDR4 i DDR5. Wybór konkretnego rodzaju pamięci RAM zależy od kompatybilności z płytą główną i procesorem, a każda nowa generacja wprowadza zazwyczaj poprawki wydajnościowe.',
    'Pojemność i rodzaj dysku':
        'Ilość dostępnej przestrzeni do przechowywania danych na danym nośniku. Wybór rodzaju dysku zależy od potrzeb i zastosowania danego użytkownika. Dyski SSD są często preferowane w przypadku systemów operacyjnych i aplikacji wymagających szybkiego dostępu do danych, podczas gdy dyski HDD mogą być atrakcyjne ze względu na większą pojemność i niższą cenę w przypadku przechowywania dużych ilości plików multimedialnych czy kopii zapasowych.',
    'Współpracujący system operacyjny':
        'Kompatybilna platforma wskazuje na możliwości komunikacji z urządzeniami z określonym systemem operacyjnym. Do najpopularniejszych systemów należą Android oraz iOS.',
    'Rozmiar': 'Średnica koperty zegarka wyrażona w milimetrach (mm).',
    'Pulsometr':
        'Zegarek oświetla naczynia krwionośne nadgarstka zielonymi diodami LED migającymi setki razy na sekundę i za pomocą fotodiody mierzy światło rozproszone przepływem krwi.',
    'Akcelerometr':
        'Czujnik, który mierzy przyspieszenie kierunkowe urządzenia. Działa na zasadzie wykrywania zmian prędkości lub kierunku ruchu, co umożliwia monitorowanie różnych aktywności fizycznych oraz dostosowywanie interakcji z urządzeniem do jego położenia w przestrzeni.',
    'Żyroskop':
        'Żyroskop w smartwatchu to czujnik mierzący prędkość obrotową urządzenia wokół osi. Działa na zasadzie utrzymywania stabilności kierunkowej, umożliwiając dokładne śledzenie ruchu obrotowego. Łącząc dane z akcelerometru, który mierzy przyspieszenie, żyroskop pozwala na dokładniejsze monitorowanie ruchu trójwymiarowego.',
    'Stoper':
        'Umożliwia pomiar czasu od momentu rozpoczęcia pomiaru do chwili zatrzymania. Jest to przydatne narzędzie do mierzenia czasu trwania różnych zdarzeń, ćwiczeń, czy interwałów. Stoper zazwyczaj wyposażony jest w przyciski start, stop oraz reset.',
    'Alarm':
        'Funkcja umożliwiająca użytkownikowi ustawienie określonego czasu, o którym smartwatch poinformuje go za pomocą sygnału dźwiękowego, wibracji lub obu tych elementów jednocześnie.',
    'Odbiornik GPS':
        'Komponent, który umożliwia urządzeniu określanie swojej dokładnej lokalizacji geograficznej na podstawie sygnałów satelitarnych. Odbiornik GPS w smartwatchu otwiera szereg funkcji związanych z nawigacją, monitorowaniem aktywności fizycznej oraz zbieraniem danych o trasach i dystansie przebytym podczas różnych aktywności.',
    'Informacje pogodowe':
        'Wyświetlania informacji pogodowych, co pozwala użytkownikowi śledzić aktualne warunki atmosferyczne bez konieczności sięgania po telefon.',
    'Funkcja odbierania połączeń':
        'Umożliwia użytkownikom przyjmowanie i odrzucanie rozmów telefonicznych bez konieczności korzystania z telefonu komórkowego.',
    'System płatności':
        'Umożliwia dokonywanie transakcji finansowych bez konieczności korzystania z tradycyjnych metod płatności, takich jak gotówka czy karty płatnicze.',
    'Dysk optyczny':
        'Rodzaj nośnika danych, który wykorzystuje technologię optyczną do zapisu i odczytu informacji. Najpopularniejszymi rodzajami dysków optycznych są CD (Compact Disc), DVD (Digital Versatile Disc) i Blu-ray Disc (BD). Każdy z tych nośników ma swoje cechy i zastosowania.',
    'Pobór mocy':
        'ilość energii elektrycznej, którą urządzenie zużywa podczas normalnej pracy. Wyraża się go w jednostkach mocy, czyli watach (W). Pobór mocy jest ważnym parametrem, który informuje użytkownika o zużyciu energii przez urządzenie i wpływa na koszty eksploatacji.',
    'Format ekranu':
        'Parametr określający stosunek długości boków ekranu poziomego – do pionowego. Na rynku dostępne są ekrany panoramiczne oraz ekrany standardowe.',
    'Czas reakcji matrycy':
        'Miara czasu, jaki potrzebny jest dla piksela na ekranie, aby zmienić stan z jednego koloru na inny, zwykle od czerni do bieli i z powrotem. Jest to parametr istotny w kontekście monitorów, telewizorów i innych wyświetlaczy, a jego wartość wyrażana jest w milisekundach (ms).',
    'Liczba wyświetlanych kolorów':
        'Zależy głównie od głębokości kolorów, która jest mierzona w bitach na kanał koloru (RGB). większa głębokość kolorów pozwala na większą precyzję w odwzorowywaniu kolorów, co jest szczególnie istotne w dziedzinach, takich jak edycja grafiki, projektowanie, a także w przypadku monitorów do profesjonalnych zastosowań.',
    'HDR':
        'Technologia związana z reprodukcją obrazu, która ma na celu zwiększenie zakresu dynamicznego i poprawę jakości wyświetlanego obrazu. Standardy HDR obejmują różne specyfikacje dotyczące zakresu jasności, gamy kolorów i innych parametrów. Popularne standardy to HDR10, Dolby Vision, HLG (Hybrid Log-Gamma).',
    'Rozmiar ekranu':
        'Odległość między dwoma przeciwnymi narożnikami ekranu urządzenia, mierzona w calach lub centymetrach. Jest to kluczowa cecha, definiująca rozmiar ekranu i wpływająca na doznania wizualne podczas korzystania z urządzenia. Im większa przekątna, tym zazwyczaj większa powierzchnia wyświetlacza, co może wpływać na komfort użytkowania, zwłaszcza w przypadku multimediów i gier.',
    'Smart TV':
        'Smart TV to telewizor, który poza tradycyjnym odbiorem sygnału telewizyjnego oferuje możliwość korzystania z różnorodnych funkcji internetowych i aplikacji. Dzięki połączeniu z internetem, Smart TV umożliwia dostęp do różnych treści online, serwisów streamingowych, gier, a także innych usług dostępnych w sieci.',
    'System':
        'Smart TV, aby obsługiwać różnorodne funkcje internetowe i aplikacje, wymaga systemu operacyjnego dostosowanego do tych zadań. Istnieje kilka popularnych systemów operacyjnych stosowanych w telewizorach inteligentnych tj. webOS (LG), Tizen (Samsung), Android TV (Google).',
    'Wi-Fi':
        'Technologia Wi-Fi wykorzystuje fale radiowe do wytworzenia sieci bezprzewodowej. Dzięki niej przesyłanie danych czy korzystanie z internetu mogą się odbywać bez użycia przewodów.',
    'Montaż na ścianie':
        'Montaż na ścianie zgodny ze standardem VESA (Video Electronics Standards Association) to powszechnie stosowana metoda instalacji telewizora, monitora czy innego urządzenia z wyświetlaczem na ścianie. Standard VESA określa odstępy między otworami montażowymi na tylnym panelu urządzenia, co umożliwia stosowanie uniwersalnych uchwytów ściennych.',
    'Wymiary z podstawą':
        'Parametry, które określają rozmiary danego urządzenia, najczęściej wyrażane są w milimetrach (mm) i są liczone razem z podstawą telewizora.',
    'Wymiary bez podstawy':
        'Parametry, które określają rozmiary danego urządzenia, najczęściej wyrażane są w milimetrach (mm) i są liczone bez podstawy telewizora.',
    'Waga z podstawą':
        'Parametr określający masę danego urządzenia, najczęściej wyrażana w gramach (g) lub kilogramach (kg) i jest liczona z podstawą telewizora.',
    'Waga bez podstawy':
        'Parametr określający masę danego urządzenia, najczęściej wyrażana w gramach (g) lub kilogramach (kg) i jest liczona bez podstawy telewizora.'
  };
}
