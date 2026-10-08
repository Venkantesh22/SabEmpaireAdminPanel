import 'dart:developer';

import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/spin_wheel_firebase_helper.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_model.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';
import 'package:admin_panel_ak/models/service_model/spin_wheel_winner_model/spin_wheel_winner_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SpinWheelProvider with ChangeNotifier {
  final SpinWheelFirestoreHelper _spinWheelFirestoreHelper =
      SpinWheelFirestoreHelper.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

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
  // Spin & Bling Model
  // --------------------------------------------------

  SpinWheelModel? _spinWheelModel;

  SpinWheelModel? get spinWheelModel => _spinWheelModel;

  // --------------------------------------------------
  // CREATE Spin & Bling
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

      log('Provider: Spin & Bling created successfully.');

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error creating Spin & Bling: $e',
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
        await loadSpinWheel(
          showLoading: false,
        );
      }

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error turning ON Spin & Bling: $e',
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
        await loadSpinWheel(
          showLoading: false,
        );
      }

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error turning OFF Spin & Bling: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // LOAD Spin & Bling
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
        'Provider: Spin & Bling loaded. '
        'Exists: ${model != null}',
      );

      return model;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error loading Spin & Bling: $e',
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
        'Provider: Spin & Bling option added: ${newOption.id}',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error adding Spin & Bling option: $e',
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
        'Provider: Spin & Bling option updated: ${option.id}',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error updating Spin & Bling option: $e',
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
        'Provider: Spin & Bling option deleted: $optionId',
      );

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error deleting Spin & Bling option: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // UPDATE CODE
  // --------------------------------------------------

  Future<bool> updateSpinWheelCode(
    String code,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _spinWheelFirestoreHelper.updateSpinWheelCode(
        code,
      );

      if (_spinWheelModel != null) {
        _spinWheelModel = _spinWheelModel!.copyWith(
          code: code,
        );
      }

      log('Provider: Spin & Bling code updated.');

      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      log(
        'Provider: Error updating Spin & Bling code: $e',
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --------------------------------------------------
  // WINNERS
  // --------------------------------------------------

  List<SpinWheelWinnerModel> _spinWheelWinnerList = [];

  bool _isWinnerLoading = false;

  String? _winnerErrorMessage;

  List<SpinWheelWinnerModel> get spinWheelWinnerList =>
      List.unmodifiable(
        _spinWheelWinnerList,
      );

  bool get isWinnerLoading =>
      _isWinnerLoading;

  String? get winnerErrorMessage =>
      _winnerErrorMessage;

  void _setWinnerLoading(bool value) {
    _isWinnerLoading = value;
    notifyListeners();
  }

  void _clearWinnerError() {
    _winnerErrorMessage = null;
  }

  // --------------------------------------------------
  // LOAD WINNERS + USER DATA
  // --------------------------------------------------

  Future<void> loadSpinWheelWinners() async {
    _setWinnerLoading(true);
    _clearWinnerError();

    try {
      final QuerySnapshot<Map<String, dynamic>>
          snapshot =
          await _firestore
              .collectionGroup(
                'spinWheelRewards',
              )
              .get();

      // Cache users so that if one user has multiple
      // winning records, we don't fetch the same
      // user document repeatedly.
      final Map<String, UserModel> userCache = {};

      final List<SpinWheelWinnerModel>
          loadedWinners = [];

      for (final DocumentSnapshot<
          Map<String, dynamic>> document
          in snapshot.docs) {
        final SpinWheelWinnerModel winner =
            SpinWheelWinnerModel.fromFirestore(
          document,
        );

        final DocumentReference<
                Map<String, dynamic>>?
            userReference =
            document.reference.parent.parent;

        UserModel? userModel;

        if (userReference != null) {
          final String userId =
              userReference.id;

          // Check cache first.
          if (userCache.containsKey(userId)) {
            userModel = userCache[userId];
          } else {
            try {
              final DocumentSnapshot<
                      Map<String, dynamic>>
                  userSnapshot =
                  await userReference.get();

              if (userSnapshot.exists) {
                final Map<String, dynamic>
                    userData = {
                  ...(userSnapshot.data() ??
                      <String, dynamic>{}),
                  'id': userSnapshot.id,
                };

                userModel =
                    UserModel.fromJson(
                  userData,
                );

                userCache[userId] =
                    userModel;
              }
            } catch (e, stackTrace) {
              log(
                'Failed to fetch user $userId',
                error: e,
                stackTrace: stackTrace,
              );
            }
          }
        }

        loadedWinners.add(
          winner.copyWith(
            user: userModel,
          ),
        );
      }

      // Latest winner first.
      loadedWinners.sort(
        (a, b) => b.dateOfCreate.compareTo(
          a.dateOfCreate,
        ),
      );

      _spinWheelWinnerList
        ..clear()
        ..addAll(
          loadedWinners,
        );
    } catch (e, stackTrace) {
      _winnerErrorMessage =
          e.toString();

      log(
        'loadSpinWheelWinners error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _setWinnerLoading(false);
    }
  }

  // --------------------------------------------------
  // CLEAR
  // --------------------------------------------------

  void clearSpinWheel() {
    _spinWheelModel = null;
    _errorMessage = null;

    _spinWheelWinnerList.clear();
    _winnerErrorMessage = null;

    notifyListeners();
  }
}