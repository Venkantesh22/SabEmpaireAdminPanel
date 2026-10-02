import 'dart:developer';

import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/spin_wheel_firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_model.dart';

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
  // Create Spin Wheel
  // --------------------------------------------------

  Future<bool> createSpinWheel() async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.createSpinWheel();

      // Keep local provider data updated.
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
  // Turn ON Spin Wheel
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
        // In case model was not loaded before.
        await loadSpinWheel(
          showLoading: false,
        );
      }

      log('Provider: Spin wheel turned ON.');

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
  // Turn OFF Spin Wheel
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
        await loadSpinWheel(
          showLoading: false,
        );
      }

      log('Provider: Spin wheel turned OFF.');

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
  // Get / Load Spin Wheel
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
  // Clear Provider Data
  // --------------------------------------------------

  void clearSpinWheel() {
    _spinWheelModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}