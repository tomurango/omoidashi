import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/data_provider.dart';
import '../models/memo.dart';

class CreateMemoScreen extends HookConsumerWidget {
  final Memo? memo;

  const CreateMemoScreen({super.key, this.memo});

  bool get isEditing => memo != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentController = useTextEditingController(text: memo?.content ?? '');
    final tagController = useTextEditingController();
    final allTagsAsync = ref.watch(allTagsProvider);
    final isFavorite = useState<bool>(memo?.isFavorite ?? false);
    final tags = useState<List<String>>(memo?.tags ?? []);
    final isLoading = useState<bool>(false);
    final canSave = useState<bool>(memo?.content.trim().isNotEmpty ?? false);

    useEffect(() {
      void listener() {
        canSave.value = contentController.text.trim().isNotEmpty;
      }
      contentController.addListener(listener);
      return () => contentController.removeListener(listener);
    }, [contentController]);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'メモを編集' : '新しいメモ'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: allTagsAsync.when(
        data: (availableTags) => _buildForm(
          context,
          ref,
          contentController,
          tagController,
          availableTags,
          isFavorite,
          tags,
          isLoading,
          canSave,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラー: $error'),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController contentController,
    TextEditingController tagController,
    List<String> availableTags,
    ValueNotifier<bool> isFavorite,
    ValueNotifier<List<String>> tags,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> canSave,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentField(context, contentController),
          const SizedBox(height: 24),
          _buildTagsSection(context, tagController, tags, availableTags),
          const SizedBox(height: 24),
          _buildFavoriteToggle(context, isFavorite),
          const SizedBox(height: 32),
          if (isLoading.value)
            const Center(child: CircularProgressIndicator())
          else
            _buildSaveButton(context, ref, contentController, tags, isFavorite, isLoading, canSave),
        ],
      ),
    );
  }

  Widget _buildContentField(BuildContext context, TextEditingController contentController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'メモ内容',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: contentController,
          maxLines: null,
          minLines: 5,
          decoration: InputDecoration(
            hintText: '大切な考えやアイデアを書いてください...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildTagsSection(
    BuildContext context,
    TextEditingController tagController,
    ValueNotifier<List<String>> tags,
    List<String> availableTags,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タグ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: tagController,
                decoration: InputDecoration(
                  hintText: 'タグを入力',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                onSubmitted: (value) => _addTag(tagController, tags, value),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _addTag(tagController, tags, tagController.text),
              child: const Text('追加'),
            ),
          ],
        ),
        if (tags.value.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: tags.value.map((tag) => Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _removeTag(tags, tag),
            )).toList(),
          ),
        ],
        if (availableTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '既存のタグ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: availableTags.where((tag) => !tags.value.contains(tag)).map((tag) => 
              ActionChip(
                label: Text(tag),
                onPressed: () => _addTag(tagController, tags, tag),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              )
            ).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteToggle(BuildContext context, ValueNotifier<bool> isFavorite) {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: isFavorite.value 
              ? Theme.of(context).colorScheme.error 
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          'お気に入り',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Switch(
          value: isFavorite.value,
          onChanged: (value) => isFavorite.value = value,
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    WidgetRef ref,
    TextEditingController contentController,
    ValueNotifier<List<String>> tags,
    ValueNotifier<bool> isFavorite,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> canSave,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSave.value ? () => _saveMemo(
          context,
          ref,
          contentController.text,
          tags.value,
          isFavorite.value,
          isLoading,
        ) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isEditing ? 'メモを更新' : 'メモを保存',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _addTag(TextEditingController controller, ValueNotifier<List<String>> tags, String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !tags.value.contains(trimmedTag)) {
      tags.value = [...tags.value, trimmedTag];
      controller.clear();
    }
  }

  void _removeTag(ValueNotifier<List<String>> tags, String tag) {
    tags.value = tags.value.where((t) => t != tag).toList();
  }

  void _saveMemo(
    BuildContext context,
    WidgetRef ref,
    String content,
    List<String> tags,
    bool isFavorite,
    ValueNotifier<bool> isLoading,
  ) async {
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メモ内容を入力してください')),
      );
      return;
    }

    isLoading.value = true;

    try {
      final memoNotifier = ref.read(memoListNotifierProvider.notifier);

      if (isEditing && memo != null) {
        final updatedMemo = memo!.copyWith(
          content: content.trim(),
          tags: tags,
          isFavorite: isFavorite,
        );
        await memoNotifier.updateMemo(updatedMemo);
      } else {
        await memoNotifier.createMemo(
          content: content.trim(),
          tags: tags,
          isFavorite: isFavorite,
        );
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'メモを更新しました' : 'メモを保存しました'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $error')),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}