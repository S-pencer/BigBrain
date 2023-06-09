// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  static const maxHighestScoresPerPlayer = 10;

  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;

  String pet = 'egg';

  /// Creates an instance of [PlayerProgress] backed by an injected
  /// persistence [store].
  PlayerProgress(PlayerProgressPersistence store) : _store = store;

  /// The highest level that the player has reached so far.
  int get highestLevelReached => _highestLevelReached;

  /// Fetches the latest data from the backing persistence store.
  Future<void> getLatestFromStore() async {
    final level = await _store.getHighestLevelReached();
    final name = await _store.getPet();
    pet = name;
    if (level > _highestLevelReached) {
      _highestLevelReached = level;

      notifyListeners();
    } else if (level < _highestLevelReached) {
      await _store.saveHighestLevelReached(_highestLevelReached);
    }
  }

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() {
    _highestLevelReached = 0;
    pet = 'egg';
    notifyListeners();
    _store.saveHighestLevelReached(_highestLevelReached);
    _store.savePet(pet);
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      var list = ['green', 'slime', 'fish', 'jigglypuff', 'bird'];
      var name = list[Random().nextInt(list.length)];
      _highestLevelReached = level;
      pet = name;
      print(pet);
      notifyListeners();

      unawaited(_store.saveHighestLevelReached(level));
      unawaited(_store.savePet(pet));
    }
  }
}
