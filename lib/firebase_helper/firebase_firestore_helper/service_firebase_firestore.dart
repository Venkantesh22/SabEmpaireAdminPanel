import 'dart:typed_data';

import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceFirebaseFirestore {
  static ServiceFirebaseFirestore instance = ServiceFirebaseFirestore();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance;

  //! ---------------------- Super Category FUNCTIONS ----------------------

  /// Creates a new super category document.
  Future<SuperCategoryModel> createSuperCategory(
    String superCateName,
    Uint8List superCateImage,
  ) async {
    // Create a new document reference with an auto-generated ID.
    DocumentReference<Map<String, dynamic>> docRef =
        _firebaseFirestore.collection('superCategory').doc();

    String? _imageLink = await _firebaseStorageHelper.uploadSuperCateImage(
        superCateName, superCateImage);

    // Retrieve current admin UID.
    String? adminUid = FirebaseAuth.instance.currentUser?.uid;

    // Create a model instance.
    SuperCategoryModel superCategoryModel = SuperCategoryModel(
      id: docRef.id,
      adminId: adminUid!,
      superCategoryName: superCateName,
      // imgUrl:
      //     'https://img.freepik.com/free-photo/woman-getting-treatment-hairdresser-shop_23-2149229759.jpg?semt=ais_hybrid',
      imgUrl: _imageLink,
      haveData: false,
    );

    // Save the document to Firestore.
    await docRef.set(superCategoryModel.toJson());
    return superCategoryModel;
  }

  /// Retrieves a super category document by its [id].
  Future<SuperCategoryModel?> getSuperCategory(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firebaseFirestore.collection('superCategory').doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return SuperCategoryModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error retrieving super category: $e');
      rethrow;
    }
  }

  /// Updates an existing super category document with [updatedCategory] data.
  Future<void> updateSuperCategoryWithoutImage(
      SuperCategoryModel updatedCategory) async {
    try {
      await _firebaseFirestore
          .collection('superCategory')
          .doc(updatedCategory.id)
          .update(updatedCategory.toJson());
    } catch (e) {
      print('Error updating super category: $e');
      rethrow;
    }
  }

  /// Updates an existing super category document with [updatedCategory] data.
  Future<void> updateSuperCategoryWithImage(
    SuperCategoryModel updatedCategory,
    Uint8List selectedImage,
  ) async {
    try {
      String? _imageLink = await _firebaseStorageHelper.updateSuperCateImage(
          selectedImage, updatedCategory.imgUrl!, updatedCategory);
      SuperCategoryModel updateModel = updatedCategory.copyWith(
        imgUrl: _imageLink,
      );

      await _firebaseFirestore
          .collection('superCategory')
          .doc(updateModel.id)
          .update(updateModel.toJson());
    } catch (e) {
      print('Error updating super category: $e');
      rethrow;
    }
  }

  /// Deletes a super category document by its [id].
  Future<bool> deleteSuperCategory(SuperCategoryModel superCateModel) async {
    try {
      await _firebaseFirestore
          .collection('superCategory')
          .doc(superCateModel.id)
          .delete();
      await _firebaseStorageHelper
          .deleteImageFromFirebase(superCateModel.imgUrl!);
      return true;
    } catch (e) {
      print('Error deleting super category: $e');
      rethrow;
    }
  }

  /// Retrieves a list of all super category documents.
  Future<List<SuperCategoryModel>> getAllSuperCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('superCategory').get();

      return querySnapshot.docs
          .map((doc) => SuperCategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error retrieving super categories: $e');
      // Return an empty list if there's an error.
      return [];
    }
  }

  //! ----------------------  Category FUNCTIONS ----------------------

  /// Create a new category under the given super category.
  Future<CategoryModel> createCategory(
    String cateName,
    SuperCategoryModel superCategoryModel,
  ) async {
    try {
      DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryModel.id)
          .collection("category")
          .doc();

      CategoryModel categoryModel = CategoryModel(
        id: reference.id,
        categoryName: cateName,
        haveData: false,
        superCategoryName: superCategoryModel.superCategoryName,
      );

      await reference.set(categoryModel.toJson());
      return categoryModel;
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  /// Get a single category by its ID under a specified super category.
  Future<CategoryModel?> getCategory(
      String superCategoryId, String categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryId)
              .collection("category")
              .doc(categoryId)
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return CategoryModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error retrieving category: $e');
      rethrow;
    }
  }

  /// Update an existing category.
  Future<void> updateCategory(
      CategoryModel categoryModel, String superCategoryId) async {
    try {
      await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /// Delete a category.
  Future<bool> deleteCategory(String superCategoryId, String categoryId) async {
    try {
      await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  /// Retrieve a list of all categories under a specific super category.
  Future<List<CategoryModel>> getCategoryListFirebase(
      String superCategoryId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryId)
              .collection("category")
              .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error retrieving categories: $e');
      rethrow;
    }
  }
  //! ----------------------  Service  FUNCTIONS ----------------------

  /// Create a new ServiceModel document.
  Future<ServiceModel> createService(
    String cateName,
    String categoryId,
    SuperCategoryModel superCategoryModel,
    String servicesName,
    double price,
    int serviceDurationMin,
  ) async {
    try {
      // Create a new document reference in the "category" subcollection
      // under the super category document.
      DocumentReference<Map<String, dynamic>> reference =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryModel.id)
              .collection("category")
              .doc(categoryId)
              .collection("services")
              .doc();

      ServiceModel serviceModel = ServiceModel(
        id: reference.id,
        categoryId: categoryId,
        categoryName: cateName,
        superCategoryName: superCategoryModel.superCategoryName,
        servicesName: servicesName,
        price: price,
        serviceDurationMin: serviceDurationMin,
      );

      await reference.set(serviceModel.toJson());
      return serviceModel;
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  /// Retrieve a single ServiceModel document.
  /// [superCategoryId] is the id of the super category document.
  /// [serviceId] is the id of the service document.
  Future<ServiceModel?> getService(
    String superCategoryId,
    String categoryId,
    String serviceId,
  ) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryId)
              .collection("category")
              .doc(categoryId)
              .collection("services")
              .doc(serviceId)
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return ServiceModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error retrieving service: $e');
      rethrow;
    }
  }

  /// Update an existing ServiceModel document.
  /// [superCategoryId] is the id of the parent super category document.
  Future<void> updateService(
    ServiceModel serviceModel,
    String superCategoryId,
    String categoryId,
  ) async {
    try {
      await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .doc(serviceModel.id)
          .update(serviceModel.toJson());
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  /// Delete a ServiceModel document.
  /// [superCategoryId] is the id of the parent super category document.
  Future<bool> deleteService(
      String superCategoryId, String categoryId, String serviceId) async {
    try {
      await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .doc(serviceId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }

  /// Retrieve a list of ServiceModel documents for a given category.
  /// [superCategoryId] is the id of the parent super category document.
  /// [categoryId] is the id used as a field in ServiceModel to filter services.
  Future<List<ServiceModel>> getServicesByCategory(
      String superCategoryId, String categoryId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryId)
              .collection("category")
              .doc(categoryId)
              .collection("services")
              .get();

      return querySnapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error retrieving services: $e');
      rethrow;
    }
  }

  //! ----------------------  Service  FUNCTIONS ----------------------

  // Create a new threeCategory document
  Future<CategoryModel> createThreeCategory({
    required String superCategoryModelId,
    required CategoryModel threeCategory,
  }) async {
    DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
        .collection("superCategory")
        .doc(superCategoryModelId)
        .collection("threeCategory")
        .doc();

    CategoryModel categoryModelUpdate = threeCategory.copyWith(
      id: reference.id,
    );

    await reference.set(categoryModelUpdate.toJson());
    return categoryModelUpdate;
    // .doc(threeCategoryId)
    // .set(data);
  }

  // Update an existing threeCategory document
  Future<void> updateThreeCategory({
    required String superCategoryId,
    required String threeCategoryId,
    required Map<String, dynamic> data,
  }) async {
    await _firebaseFirestore
        .collection("superCategory")
        .doc(superCategoryId)
        .collection("threeCategory")
        .doc(threeCategoryId)
        .update(data);
  }

  // Delete a threeCategory document
  Future<void> deleteThreeCategory({
    required String superCategoryId,
    required String threeCategoryId,
  }) async {
    await _firebaseFirestore
        .collection("superCategory")
        .doc(superCategoryId)
        .collection("threeCategory")
        .doc(threeCategoryId)
        .delete();
  }

  // Get a list of threeCategory documents
  Future<List<Map<String, dynamic>>> getListOfThreeCategory({
    required String superCategoryId,
  }) async {
    final querySnapshot = await _firebaseFirestore
        .collection("superCategory")
        .doc(superCategoryId)
        .collection("threeCategory")
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
