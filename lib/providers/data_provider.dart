import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/data_service.dart';
import '../models/memo.dart';

final dataServiceProvider = Provider<DataService>((ref) {
  return DataService();
});

final memosProvider = FutureProvider<List<Memo>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getAllMemos();
});

final allTagsProvider = FutureProvider<List<String>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getAllTags();
});

final memoListNotifierProvider = StateNotifierProvider<MemoListNotifier, AsyncValue<List<Memo>>>((ref) {
  return MemoListNotifier(ref.read(dataServiceProvider));
});

class MemoListNotifier extends StateNotifier<AsyncValue<List<Memo>>> {
  final DataService _dataService;

  MemoListNotifier(this._dataService) : super(const AsyncValue.loading()) {
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    try {
      final memos = await _dataService.getAllMemos();
      state = AsyncValue.data(memos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createMemo({
    required String content,
    List<String> tags = const [],
    bool isFavorite = false,
  }) async {
    try {
      await _dataService.createMemo(
        content: content,
        tags: tags,
        isFavorite: isFavorite,
      );
      await _loadMemos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateMemo(Memo memo) async {
    try {
      await _dataService.updateMemo(memo);
      await _loadMemos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteMemo(String id) async {
    try {
      await _dataService.deleteMemo(id);
      await _loadMemos();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadMemos();
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedTagProvider = StateProvider<String?>((ref) => null);

final filteredMemosProvider = Provider<AsyncValue<List<Memo>>>((ref) {
  final memosAsync = ref.watch(memoListNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedTag = ref.watch(selectedTagProvider);

  return memosAsync.when(
    data: (memos) {
      var filteredMemos = memos;

      if (searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        filteredMemos = filteredMemos.where((memo) {
          return memo.content.toLowerCase().contains(lowerQuery) ||
                 memo.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        }).toList();
      }

      if (selectedTag != null) {
        filteredMemos = filteredMemos.where((memo) => memo.tags.contains(selectedTag)).toList();
      }

      filteredMemos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return AsyncValue.data(filteredMemos);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final favoriteMemosProvider = Provider<AsyncValue<List<Memo>>>((ref) {
  final memosAsync = ref.watch(memoListNotifierProvider);
  
  return memosAsync.when(
    data: (memos) {
      final favoriteMemos = memos.where((memo) => memo.isFavorite).toList();
      favoriteMemos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return AsyncValue.data(favoriteMemos);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final randomMemosProvider = FutureProvider<List<Memo>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getRandomMemos(count: 5);
});