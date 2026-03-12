import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/shared_cassette_model.dart';
import '../../domain/services/cassette_share_service.dart';

// State for shared cassette
class SharedCassetteState {
  final bool isLoading;
  final SharedCassetteModel? cassette;
  final String? errorMessage;
  final CassetteValidationResult? validationResult;
  final bool isUnlocked;
  final int failedAttempts;

  SharedCassetteState({
    this.isLoading = false,
    this.cassette,
    this.errorMessage,
    this.validationResult,
    this.isUnlocked = false,
    this.failedAttempts = 0,
  });

  SharedCassetteState copyWith({
    bool? isLoading,
    SharedCassetteModel? cassette,
    String? errorMessage,
    CassetteValidationResult? validationResult,
    bool? isUnlocked,
    int? failedAttempts,
  }) {
    return SharedCassetteState(
      isLoading: isLoading ?? this.isLoading,
      cassette: cassette ?? this.cassette,
      errorMessage: errorMessage ?? this.errorMessage,
      validationResult: validationResult ?? this.validationResult,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }
}

// Notifier for managing shared cassette state
class SharedCassetteNotifier extends StateNotifier<SharedCassetteState> {
  final CassetteShareService _shareService;

  SharedCassetteNotifier(this._shareService) : super(SharedCassetteState());

  // Load cassette by share code
  Future<void> loadCassette(String shareCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final cassette = await _shareService.getCassetteByShareCode(shareCode);

      if (cassette == null) {
        state = state.copyWith(
          isLoading: false,
          validationResult: CassetteValidationResult.notFound,
          errorMessage: 'Cassette not found',
        );
        return;
      }

      // Validate cassette
      final validationResult = _shareService.validateCassette(cassette);

      state = state.copyWith(
        isLoading: false,
        cassette: cassette,
        validationResult: validationResult,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load cassette: ${e.toString()}',
      );
    }
  }

  // Unlock cassette with password
  Future<bool> unlockCassette(String password) async {
    if (state.cassette == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final unlockedData = await _shareService.unlockCassetteWithPassword(
        state.cassette!.shareCode,
        password,
      );

      if (unlockedData != null) {
        // Update cassette with unlocked data
        final updatedCassette = state.cassette!.copyWith(
          letterText: unlockedData['letterText'] ?? '',
          youtubeVideoId:
              unlockedData['youtubeEmbedUrl'] ?? state.cassette!.youtubeVideoId,
        );

        state = state.copyWith(
          isLoading: false,
          isUnlocked: true,
          failedAttempts: 0,
          cassette: updatedCassette,
        );
        return true;
      } else {
        final newFailedAttempts = state.failedAttempts + 1;
        state = state.copyWith(
          isLoading: false,
          failedAttempts: newFailedAttempts,
          errorMessage: 'Incorrect password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to unlock cassette: ${e.toString()}',
      );
      return false;
    }
  }

  // Save cassette to library (requires auth)
  Future<bool> saveCassette(String userId) async {
    if (state.cassette == null) return false;

    try {
      final success = await _shareService.saveCassetteToLibrary(
        state.cassette!.id,
        userId,
      );
      return success;
    } catch (e) {
      return false;
    }
  }

  // Reset state
  void reset() {
    state = SharedCassetteState();
  }
}

// Provider for shared cassette state
final sharedCassetteProvider =
    StateNotifierProvider<SharedCassetteNotifier, SharedCassetteState>((ref) {
  final shareService = ref.watch(cassetteShareServiceProvider);
  return SharedCassetteNotifier(shareService);
});
