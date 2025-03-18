import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/product_category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  //Firestore Instance
  final _db = FirebaseFirestore.instance;

  //Create Product
  Future<String> createProduct(ProductModel product) async {
    try {
      final result = await _db.collection('Products').add(product.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Create Product Category
  Future<String> createProductCategory(
      ProductCategoryModel productCategory) async {
    try {
      final result =
          await _db.collection('ProductCategory').add(productCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Update Product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _db.collection('Products').doc(product.id).update(product.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Update Product Instance
  Future<void> updateProductSpecificValue(id, Map<String, dynamic> data) async {
    try {
      await _db.collection('Products').doc(id).update(data);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Fetch Product
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Fetch Product Categories
  Future<List<ProductCategoryModel>> getProductCategories(
      String productId) async {
    try {
      final snapshot = await _db
          .collection('ProductCategory')
          .where('ProductId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((querySnapshot) =>
              ProductCategoryModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Delete Product
  Future<void> deleteProduct(ProductModel product) async {
    try {
      //Delete All Data
      await _db.runTransaction(
        (transaction) async {
          final productRef = _db.collection('Products').doc(product.id);
          final productSnap = await transaction.get(productRef);

          if (!productSnap.exists) {
            throw Exception('Product not found');
          }

          //Fetch ProductCategories
          final productCategoriesSnapshot = await _db
              .collection('ProductCategory')
              .where('ProductId', isEqualTo: product.id)
              .get();
          final productCategories = productCategoriesSnapshot.docs
              .map((e) => ProductCategoryModel.fromSnapshot(e));

          if (productCategories.isNotEmpty) {
            for (var productCategory in productCategories) {
              transaction.delete(
                  _db.collection('ProductCategory').doc(productCategory.id));
            }
          }

          transaction.delete(productRef);
        },
      );
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  Future<void> removeProductCategory(
      String productId, String categoryId) async {
    try {
      final result = await _db
          .collection('ProductCategory')
          .where('ProductId', isEqualTo: productId)
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      for (final doc in result.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }
}
