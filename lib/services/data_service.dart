import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/memo.dart';

class DataService {
  static const String _fileName = 'omoidashi_data.json';
  File? _file;
  final Uuid _uuid = const Uuid();

  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final directory = await getApplicationDocumentsDirectory();
    _file ??= File('${directory.path}/$_fileName');

    if (!await _file!.exists()) {
      await _createInitialData();
    }

    _isInitialized = true;
  }

  Future<void> _createInitialData() async {
    final initialData = {
      'memos': <Map<String, dynamic>>[],
    };

    await _file!.writeAsString(jsonEncode(initialData));
  }

  Future<Map<String, dynamic>> _readData() async {
    await _initialize();

    try {
      final contents = await _file!.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    } catch (e) {
      await _createInitialData();
      final contents = await _file!.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    }
  }

  Future<void> _writeData(Map<String, dynamic> data) async {
    await _initialize();
    await _file!.writeAsString(jsonEncode(data));
  }

  Future<List<Memo>> getAllMemos() async {
    final data = await _readData();
    final memosJson = data['memos'] as List<dynamic>? ?? [];
    return memosJson.map((json) => Memo.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Memo> createMemo({
    required String content,
    List<String> tags = const [],
    bool isFavorite = false,
  }) async {
    final now = DateTime.now();
    final memo = Memo(
      id: _uuid.v4(),
      content: content,
      createdAt: now,
      updatedAt: now,
      isFavorite: isFavorite,
      tags: tags,
    );

    final data = await _readData();
    final memos = data['memos'] as List<dynamic>? ?? [];
    memos.add(memo.toJson());
    data['memos'] = memos;

    await _writeData(data);
    return memo;
  }

  Future<Memo> updateMemo(Memo memo) async {
    final updatedMemo = memo.copyWith(updatedAt: DateTime.now());
    final data = await _readData();
    final memos = data['memos'] as List<dynamic>? ?? [];

    final index = memos.indexWhere((m) => m['id'] == memo.id);
    if (index != -1) {
      memos[index] = updatedMemo.toJson();
      data['memos'] = memos;
      await _writeData(data);
    }

    return updatedMemo;
  }

  Future<void> deleteMemo(String id) async {
    final data = await _readData();
    final memos = data['memos'] as List<dynamic>? ?? [];
    memos.removeWhere((m) => m['id'] == id);
    data['memos'] = memos;
    await _writeData(data);
  }

  Future<List<Memo>> searchMemos(String query) async {
    final allMemos = await getAllMemos();
    if (query.isEmpty) return allMemos;

    final lowerQuery = query.toLowerCase();
    return allMemos.where((memo) {
      return memo.content.toLowerCase().contains(lowerQuery) ||
             memo.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<List<Memo>> getFavoriteMemos() async {
    final allMemos = await getAllMemos();
    return allMemos.where((memo) => memo.isFavorite).toList();
  }

  Future<List<Memo>> getRandomMemos({int count = 5}) async {
    final allMemos = await getAllMemos();
    if (allMemos.isEmpty) return [];

    allMemos.shuffle();
    return allMemos.take(count).toList();
  }

  Future<List<String>> getAllTags() async {
    final allMemos = await getAllMemos();
    final allTags = <String>{};
    for (final memo in allMemos) {
      allTags.addAll(memo.tags);
    }
    return allTags.toList()..sort();
  }

  Future<List<Memo>> getMemosByTag(String tag) async {
    final allMemos = await getAllMemos();
    return allMemos.where((memo) => memo.tags.contains(tag)).toList();
  }
}