import 'dart:developer';

import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpinWheelFirestoreHelper {
  static final SpinWheelFirestoreHelper instance =
      SpinWheelFirestoreHelper._internal();

  SpinWheelFirestoreHelper._internal();

  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get docRef =>
      _firebaseFirestore.collection('offer').doc('spinWheel');

  /// Create Spin Wheel offer.
  /// By default the offer will be LIVE.
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

  /// Turn ON the Spin Wheel offer.
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

  /// Turn OFF / close the Spin Wheel offer.
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

  /// Get the Spin Wheel document.
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
}                   