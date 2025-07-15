import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/data_provider.dart';
import '../models/memo.dart';
import 'create_memo_screen.dart';
import 'memo_detail_screen.dart';

class MemoListScreen extends HookConsumerWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final filteredMemosAsync = ref.watch(filteredMemosProvider);
    final allTagsAsync = ref.watch(allTagsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    useEffect(() {
      searchController.text = searchQuery;
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('すべてのメモ'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(memoListNotifierProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
            tooltip: '更新',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(context, ref, searchController, allTagsAsync, selectedTag),
          Expanded(
            child: _buildMemoList(context, ref, filteredMemosAsync),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateMemoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: '新しいメモを作成',
      ),
    );
  }

  Widget _buildSearchAndFilter(
    BuildContext context,
    WidgetRef ref,
    TextEditingController searchController,
    AsyncValue<List<String>> allTagsAsync,
    String? selectedTag,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'メモを検索...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 12),
          _buildTagFilter(context, ref, allTagsAsync, selectedTag),
        ],
      ),
    );
  }

  Widget _buildTagFilter(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<String>> allTagsAsync,
    String? selectedTag,
  ) {
    return allTagsAsync.when(
      data: (tags) => tags.isEmpty
          ? const SizedBox.shrink()
          : SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip(
                    context,
                    ref,
                    'すべて',
                    selectedTag == null,
                    () => ref.read(selectedTagProvider.notifier).state = null,
                  ),
                  const SizedBox(width: 8),
                  ...tags.map((tag) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      context,
                      ref,
                      tag,
                      selectedTag == tag,
                      () => ref.read(selectedTagProvider.notifier).state = tag,
                    ),
                  )),
                ],
              ),
            ),
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildMemoList(BuildContext context, WidgetRef ref, AsyncValue<List<Memo>> memosAsync) {
    return memosAsync.when(
      data: (memos) {
        if (memos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_add,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'メモがありません',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '新しいメモを作成してみましょう',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(memoListNotifierProvider.notifier).refresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];
              return _buildMemoCard(context, ref, memo);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(memoListNotifierProvider.notifier).refresh();
              },
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoCard(BuildContext context, WidgetRef ref, Memo memo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemoDetailScreen(memo: memo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      memo.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleMenuAction(context, ref, memo, action),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(width: 8),
                            Text('お気に入り切り替え'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('編集'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('削除'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (memo.isFavorite)
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  if (memo.isFavorite) const SizedBox(width: 4),
                  Text(
                    _formatDate(memo.updatedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (memo.tags.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: memo.tags.take(3).map((tag) => Chip(
                          label: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, Memo memo, String action) {
    switch (action) {
      case 'favorite':
        ref.read(memoListNotifierProvider.notifier).updateMemo(
          memo.copyWith(isFavorite: !memo.isFavorite),
        );
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateMemoScreen(memo: memo),
          ),
        );
        break;
      case 'delete':
        _showDeleteDialog(context, ref, memo);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Memo memo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メモを削除'),
        content: const Text('このメモを削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(memoListNotifierProvider.notifier).deleteMemo(memo.id);
              Navigator.pop(context);
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今日 ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨日';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}