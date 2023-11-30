import 'package:flutter/material.dart';
import 'package:m_09/detailProduct.dart';
import 'package:m_09/editProduct.dart';
import 'addProduct.dart';
import 'helper/currencyHelper.dart';
import 'helper/firestoreHelper.dart';
import 'model/product.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff393E46),
        title: Text(
          'Product List',
          style: TextStyle(color: Color(0xff1EEEEEE)),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: FirestoreHelper().streamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            List<Product> products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    child: Card(
                      color: Color(0xff1EEEEEE),
                      elevation: 5,
                      child: Center(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 8, right: 5),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailProduct(product: product)));
                          },
                          onLongPress: () {
                            _showDeleteConfirmationDialog(context, product);
                          },
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                              CurrencyFormat.convertToIdr(product.price, 0)),
                          trailing: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProductPage(product: product)));
                              },
                              child: Text("Edit")),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete ${product.title}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirestoreHelper().deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
