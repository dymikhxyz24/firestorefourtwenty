import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/product.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late String category;
  late TextEditingController imageController;

  List<String> categories = [
    "Electronics",
    "Jewelry",
    "Men's clothing",
    "Women's clothing",
    "Others"
  ];
  late String originalId;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
    category = widget.product.category;
    imageController = TextEditingController(text: widget.product.image);
    originalId = widget.product.id;
    print(originalId);
  }

  void updateProduct() async {
    String title = titleController.text;
    int price = int.tryParse(priceController.text) ?? 0;
    String description = descriptionController.text;
    String image = imageController.text;

    image = Uri.parse(image).isAbsolute ? image : widget.product.image;

    if (title.isNotEmpty && price > 0) {
      Product updatedProduct = Product(
        id: originalId,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc(updatedProduct.id)
          .update(updatedProduct.toMap());

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
        title: Text(
          'Edit Product',
          style: TextStyle(color: Color(0xff1EEEEEE)),
        ),
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
                onPressed: updateProduct,
                child: Center(
                    child: Text('Update Product',
                        style: TextStyle(color: Color(0xff1EEEEEE)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
