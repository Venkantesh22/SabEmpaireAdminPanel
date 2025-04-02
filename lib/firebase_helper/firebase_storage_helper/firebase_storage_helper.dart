// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadAdminProfileImageToStorage(
      String imageName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage.ref("Admin_profile_img/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<String?> uploadBannerImageToStorage(
      String imageName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage.ref("Banner/WebBanner/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<String?> uploadMobileBannerImageToStorage(
      String imageName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage.ref("Banner/MobileBanner/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<String?> uploadTabBannerImageToStorage(
      String imageName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage.ref("Banner/TabBanner/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  //! -------------------- Super category IMAGE FUNCTIONS --------------------
  //!Save Super category images
  Future<String?> uploadSuperCateImage(
      String imageName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage.ref("Service/SuperCate/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading Super category image: ${e.toString()}");
      print("Error uploading Super category image: $e");
      return null;
    }
  }

  // update admin Profile Image
  Future<String?> updateSuperCateImage(Uint8List newImagePath,
      String oldImageUrl, SuperCategoryModel superCateModel) async {
    // First, delete the old image if it exists
    if (oldImageUrl.isNotEmpty) {
      await deleteImageFromFirebase(oldImageUrl);
    }

    // Then upload the new image
    // String imageUrl =
    //     await uploadUserImage(newImagePath, userModel.id, userModel.name);
    String? imageUrl = await uploadSuperCateImage(
      superCateModel.superCategoryName,
      newImagePath,
    );

    return imageUrl;
  }

  //delete image from firebase\
  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      // Create a reference to the file to delete
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the file
      await storageRef.delete();

      print("Image deleted successfully");
    } catch (e) {
      print("Error occurred while deleting the image: $e");
    }
  }

  //! -------------------- Service Provider IMAGE FUNCTIONS --------------------

  //!Save Service Provider images
  Future<String?> uploadServicePvoviderPicImage(
      String imageName, Uint8List? selectedImage) async {
    try {
      Reference imageRef = _storage.ref("SericeProvider/Pic/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage!, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading SericeProvider image: ${e.toString()}");
      print("Error uploading SericeProvider image: $e");
      return null;
    }
  }

  // update admin Profile Image
  Future<String?> updateServicePvoviderPicImage(
      Uint8List newImagePath, String oldImageUrl, String name) async {
    // First, delete the old image if it exists
    if (oldImageUrl.isNotEmpty) {
      await deleteImageFromFirebase(oldImageUrl);
    }

    // Then upload the new image
    // String imageUrl =
    //     await uploadUserImage(newImagePath, userModel.id, userModel.name);
    String? imageUrl = await uploadServicePvoviderPicImage(
      name,
      newImagePath,
    );

    return imageUrl;
  }
}
