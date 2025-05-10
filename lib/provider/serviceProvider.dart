import 'dart:typed_data';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/service_firebase_firestore.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  List<SuperCategoryModel> _superCategoryList = [];
  List<SuperCategoryModel> get getSuperCategoryList => _superCategoryList;

  SuperCategoryModel? _selectSuperCategoryModel;
  SuperCategoryModel? get getSelectSuperCategoryModel =>
      _selectSuperCategoryModel;

  List<CategoryModel> _categoryList = [];
  List<CategoryModel> get getCategoryList => _categoryList;

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

  List<CategoryModel> _categoryThreeList = [];
  List<CategoryModel> get getCategoryThreeList => _categoryThreeList;

  CategoryModel? _selectedThreeCategory;
  CategoryModel? get getSelectedThreeCategory => _selectedThreeCategory;

  List<ServiceModel> _servicesList = [];
  List<ServiceModel> get getserviceList => _servicesList;

  //! ------- Super category fun ----------------

  // Stream to fetch Super Category List
  Stream<List<SuperCategoryModel>> getSuperCategoryListPro() {
    return FirebaseFirestore.instance
        .collection("superCategory")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SuperCategoryModel.fromJson(doc.data()))
            .toList());
  }

  //Function to create new category to List
  Future<void> addNewSuperCategoryPro(
    String superCategoryName,
    int order,
    Uint8List superCateImage,
    BuildContext context,
  ) async {
    SuperCategoryModel superCategoryModel =
        await ServiceFirebaseFirestore.instance.createSuperCategory(
      superCategoryName,
      order,
      superCateImage,
    );

    _superCategoryList.add(superCategoryModel);
    notifyListeners();
  }

  // Update a single Category
  void updateSingleSuperCategoryPro(
    SuperCategoryModel superCategoryModel,
  ) async {
    await ServiceFirebaseFirestore.instance
        .updateSuperCategoryWithoutImage(superCategoryModel);
    var isRemove = _superCategoryList.remove(superCategoryModel);
    if (isRemove) {
      _superCategoryList.add(superCategoryModel);
    }
    notifyListeners();
  }

  void updateSingleSuperCategoryWIthImagePro(
    SuperCategoryModel superCategoryModel,
    Uint8List selectedImage,
  ) async {
    await ServiceFirebaseFirestore.instance
        .updateSuperCategoryWithImage(superCategoryModel, selectedImage);
    var isRemove = _superCategoryList.remove(superCategoryModel);
    if (isRemove) {
      _superCategoryList.add(superCategoryModel);
    }
    notifyListeners();
  }

  //Delete singleCategory
  Future<void> deleteSingleSuperCategoryPro(
      SuperCategoryModel supercateoryModel) async {
    bool val = await ServiceFirebaseFirestore.instance
        .deleteSuperCategory(supercateoryModel);
    if (val) {
      _superCategoryList.remove(supercateoryModel);
    }
    notifyListeners();
  }

  void selectSuperCatePro(SuperCategoryModel value) {
    _selectSuperCategoryModel = value;
  }

  //! -------  category fun ----------------

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  //Function to fatch CategoryList
  Future<void> getCategoryListPro() async {
    _categoryList = await ServiceFirebaseFirestore.instance
        .getCategoryListFirebase(getSelectSuperCategoryModel!.id);
    notifyListeners();
  }

  //Function to create new category to List
  void addNewCategoryPro(
    String categoryName,
    int order,
    SuperCategoryModel superCategoryModel,
    BuildContext context,
  ) async {
    CategoryModel categoryModel = await ServiceFirebaseFirestore.instance
        .createCategory(categoryName, order, superCategoryModel);
    _categoryList.add(categoryModel);
    notifyListeners();
  }

  // Update a single Category
  void updateSingleCategoryPro(CategoryModel categoryModel) async {
    await ServiceFirebaseFirestore.instance
        .updateCategory(categoryModel, _selectSuperCategoryModel!.id);

    var isRemove = _categoryList.remove(categoryModel);
    if (isRemove) {
      _categoryList.add(categoryModel);
    }
    notifyListeners();
  }

  //Delete singleCategory
  Future<void> deleteSingleCategoryPro(CategoryModel categoryModel) async {
    bool val = await ServiceFirebaseFirestore.instance
        .deleteCategory(_selectSuperCategoryModel!.id, categoryModel.id);
    if (val) {
      _categoryList.remove(categoryModel);
    }
    notifyListeners();
  }

  //! -------  Service fun pro ----------------

  //Function to fatch services
  Stream<List<ServiceModel>> getServicesListFirebase(
    String superCategoryId,
    String categoryId,
  ) {
    return FirebaseFirestore.instance
        .collection("superCategory")
        .doc(superCategoryId)
        .collection("category")
        .doc(categoryId)
        .collection("services")
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => ServiceModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> addSingleServicePro(
    String categoryid,
    String categoryName,
    String servicesName,
    double price,
    int hours,
    int min,
    int order,
    String description,
  ) async {
    int _serviceDurationMin = 0;
    Duration _serviceDurMin = Duration(hours: hours, minutes: min);
    ServiceModel serviceModel =
        await ServiceFirebaseFirestore.instance.createService(
      categoryName,
      categoryid,
      _selectSuperCategoryModel!,
      servicesName,
      price,
      _serviceDurMin.inMinutes,
      order,
      description,
    );

    notifyListeners();
  }

  //Delete singleCategory
  Future<void> deletelSingleServicePro(
    ServiceModel serviceModel,
    String categoryId,
  ) async {
    bool val = await ServiceFirebaseFirestore.instance.deleteService(
        _selectSuperCategoryModel!.id, categoryId, serviceModel.id);
    if (val) {
      _servicesList.remove(serviceModel);
    }
    notifyListeners();
  }

  // Update a single Category
  void updateSingleServicePro(
    ServiceModel serviceModel,
    String categoryId,
  ) async {
    await ServiceFirebaseFirestore.instance.updateService(
      serviceModel,
      _selectSuperCategoryModel!.id,
      categoryId,
    );

    // .updateCategory(categoryModel, _selectSuperCategoryModel!.id);

    var isRemove = _categoryList.remove(serviceModel);
    if (isRemove) {
      _servicesList.add(serviceModel);
    }
    notifyListeners();
  }

  Future<void> callBackFunction() async {
    await getSuperCategoryListPro();
    await getCategoryListPro();
    getServicesListFirebase;
    notifyListeners();
  }
}
