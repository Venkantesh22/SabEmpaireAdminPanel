import 'dart:developer';

import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_model.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpinWheelFirestoreHelper {
  static final SpinWheelFirestoreHelper instance =
      SpinWheelFirestoreHelper._internal();

  SpinWheelFirestoreHelper._internal();

  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get docRef =>
      _firebaseFirestore.collection('offer').doc('spinWheel');

  // --------------------------------------------------
  // Create Spin Wheel
  // --------------------------------------------------

  Future<void> createSpinWheel() async {
    try {
      final SpinWheelModel spinWheelModel = SpinWheelModel(
        isOfferIsLive: true,
        spinWheelOptionModelList: [],
      );

      await docRef.set(spinWheelModel.toMap());

      log('Spin wheel created successfully.');
    } on FirebaseException catch (e) {
      log(
        'Firebase error while creating spin wheel: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while creating spin wheel: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // Turn ON
  // --------------------------------------------------

  Future<void> turnOnSpinWheel() async {
    try {
      await docRef.set(
        {
          'isOfferIsLive': true,
        },
        SetOptions(merge: true),
      );

      log('Spin wheel offer is now LIVE.');
    } on FirebaseException catch (e) {
      log(
        'Firebase error while turning ON spin wheel: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while turning ON spin wheel: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // Turn OFF
  // --------------------------------------------------

  Future<void> turnOffSpinWheel() async {
    try {
      await docRef.set(
        {
          'isOfferIsLive': false,
        },
        SetOptions(merge: true),
      );

      log('Spin wheel offer is now OFF.');
    } on FirebaseException catch (e) {
      log(
        'Firebase error while turning OFF spin wheel: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while turning OFF spin wheel: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // Get Spin Wheel
  // --------------------------------------------------

  Future<SpinWheelModel?> getSpinWheel() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await docRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return SpinWheelModel.fromMap(snapshot.data()!);
    } on FirebaseException catch (e) {
      log(
        'Firebase error while fetching spin wheel: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while fetching spin wheel: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // ADD SPIN WHEEL OPTION
  // --------------------------------------------------

  Future<SpinWheelOptionModel> addSpinWheelOption(
    SpinWheelOptionModel option,
  ) async {
    try {
      if (!await _documentExists()) {
        throw Exception(
          'Spin wheel document does not exist. '
          'Create the spin wheel first.',
        );
      }

      final String optionId =
          option.id?.trim().isNotEmpty == true
              ? option.id!.trim()
              : DateTime.now().microsecondsSinceEpoch.toString();

      final SpinWheelOptionModel newOption = option.copyWith(
        id: optionId,
      );

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('Spin wheel document does not exist.');
        }

        final data = snapshot.data() ?? {};

        final List<dynamic> existingList =
            data['spinWheelOptionModelList'] as List<dynamic>? ?? [];

        final List<Map<String, dynamic>> updatedList =
            existingList.map((item) {
          return Map<String, dynamic>.from(
            item as Map,
          );
        }).toList();

        updatedList.add(newOption.toMap());

        transaction.set(
          docRef,
          {
            'spinWheelOptionModelList': updatedList,
          },
          SetOptions(merge: true),
        );
      });

      log('Spin wheel option added: $optionId');

      return newOption;
    } on FirebaseException catch (e) {
      log(
        'Firebase error while adding spin wheel option: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while adding spin wheel option: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // UPDATE SPIN WHEEL OPTION
  // --------------------------------------------------

  Future<void> updateSpinWheelOption(
    SpinWheelOptionModel option,
  ) async {
    try {
      final String? optionId = option.id?.trim();

      if (optionId == null || optionId.isEmpty) {
        throw Exception(
          'Spin wheel option ID is required for update.',
        );
      }

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception(
            'Spin wheel document does not exist.',
          );
        }

        final data = snapshot.data() ?? {};

        final List<dynamic> existingList =
            data['spinWheelOptionModelList'] as List<dynamic>? ?? [];

        final List<Map<String, dynamic>> updatedList =
            existingList.map((item) {
          return Map<String, dynamic>.from(
            item as Map,
          );
        }).toList();

        final int index = updatedList.indexWhere(
          (item) => item['id']?.toString() == optionId,
        );

        if (index == -1) {
          throw Exception(
            'Spin wheel option with ID $optionId was not found.',
          );
        }

        updatedList[index] = option.toMap();

        transaction.set(
          docRef,
          {
            'spinWheelOptionModelList': updatedList,
          },
          SetOptions(merge: true),
        );
      });

      log('Spin wheel option updated: $optionId');
    } on FirebaseException catch (e) {
      log(
        'Firebase error while updating spin wheel option: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while updating spin wheel option: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // DELETE SPIN WHEEL OPTION
  // --------------------------------------------------

  Future<void> deleteSpinWheelOption(
    String optionId,
  ) async {
    try {
      final String id = optionId.trim();

      if (id.isEmpty) {
        throw Exception(
          'Spin wheel option ID is required for delete.',
        );
      }

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception(
            'Spin wheel document does not exist.',
          );
        }

        final data = snapshot.data() ?? {};

        final List<dynamic> existingList =
            data['spinWheelOptionModelList'] as List<dynamic>? ?? [];

        final List<Map<String, dynamic>> updatedList =
            existingList
                .map(
                  (item) => Map<String, dynamic>.from(
                    item as Map,
                  ),
                )
                .where(
                  (item) => item['id']?.toString() != id,
                )
                .toList();

        if (updatedList.length == existingList.length) {
          throw Exception(
            'Spin wheel option with ID $id was not found.',
          );
        }

        transaction.set(
          docRef,
          {
            'spinWheelOptionModelList': updatedList,
          },
          SetOptions(merge: true),
        );
      });

      log('Spin wheel option deleted: $id');
    } on FirebaseException catch (e) {
      log(
        'Firebase error while deleting spin wheel option: '
        '${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      log('Error while deleting spin wheel option: $e');
      rethrow;
    }
  }

  // --------------------------------------------------
  // Check Document Exists
  // --------------------------------------------------

  Future<bool> _documentExists() async {
    final snapshot = await docRef.get();
    return snapshot.exists;
  }
}