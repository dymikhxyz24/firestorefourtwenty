import 'package:flutter/material.dart';

import 'helper/currencyHelper.dart';
import 'model/product.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key, required this.product});
  final Product product;
  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Produk",
          style: TextStyle(color: Color(0xff1EEEEEE)),
        ),
        backgroundColor: Color(0xff393E46),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff1EEEEEE),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
        foregroundColor: Colors.white,
      ),
      body: detailProduk(context),
    );
  }

  SingleChildScrollView detailProduk(BuildContext context) {
    return SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Image.network(
        widget.product.image,
        height: 300,
        fit: BoxFit.cover,
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyFormat.convertToIdr(widget.product.price, 0),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1EEEEEE)),
            ),
            Text(
              widget.product.title,
              style: TextStyle(fontSize: 16, color: Color(0xff1EEEEEE)),
            ),
            SizedBox(height: 10),
            Text(
              "Detail produk",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1EEEEEE)),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "Kondisi",
                  style: TextStyle(fontSize: 14, color: Color(0xff1EEEEEE)),
                ),
                SizedBox(width: 88),
                Text("Baru")
              ],
            ),
            Divider(),
            Row(
              children: [
                Text("Min. Pemesanan",
                    style: TextStyle(fontSize: 14, color: Color(0xff1EEEEEE))),
                SizedBox(width: 24),
                Text(
                  "1 Buah",
                  style: TextStyle(color: Color(0xff1EEEEEE)),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Text("Kategori",
                    style: TextStyle(fontSize: 14, color: Color(0xff1EEEEEE))),
                SizedBox(width: 80),
                Text(
                  "${widget.product.category}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff186F65)),
                )
              ],
            ),
            Divider(),
            SizedBox(height: 12),
            Text(
              "Deskripsi produk",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1EEEEEE)),
            ),
            SizedBox(height: 6),
            Text(
              "${widget.product.description}",
              style: TextStyle(color: Color(0xff1EEEEEE)),
            )
          ],
        ),
      )
    ]));
  }
}
