import 'dart:developer';

import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/spin_wheel_firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_model.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';

class SpinWheelProvider with ChangeNotifier {
  final SpinWheelFirestoreHelper _spinWheelFirestoreHelper =
      SpinWheelFirestoreHelper.instance;

  // --------------------------------------------------
  // Loading
  // --------------------------------------------------

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --------------------------------------------------
  // Error
  // --------------------------------------------------

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
  }

  // --------------------------------------------------
  // Spin Wheel Model
  // --------------------------------------------------

  SpinWheelModel? _spinWheelModel;

  SpinWheelModel? get spinWheelModel => _spinWheelModel;

  // --------------------------------------------------
  // CREATE SPIN WHEEL
  // --------------------------------------------------

  Future<bool> createSpinWheel() async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.createSpinWheel();

      _spinWheelModel = SpinWheelModel(
        isOfferIsLive: true,
        spinWheelOptionModelList: [],
      );

      log('Provider: Spin wheel created successfully.');

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error creating spin wheel: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // TURN ON
  // --------------------------------------------------

  Future<bool> turnOnSpinWheel() async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.turnOnSpinWheel();

      if (_spinWheelModel != null) {
        _spinWheelModel = _spinWheelModel!.copyWith(
          isOfferIsLive: true,
        );
      } else {
        await loadSpinWheel(showLoading: false);
      }

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error turning ON spin wheel: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // TURN OFF
  // --------------------------------------------------

  Future<bool> turnOffSpinWheel() async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.turnOffSpinWheel();

      if (_spinWheelModel != null) {
        _spinWheelModel = _spinWheelModel!.copyWith(
          isOfferIsLive: false,
        );
      } else {
        await loadSpinWheel(showLoading: false);
      }

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error turning OFF spin wheel: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // LOAD SPIN WHEEL
  // --------------------------------------------------

  Future<SpinWheelModel?> loadSpinWheel({
    bool showLoading = true,
  }) async {
    if (showLoading) {
      _setLoading(true);
    }

    _clearError();

    try {
      final SpinWheelModel? model =
          await _spinWheelFirestoreHelper.getSpinWheel();

      _spinWheelModel = model;

      log(
        'Provider: Spin wheel loaded. '
        'Exists: ${model != null}',
      );

      return model;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error loading spin wheel: $e',
        stackTrace: stackTrace,
      );

      return null;
    } finally {
      if (showLoading) {
        _setLoading(false);
      }
    }
  }

  // --------------------------------------------------
  // ADD OPTION
  // --------------------------------------------------

  Future<bool> addSpinWheelOption(
    SpinWheelOptionModel option,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final SpinWheelOptionModel newOption =
          await _spinWheelFirestoreHelper.addSpinWheelOption(
        option,
      );

      final List<SpinWheelOptionModel> currentList =
          List<SpinWheelOptionModel>.from(
        _spinWheelModel?.spinWheelOptionModelList ?? [],
      );

      currentList.add(newOption);

      if (_spinWheelModel != null) {
        _spinWheelModel = _spinWheelModel!.copyWith(
          spinWheelOptionModelList: currentList,
        );
      }

      log(
        'Provider: Spin wheel option added: ${newOption.id}',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error adding spin wheel option: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // UPDATE OPTION
  // --------------------------------------------------

  Future<bool> updateSpinWheelOption(
    SpinWheelOptionModel option,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.updateSpinWheelOption(
        option,
      );

      final List<SpinWheelOptionModel> currentList =
          List<SpinWheelOptionModel>.from(
        _spinWheelModel?.spinWheelOptionModelList ?? [],
      );

      final int index = currentList.indexWhere(
        (item) => item.id == option.id,
      );

      if (index != -1) {
        currentList[index] = option;

        if (_spinWheelModel != null) {
          _spinWheelModel = _spinWheelModel!.copyWith(
            spinWheelOptionModelList: currentList,
          );
        }
      }

      log(
        'Provider: Spin wheel option updated: ${option.id}',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error updating spin wheel option: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // DELETE OPTION
  // --------------------------------------------------

  Future<bool> deleteSpinWheelOption(
    String optionId,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.deleteSpinWheelOption(
        optionId,
      );

      final List<SpinWheelOptionModel> currentList =
          List<SpinWheelOptionModel>.from(
        _spinWheelModel?.spinWheelOptionModelList ?? [],
      );

      currentList.removeWhere(
        (item) => item.id == optionId,
      );

      if (_spinWheelModel != null) {
        _spinWheelModel = _spinWheelModel!.copyWith(
          spinWheelOptionModelList: currentList,
        );
      }

      log(
        'Provider: Spin wheel option deleted: $optionId',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error deleting spin wheel option: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // CLEAR
  // --------------------------------------------------

  void clearSpinWheel() {
    _spinWheelModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}