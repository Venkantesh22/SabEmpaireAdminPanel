import 'dart:typed_data';
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
    int order,
    Uint8List superCateImage,
  ) async {
    try {
      // Create a new document reference with an auto-generated ID.
      DocumentReference<Map<String, dynamic>> docRef =
          _firebaseFirestore.collection('superCategory').doc();

      // Use a batch to update existing documents and set the new one atomically.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query super categories that have order greater than or equal to the new order.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('superCategory')
          .where('order', isGreaterThanOrEqualTo: order)
          .get();

      // For each conflicting document, increment its order by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Upload the image to Firebase Storage.
      String? _imageLink = await FirebaseStorageHelper.instance
          .uploadSuperCateImage(superCateName, superCateImage);

      // Retrieve current admin UID.
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;
      if (adminUid == null) {
        throw Exception("User is not logged in");
      }

      // Create a new SuperCategoryModel instance.
      SuperCategoryModel superCategoryModel = SuperCategoryModel(
        id: docRef.id,
        adminId: adminUid,
        superCategoryName: superCateName,
        order: order,
        imgUrl: _imageLink,
        haveData: false,
      );

      // Add the new document set operation to the batch.
      batch.set(docRef, superCategoryModel.toJson());

      // Commit the batch so all updates and the new document are applied atomically.
      await batch.commit();

      return superCategoryModel;
    } catch (e) {
      print("Error creating super category: $e");
      rethrow;
    }
  }

  // Future<SuperCategoryModel> createSuperCategory(
  //   String superCateName,
  //   int order,
  //   Uint8List superCateImage,
  // ) async {
  //   // Create a new document reference with an auto-generated ID.
  //   DocumentReference<Map<String, dynamic>> docRef =
  //       _firebaseFirestore.collection('superCategory').doc();

  //   String? _imageLink = await _firebaseStorageHelper.uploadSuperCateImage(
  //       superCateName, superCateImage);

  //   // Retrieve current admin UID.
  //   String? adminUid = FirebaseAuth.instance.currentUser?.uid;

  //   // Create a model instance.
  //   SuperCategoryModel superCategoryModel = SuperCategoryModel(
  //     id: docRef.id,
  //     adminId: adminUid!,
  //     superCategoryName: superCateName,
  //     order: order,

  //     imgUrl: _imageLink,
  //     haveData: false,
  //   );

  //   // Save the document to Firestore.
  //   await docRef.set(superCategoryModel.toJson());
  //   return superCategoryModel;
  // }

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

  // /// Updates an existing super category document with [updatedCategory] data.
  // Future<void> updateSuperCategoryWithoutImage(
  //     SuperCategoryModel updatedCategory) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('superCategory')
  //         .doc(updatedCategory.id)
  //         .update(updatedCategory.toJson());
  //   } catch (e) {
  //     print('Error updating super category: $e');
  //     rethrow;
  //   }
  // }
  Future<void> updateSuperCategoryWithoutImage(
      SuperCategoryModel updatedCategory) async {
    try {
      // Create a batch write to update multiple documents atomically.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query super categories with an order >= the updatedCategory's order,
      // excluding the current document.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('superCategory')
          .where('order', isGreaterThanOrEqualTo: updatedCategory.order)
          .get();

      for (var doc in snapshot.docs) {
        // Skip the document that we're updating.
        if (doc.id == updatedCategory.id) continue;

        // Read the current order (assuming it's stored as an int).
        int currentOrder = doc.data()['order'] ?? 0;

        // Update the order value by incrementing it by 1.
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Get reference for the current super category document.
      DocumentReference<Map<String, dynamic>> docRef = _firebaseFirestore
          .collection('superCategory')
          .doc(updatedCategory.id);

      // Update the current document with the updatedCategory data.
      batch.update(docRef, updatedCategory.toJson());

      // Commit the batch.
      await batch.commit();
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
      // Update the image in Firebase Storage.
      String? _imageLink = await FirebaseStorageHelper.instance
          .updateSuperCateImage(
              selectedImage, updatedCategory.imgUrl!, updatedCategory);

      // Create a new model with the updated image URL.
      SuperCategoryModel updateModel = updatedCategory.copyWith(
        imgUrl: _imageLink,
      );

      // Start a batch update.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query all super category documents with order >= updated order,
      // excluding the current document.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('superCategory')
          .where('order', isGreaterThanOrEqualTo: updateModel.order)
          .get();

      for (var doc in snapshot.docs) {
        if (doc.id == updateModel.id) continue;
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Update the current super category document with the updated model.
      DocumentReference<Map<String, dynamic>> docRef =
          _firebaseFirestore.collection('superCategory').doc(updateModel.id);
      batch.update(docRef, updateModel.toJson());

      // Commit all changes atomically.
      await batch.commit();
    } catch (e) {
      print('Error updating super category: $e');
      rethrow;
    }
  }

  /// Deletes a super category document by its [id].
  Future<bool> deleteSuperCategory(SuperCategoryModel superCateModel) async {
    try {
      WriteBatch batch = _firebaseFirestore.batch();

      // Retrieve the order of the category being deleted.
      int deletedOrder = superCateModel.order;

      // Reference to the super category document.
      DocumentReference<Map<String, dynamic>> superCateRef =
          _firebaseFirestore.collection('superCategory').doc(superCateModel.id);

      // Query and delete all associated categories within this super category.
      QuerySnapshot<Map<String, dynamic>> categorySnapshot =
          await superCateRef.collection('category').get();

      for (var doc in categorySnapshot.docs) {
        batch.delete(doc.reference); // Delete each category
      }

      // Delete the super category document.
      batch.delete(superCateRef);

      // Query all super categories with order greater than the deleted one.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('superCategory')
          .where('order', isGreaterThan: deletedOrder)
          .get();

      // Update order of remaining categories by decrementing them by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder - 1});
      }

      // Commit batch to ensure atomic operations.
      await batch.commit();

      // Delete the image from Firebase Storage.
      await _firebaseStorageHelper
          .deleteImageFromFirebase(superCateModel.imgUrl!);

      return true;
    } catch (e) {
      print('Error deleting super category: $e');
      rethrow;
    }
  }

  // Future<bool> deleteSuperCategory(SuperCategoryModel superCateModel) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('superCategory')
  //         .doc(superCateModel.id)
  //         .delete();
  //     await _firebaseStorageHelper
  //         .deleteImageFromFirebase(superCateModel.imgUrl!);
  //     return true;
  //   } catch (e) {
  //     print('Error deleting super category: $e');
  //     rethrow;
  //   }
  // }

  /// Retrieves a list of all super category documents.
  Stream<List<SuperCategoryModel>> getAllSuperCategories() {
    try {
      return _firebaseFirestore.collection('superCategory').snapshots().map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => SuperCategoryModel.fromJson(doc.data()))
                .toList(),
          );
    } catch (e) {
      print('Error retrieving super categories: $e');
      // Return an empty stream if there's an error.
      return Stream.value([]);
    }
  }

  //! ----------------------  Category FUNCTIONS ----------------------

  /// Create a new category under the given super category.
  Future<CategoryModel> createCategory(
    String cateName,
    int order,
    SuperCategoryModel superCategoryModel,
  ) async {
    try {
      // Create a new document reference for the new category.
      DocumentReference<Map<String, dynamic>> ref = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryModel.id)
          .collection("category")
          .doc();

      // Create a batch for atomic updates.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query all existing categories in the given super category whose order is >= the new order.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryModel.id)
          .collection("category")
          .where("order", isGreaterThanOrEqualTo: order)
          .get();

      // For each document, update its order by incrementing by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Create a new CategoryModel instance with the new order.
      CategoryModel categoryModel = CategoryModel(
        id: ref.id,
        categoryName: cateName,
        order: order, // Make sure your CategoryModel has this field.
        haveData: false,
        superCategoryName: superCategoryModel.superCategoryName,
      );

      // Set the new category document in the batch.
      batch.set(ref, categoryModel.toJson());

      // Commit the batch atomically.
      await batch.commit();
      return categoryModel;
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  // Future<CategoryModel> createCategory(
  //   String cateName,
  //   SuperCategoryModel superCategoryModel,
  // ) async {
  //   try {
  //     DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryModel.id)
  //         .collection("category")
  //         .doc();

  //     CategoryModel categoryModel = CategoryModel(
  //       id: reference.id,
  //       categoryName: cateName,
  //       haveData: false,
  //       superCategoryName: superCategoryModel.superCategoryName,
  //     );

  //     await reference.set(categoryModel.toJson());
  //     return categoryModel;
  //   } catch (e) {
  //     print('Error creating category: $e');
  //     rethrow;
  //   }
  // }

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
      CategoryModel updatedCategory, String superCategoryId) async {
    try {
      // Create a batch to update multiple documents atomically.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query all categories under the same superCategoryId that have an order
      // greater than or equal to the new order of the updated category.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .where("order", isGreaterThanOrEqualTo: updatedCategory.order)
          .get();

      // For each conflicting category document, update its order by incrementing by 1.
      for (var doc in snapshot.docs) {
        // Skip the document we are updating.
        if (doc.id == updatedCategory.id) continue;
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Get reference to the current category document.
      DocumentReference<Map<String, dynamic>> docRef = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(updatedCategory.id);

      // Update the current category document with new values.
      batch.update(docRef, updatedCategory.toJson());

      // Commit the batch so that all updates occur atomically.
      await batch.commit();
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /////////////////////
  // Future<void> updateCategory(
  //     CategoryModel categoryModel, String superCategoryId) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryId)
  //         .collection("category")
  //         .doc(categoryModel.id)
  //         .update(categoryModel.toJson());
  //   } catch (e) {
  //     print('Error updating category: $e');
  //     rethrow;
  //   }
  // }

  /// Delete a category.
  Future<bool> deleteCategory(String superCategoryId, String categoryId) async {
    try {
      // Retrieve the document to be deleted to get its order.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firebaseFirestore
              .collection("superCategory")
              .doc(superCategoryId)
              .collection("category")
              .doc(categoryId)
              .get();

      if (!docSnapshot.exists) {
        print("Category document does not exist.");
        return false;
      }

      int deletedOrder = docSnapshot.data()?['order'] ?? 0;

      // Start a batch update.
      WriteBatch batch = _firebaseFirestore.batch();

      // Delete the category document.
      DocumentReference<Map<String, dynamic>> deleteRef = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId);
      batch.delete(deleteRef);

      // Query all categories with order greater than the deleted category's order.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .where("order", isGreaterThan: deletedOrder)
          .get();

      // For each category in the query, decrement its order by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder - 1});
      }

      // Commit the batch atomically.
      await batch.commit();
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // Future<bool> deleteCategory(String superCategoryId, String categoryId) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryId)
  //         .collection("category")
  //         .doc(categoryId)
  //         .delete();
  //     return true;
  //   } catch (e) {
  //     print('Error deleting category: $e');
  //     rethrow;
  //   }
  // }

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
  //! ----------------------  SERVICE  FUNCTIONS ----------------------

  /// Create a new ServiceModel document.
  // Future<ServiceModel> createService(
  //   String cateName,
  //   String categoryId,
  //   SuperCategoryModel superCategoryModel,
  //   String servicesName,
  //   double price,
  //   int serviceDurationMin,
  //   int order, // Desired order input
  // ) async {
  //   try {
  //     // Create a new document reference in the services subcollection.
  //     DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryModel.id)
  //         .collection("category")
  //         .doc(categoryId)
  //         .collection("services")
  //         .doc();

  //     // Create a batch write for atomic updates.
  //     WriteBatch batch = _firebaseFirestore.batch();

  //     // Query services with order equal to the desired order.
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryModel.id)
  //         .collection("category")
  //         .doc(categoryId)
  //         .collection("services")
  //         .where("order", isEqualTo: order)
  //         .get();

  //     // For each conflicting service, update its order to order + 1 (shift once).
  //     for (var doc in snapshot.docs) {
  //       batch.update(doc.reference, {'order': order + 1});
  //     }

  //     // Create the new service model with the desired order.
  //     ServiceModel serviceModel = ServiceModel(
  //       id: reference.id,
  //       categoryId: categoryId,
  //       categoryName: cateName,
  //       superCategoryName: superCategoryModel.superCategoryName,
  //       servicesName: servicesName,
  //       price: price,
  //       serviceDurationMin: serviceDurationMin,
  //       order: order,
  //     );

  //     // Add the new service document to the batch.
  //     batch.set(reference, serviceModel.toJson());

  //     // Commit the batch atomically.
  //     await batch.commit();

  //     return serviceModel;
  //   } catch (e) {
  //     print('Error creating service: $e');
  //     rethrow;
  //   }
  // }
  Future<ServiceModel> createService(
    String cateName,
    String categoryId,
    SuperCategoryModel superCategoryModel,
    String servicesName,
    double price,
    int serviceDurationMin,
    int order, // Desired order input
  ) async {
    try {
      // Create a new document reference in the "services" subcollection
      DocumentReference<Map<String, dynamic>> reference = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryModel.id)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .doc();

      // Create a batch for atomic updates.
      WriteBatch batch = _firebaseFirestore.batch();

      // Query all existing services in the given category whose order is >= the new order.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryModel.id)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .where("order", isGreaterThanOrEqualTo: order)
          .get();

      // For each document, update its order by incrementing by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder + 1});
      }

      // Create the new service model with the desired order.
      ServiceModel serviceModel = ServiceModel(
        id: reference.id,
        categoryId: categoryId,
        categoryName: cateName,
        superCategoryName: superCategoryModel.superCategoryName,
        servicesName: servicesName,
        price: price,
        serviceDurationMin: serviceDurationMin,
        order: order,
      );

      // Set the new service document in the batch.
      batch.set(reference, serviceModel.toJson());

      // Commit the batch atomically.
      await batch.commit();

      return serviceModel;
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  // /// Retrieve a single ServiceModel document.
  // /// [superCategoryId] is the id of the super category document.
  // /// [serviceId] is the id of the service document.
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

  Future<ServiceModel> updateService(
    ServiceModel updatedService,
    String superCategoryId,
    String categoryId,
  ) async {
    try {
      // Reference to the current service document.
      DocumentReference<Map<String, dynamic>> serviceRef = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .doc(updatedService.id);

      // Fetch the current service document to get its order.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await serviceRef.get();
      if (!docSnapshot.exists) {
        throw Exception("Service not found");
      }
      int oldOrder = docSnapshot.data()?['order'] ?? 0;
      int newOrder = updatedService.order;

      WriteBatch batch = _firebaseFirestore.batch();

      // If new order is lower than the old order, services between newOrder and oldOrder should be incremented.
      if (newOrder < oldOrder) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
            .collection("superCategory")
            .doc(superCategoryId)
            .collection("category")
            .doc(categoryId)
            .collection("services")
            .where('order', isGreaterThanOrEqualTo: newOrder)
            .where('order', isLessThan: oldOrder)
            .get();
        for (var doc in snapshot.docs) {
          int currentOrder = doc.data()['order'] ?? 0;
          batch.update(doc.reference, {'order': currentOrder + 1});
        }
      }
      // If new order is greater than the old order, services between oldOrder and newOrder should be decremented.
      else if (newOrder > oldOrder) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
            .collection("superCategory")
            .doc(superCategoryId)
            .collection("category")
            .doc(categoryId)
            .collection("services")
            .where('order', isGreaterThan: oldOrder)
            .where('order', isLessThanOrEqualTo: newOrder)
            .get();
        for (var doc in snapshot.docs) {
          int currentOrder = doc.data()['order'] ?? 0;
          batch.update(doc.reference, {'order': currentOrder - 1});
        }
      }

      // Update the current service document with the new values.
      batch.update(serviceRef, updatedService.toJson());

      // Commit all changes atomically.
      await batch.commit();
      return updatedService;
    } catch (e) {
      print("Error updating service: $e");
      rethrow;
    }
  }

  Future<bool> deleteService(
    String superCategoryId,
    String categoryId,
    String serviceId,
  ) async {
    try {
      // Reference to the service to delete.
      DocumentReference<Map<String, dynamic>> serviceRef = _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .doc(serviceId);

      // Get the document to determine the order.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await serviceRef.get();
      if (!docSnapshot.exists) {
        throw Exception("Service not found");
      }
      int deletedOrder = docSnapshot.data()?['order'] ?? 0;

      WriteBatch batch = _firebaseFirestore.batch();

      // Delete the service document.
      batch.delete(serviceRef);

      // Query all services with an order greater than the deleted service's order.
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("superCategory")
          .doc(superCategoryId)
          .collection("category")
          .doc(categoryId)
          .collection("services")
          .where('order', isGreaterThan: deletedOrder)
          .get();

      // For each service, decrement its order by 1.
      for (var doc in snapshot.docs) {
        int currentOrder = doc.data()['order'] ?? 0;
        batch.update(doc.reference, {'order': currentOrder - 1});
      }

      // Commit the batch.
      await batch.commit();
      return true;
    } catch (e) {
      print("Error deleting service: $e");
      rethrow;
    }
  }

  /// Update an existing ServiceModel document.
  /// [superCategoryId] is the id of the parent super category document.
  // Future<void> updateService(
  //   ServiceModel serviceModel,
  //   String superCategoryId,
  //   String categoryId,
  // ) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryId)
  //         .collection("category")
  //         .doc(categoryId)
  //         .collection("services")
  //         .doc(serviceModel.id)
  //         .update(serviceModel.toJson());
  //   } catch (e) {
  //     print('Error updating service: $e');
  //     rethrow;
  //   }
  // }

  // /// Delete a ServiceModel document.
  // /// [superCategoryId] is the id of the parent super category document.
  // Future<bool> deleteService(
  //     String superCategoryId, String categoryId, String serviceId) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection("superCategory")
  //         .doc(superCategoryId)
  //         .collection("category")
  //         .doc(categoryId)
  //         .collection("services")
  //         .doc(serviceId)
  //         .delete();
  //     return true;
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //     rethrow;
  //   }
  // }

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
