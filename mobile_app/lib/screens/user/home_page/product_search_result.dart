import 'package:flutter/material.dart';
import '../../../authentication/auth.dart';
import '../../../constants/colors.dart';
import 'product_search_model.dart';

class ProductSearchResult extends StatefulWidget {
  final List<ProductSearchModel> displayList;

  const ProductSearchResult(this.displayList, {super.key});

  @override
  State<ProductSearchResult> createState() => _ProductSearchResultState();
}

class _ProductSearchResultState extends State<ProductSearchResult> {
  void signOut() async {
    await Auth().signOut();
  }

  // -------------------------------------------------------------
  // --------------- ŁADNE STYLOWANIE LISTY ZROBIĆ ---------------
  // -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results for searching'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Wynika wyszukiwania - znaleziono: ILOŚĆ',
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Wyszukiwana fraza: FRAZA',
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child: widget.displayList.isEmpty
                  ? const Center(
                      child: Text("Brak pasujacych produktów"),
                    )
                  : ListView.builder(
                      itemCount: widget.displayList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          widget.displayList[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Image.asset(
                          widget.displayList[index].imageAsset,
                          width: 50,
                          height: 50,
                        ),
                        trailing: Text(
                          widget.displayList[index].price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
