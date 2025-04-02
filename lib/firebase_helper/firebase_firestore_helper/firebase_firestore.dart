// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/models/image_model/image_model.dart';
import 'package:admin_panel_ak/models/job_model/job_model.dart';
import 'package:admin_panel_ak/models/service_provider_model/service_provider_model.dart';
import 'package:admin_panel_ak/models/user_enquiry_model/user_enquiry_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorageHelper _firebaseStorageHelper =
      FirebaseStorageHelper.instance;

  //! ---------------------- BANNER IMAGE FUNCTIONS ----------------------

  /// Fatch Web banner image.
  Stream<List<ImageModel>> getBannerImagesStream() {
    try {
      // Reference the subcollection "WebBinnerImage" under the fixed parent document "banner".
      CollectionReference<Map<String, dynamic>> bannerCollection = _firestore
          .collection("Image")
          .doc("banner")
          .collection("WebBinnerImage");

      // Listen to real-time updates and map each document to an ImageModel.
      return bannerCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ImageModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print("Error fetching banner images: $e");
      return Stream.error(e);
    }
  }

  /// Fatch Tab banner image.

  Stream<List<ImageModel>> getTabBannerImages() {
    try {
      // Reference the subcollection "WebBinnerImage" under the fixed parent document "banner".
      CollectionReference<Map<String, dynamic>> bannerCollection = _firestore
          .collection("Image")
          .doc("banner")
          .collection("TabBinnerImage");

      // Listen to real-time updates and map each document to an ImageModel.
      return bannerCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ImageModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print("Error fetching banner images: $e");
      return Stream.error(e);
    }
  }

  Stream<List<ImageModel>> getMobileBannerImages() {
    try {
      // Reference the subcollection "WebBinnerImage" under the fixed parent document "banner".
      CollectionReference<Map<String, dynamic>> bannerCollection = _firestore
          .collection("Image")
          .doc("banner")
          .collection("MobileBinnerImage");

      // Listen to real-time updates and map each document to an ImageModel.
      return bannerCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ImageModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print("Error fetching banner images: $e");
      return Stream.error(e);
    }
  }

