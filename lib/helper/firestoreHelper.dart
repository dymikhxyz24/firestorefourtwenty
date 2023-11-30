import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class FirestoreHelper {
  Stream<List<Product>> streamData() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('products').orderBy('id').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Product.fromDocSnapshot(doc))
              .toList(),
        );
  }

  Future<void> addProduct(Product product) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('products')
        .doc(product.id.toString())
        .update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('products').doc(productId).delete();
  }
}
