import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String category = "Electronics";
  final TextEditingController imageController = TextEditingController();
  List<String> categories = [
    "Electronics",
    "Jewelry",
    "Men's clothing",
    "Women's clothing",
    "Others"
  ];

  String defaultImageUrl =
      'https://cdn.discordapp.com/attachments/972198684550897696/1179719458546274374/Desain_tanpa_judul_3.png?ex=657ace5d&is=6568595d&hm=5cddc6b112fc89c7198993f0a38a0cf6f9607981506e3240b6029682ddc58f77&';

  void addProduct() async {
    String title = titleController.text;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text;
    String image = imageController.text;

    image = Uri.parse(image).isAbsolute ? image : defaultImageUrl;

    if (title.isNotEmpty && price > 0) {
      int highestId = await getHighestId();
      Product newProduct = Product(
        id: (highestId + 1).toString(),
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc((highestId + 1).toString())
          .set(newProduct.toMap());
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
              Text('Title is required and price should be greater than 0.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<int> getHighestId() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return int.parse(querySnapshot.docs.first.data()['id']);
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff393E46),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff1EEEEEE),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Product', style: TextStyle(color: Color(0xff1EEEEEE))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Color(0xff1EEEEEE)),
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xff1EEEEEE)),
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xff1EEEEEE)),
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                borderRadius: BorderRadius.circular(8),
                dropdownColor: Color(0xff393E46),
                value: category,
                onChanged: (value) {
                  setState(() {
                    category = value.toString();
                  });
                },
                items: categories.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Color(0xff1EEEEEE),
                      ),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xff1EEEEEE)),
                controller: imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: Color(0xff393E46)),
                onPressed: addProduct,
                child: Center(
                    child: Text('Add Product',
                        style: TextStyle(color: Color(0xff100ADB5)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