// upload Web banner images
  Future<void> uploadBannerData(String imageName, Uint8List imageBytes) async {
    try {
      // Use a fixed document ID ("banner") in the "Image" collection.
      DocumentReference<Map<String, dynamic>> parentRef =
          _firestore.collection("Image").doc("banner");

      // Reference the subcollection "WebBinnerImage" under the parent document.
      // This creates a new document with an auto-generated ID in the subcollection.
      DocumentReference<Map<String, dynamic>> subDocRef =
          parentRef.collection("WebBinnerImage").doc();

      // Upload the image bytes to Firebase Storage using your helper.
      // Assume uploadBannerImageToStorage returns a URL String.
      String? imageUrl =
          await _firebaseStorageHelper.uploadBannerImageToStorage(
        imageName,
        imageBytes,
      );

      // Prepare the data to be saved in Firestore.
      Map<String, dynamic> data = {
        "id": subDocRef.id,
        "name": imageName,
        "image": imageUrl,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Save the data into the subcollection document.
      await subDocRef.set(data);
    } catch (e) {
      print("Error uploading banner data: $e");
      rethrow;
    }
  }

  /// Deletes an image document by its [imageId].
  Future<bool> deleteBannerImage(ImageModel imageModel) async {
    try {
      await _firestore
          .collection("Image")
          .doc("banner")
          .collection("WebBinnerImage")
          .doc(imageModel.id)
          .delete();
      await _firebaseStorageHelper.deleteImageFromFirebase(imageModel.image);
      return true;
    } catch (e) {
      print("Error deleting image: $e");
      rethrow;
    }
  }

// ---------- Tab ----------------------------------
  /// Creates a new image document in the "Image" collection.
  Future<void> uploadTabBannerData(
      String imageName, Uint8List imageBytes) async {
    try {
      // Use a fixed document ID ("banner") in the "Image" collection.
      DocumentReference<Map<String, dynamic>> parentRef =
          _firestore.collection("Image").doc("banner");

      // Reference the subcollection "WebBinnerImage" under the parent document.
      // This creates a new document with an auto-generated ID in the subcollection.
      DocumentReference<Map<String, dynamic>> subDocRef =
          parentRef.collection("TabBinnerImage").doc();

      // Upload the image bytes to Firebase Storage using your helper.
      // Assume uploadBannerImageToStorage returns a URL String.
      String? imageUrl =
          await _firebaseStorageHelper.uploadTabBannerImageToStorage(
        imageName,
        imageBytes,
      );

      // Prepare the data to be saved in Firestore.
      Map<String, dynamic> data = {
        "id": subDocRef.id,
        "name": imageName,
        "image": imageUrl,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Save the data into the subcollection document.
      await subDocRef.set(data);
    } catch (e) {
      print("Error uploading banner data: $e");
      rethrow;
    }
  }

  /// Deletes an image document by its [imageId].
  Future<bool> deleteTabBannerImage(ImageModel imageModel) async {
    try {
      await _firestore
          .collection("Image")
          .doc("banner")
          .collection("TabBinnerImage")
          .doc(imageModel.id)
          .delete();
      await _firebaseStorageHelper.deleteImageFromFirebase(imageModel.image!);
      return true;
    } catch (e) {
      print("Error deleting image: $e");
      rethrow;
    }
  }

// ---------- Mobile ----------------------------------
  /// Creates a new image document in the "Image" collection.
  Future<void> uploadMobileBannerData(
      String imageName, Uint8List imageBytes) async {
    try {
      // Use a fixed document ID ("banner") in the "Image" collection.
      DocumentReference<Map<String, dynamic>> parentRef =
          _firestore.collection("Image").doc("banner");

      // Reference the subcollection "WebBinnerImage" under the parent document.
      // This creates a new document with an auto-generated ID in the subcollection.
      DocumentReference<Map<String, dynamic>> subDocRef =
          parentRef.collection("MobileBinnerImage").doc();

      // Upload the image bytes to Firebase Storage using your helper.
      // Assume uploadBannerImageToStorage returns a URL String.
      String? imageUrl =
          await _firebaseStorageHelper.uploadMobileBannerImageToStorage(
        imageName,
        imageBytes,
      );

      // Prepare the data to be saved in Firestore.
      Map<String, dynamic> data = {
        "id": subDocRef.id,
        "name": imageName,
        "image": imageUrl,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Save the data into the subcollection document.
      await subDocRef.set(data);
    } catch (e) {
      print("Error uploading banner data: $e");
      rethrow;
    }
  }

  /// Deletes an image document by its [imageId].
  Future<bool> deleteMobileBannerImage(ImageModel imageModel) async {
    try {
      await _firestore
          .collection("Image")
          .doc("banner")
          .collection("MobileBinnerImage")
          .doc(imageModel.id)
          .delete();
      await _firebaseStorageHelper.deleteImageFromFirebase(imageModel.image!);
      return true;
    } catch (e) {
      print("Error deleting image: $e");
      rethrow;
    }
  }

  //! ---------------------- Footer FUNCTIONS ----------------------

  /// Creates a new footer document.
  Future<bool> createFooter(FooterModel footerModel) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection("footer").doc();
      // Update the footer model with the generated document ID.

      FooterModel newFooter = footerModel.copyWith(id: docRef.id);
      await docRef.set(newFooter.toJson());
      return true;
    } catch (e) {
      print('Error creating footer: $e');
      rethrow;
    }
  }

  Future<FooterModel?> getFirstFooter() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("footer").limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        return FooterModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting first footer: $e');
      rethrow;
    }
  }

  /// Updates an existing footer document.
  Future<bool> updateFooter(FooterModel footerModel) async {
    try {
      await _firestore
          .collection("footer")
          .doc(footerModel.id)
          .update(footerModel.toJson());
      return true;
    } catch (e) {
      print('Error updating footer: $e');
      rethrow;
    }
  }

  /// Deletes a footer document by its [id].
  Future<void> deleteFooter(String id) async {
    try {
      await _firestore.collection("footer").doc(id).delete();
    } catch (e) {
      print('Error deleting footer: $e');
      rethrow;
    }
  }

  //! ---------------------- Enquriy Form FUNCTIONS ----------------------

  Future<List<UserEnquiryModel>> getListUserEnquiryForm(
      BuildContext context) async {
    try {
      DocumentReference<Map<String, dynamic>> formRef =
          _firestore.collection("UserEnquiryForm").doc("form");

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await formRef.collection("UserEnquiryForm").get();

      return snapshot.docs.map((doc) {
        return UserEnquiryModel.fromJson(doc.data());
      }).toList();

      // print('Form submitted successfully.');
      // showBottonMessage('Form submitted successfully', context);
    } catch (e) {
      print('Error : get List Enquiry form: $e');
      showBottonMessageError("Error Get Enquiry form list ", context);
      rethrow;
    }
  }

  Future<void> updateSingleUserEnquiryForm(
      UserEnquiryModel userEnquiryModel, BuildContext context) async {
    try {
      DocumentReference<Map<String, dynamic>> formRef =
          _firestore.collection("UserEnquiryForm").doc("form");

      formRef
          .collection("UserEnquiryForm")
          .doc(userEnquiryModel.id)
          .update(userEnquiryModel.toJson());
      showBottonMessage("Update Successfully", context);
    } catch (e) {
      print("Error : update Form $e");
      showBottonMessageError("Error: update Form", context);
    }
  }

  //! ---------------------- Job FUNCTIONS ----------------------
  /// Creates a new footer document.
  Future<bool> createJob(JobModel jobModel, BuildContext context) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection("Job").doc();

      JobModel _job = jobModel.copyWith(
        id: docRef.id,
      );

      await docRef.set(_job.toJson());
      showBottonMessage("Job Upload successfully", context);
      return true;
    } catch (e) {
      print('Error : Error Uploading Job: $e');
      showBottonMessageError("Error Uploading Job", context);
      rethrow;
    }
  }

  /// Deletes a job document by its [id].
  Future<bool> deleteJob(String jobId, BuildContext context) async {
    try {
      await _firestore.collection("Job").doc(jobId).delete();
      showBottonMessage("Job Deleted successfully", context);
      return true;
    } catch (e) {
      print('Error : Error Deleting Job: $e');
      showBottonMessageError("Error Deleting Job", context);
      rethrow;
    }
  }

  /// Updates an existing job document.
  Future<bool> updateJob(JobModel jobModel, BuildContext context) async {
    try {
      await _firestore
          .collection("Job")
          .doc(jobModel.id)
          .update(jobModel.toJson());
      showBottonMessage("Job Updated successfully", context);
      return true;
    } catch (e) {
      print('Error : Error Updating Job: $e');
      showBottonMessageError("Error Updating Job", context);
      rethrow;
    }
  }

  /// Retrieves a list of all job documents.
  Future<List<JobModel>> getListOfJobs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("Job").get();
      return snapshot.docs.map((doc) => JobModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error : Error Fetching Jobs: $e');
      rethrow;
    }
  }

  //! ---------------------- Service FUNCTIONS ----------------------

  Future<bool> createServiceProvider(ServiceProviderModel serviceProviderModel,
      Uint8List? selectedImage, BuildContext context) async {
    try {
      String? imgUrl = "no Image";
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection("serviceProvider").doc();

      if (selectedImage != null && selectedImage.isNotEmpty) {
        imgUrl = await FirebaseStorageHelper.instance
            .uploadServicePvoviderPicImage(
                serviceProviderModel.eId, selectedImage);
      }

      ServiceProviderModel _serviceProvider = serviceProviderModel.copyWith(
        id: docRef.id,
        image: imgUrl,
      );

      await docRef.set(_serviceProvider.toJson());
      showBottonMessage("Service Provider created successfully", context);
      return true;
    } catch (e) {
      print('Error: Error creating Service Provider: $e');
      showBottonMessageError("Error creating Service Provider", context);
      rethrow;
    }
  }

  Future<bool> updateServiceProvider(
      ServiceProviderModel serviceProviderModel, BuildContext context) async {
    try {
      await _firestore
          .collection("serviceProvider")
          .doc(serviceProviderModel.id)
          .update(serviceProviderModel.toJson());
      showBottonMessage("Service Provider updated successfully", context);
      return true;
    } catch (e) {
      print('Error: Error updating Service Provider: $e');
      showBottonMessageError("Error updating Service Provider", context);
      rethrow;
    }
  }

  Future<bool> deleteServiceProvider(String id, BuildContext context) async {
    try {
      await _firestore.collection("serviceProvider").doc(id).delete();
      showBottonMessage("Service Provider deleted successfully", context);
      return true;
    } catch (e) {
      print('Error: Error deleting Service Provider: $e');
      showBottonMessageError("Error deleting Service Provider", context);
      rethrow;
    }
  }

  //! ---------------------- User FUNCTIONS ----------------------

  Future<List<UserModel>> getUserModelsListFB() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("userData").get();

      // Map each document to a UserModel and return as a list
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting User Information: $e');
      rethrow;
    }
  }
}
