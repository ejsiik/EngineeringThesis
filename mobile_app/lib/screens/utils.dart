import 'package:flutter/material.dart';

class Utils {
  static void showSnackBarSimpleMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static void showSnackBarShoppingCart(
      BuildContext context, int quantity) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [
            Row(
              children: [
                Text(
                  "Produkt został dodany do koszyka.",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            /*Row(
              children: [
                Text(
                  "Ilość produktu w koszyku: ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  static void showSnackBarWishList(BuildContext context, bool addOrRemove) {
    String message =
        addOrRemove ? ' z listy obserwowanych' : ' do listy obserwowanych';

    String boldText = addOrRemove ? 'Usunięto' : 'Dodano';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [
            Row(
              children: [
                Text(
                  boldText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
