import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/memo.dart';
import '../providers/data_provider.dart';
import 'create_memo_screen.dart';

class MemoDetailScreen extends HookConsumerWidget {
  final Memo memo;

  const MemoDetailScreen({super.key, required this.memo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(memoListNotifierProvider);
    final currentMemo = useState<Memo>(memo);
    
    useEffect(() {
      memosAsync.whenData((memos) {
        final updatedMemo = memos.firstWhere(
          (m) => m.id == memo.id,
          orElse: () => memo,
        );
        currentMemo.value = updatedMemo;
      });
      return null;
    }, [memosAsync]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ詳細'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentSection(context, currentMemo.value),
                  if (currentMemo.value.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildTagsSection(context, currentMemo.value),
                  ],
                  const SizedBox(height: 24),
                  _buildMetadataSection(context, currentMemo.value),
                ],
              ),
            ),
          ),
          _buildActionBar(context, ref, currentMemo.value),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, Memo memo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          memo.content,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            height: 1.6,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection(BuildContext context, Memo memo) {
    return Row(
      children: [
        if (memo.isFavorite) ...[
          Icon(
            Icons.favorite,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '更新: ${_formatDateTime(memo.updatedAt)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }


  Widget _buildTagsSection(BuildContext context, Memo memo) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: memo.tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '#$tag',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildActionBar(BuildContext context, WidgetRef ref, Memo memo) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolbarAction(
            context,
            icon: Icons.edit_outlined,
            label: '編集',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateMemoScreen(memo: memo),
                ),
              );
            },
          ),
          _buildToolbarAction(
            context,
            icon: memo.isFavorite ? Icons.favorite : Icons.favorite_border,
            label: memo.isFavorite ? 'お気に入り' : 'お気に入り',
            onPressed: () => _toggleFavorite(context, ref, memo),
            iconColor: memo.isFavorite ? Theme.of(context).colorScheme.error : null,
          ),
          _buildToolbarAction(
            context,
            icon: Icons.delete_outline,
            label: '削除',
            onPressed: () => _showDeleteDialog(context, ref, memo),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(BuildContext context, WidgetRef ref, Memo memo) {
    final updatedMemo = memo.copyWith(isFavorite: !memo.isFavorite);
    ref.read(memoListNotifierProvider.notifier).updateMemo(updatedMemo);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updatedMemo.isFavorite 
              ? 'お気に入りに追加しました' 
              : 'お気に入りから削除しました',
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Memo memo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メモを削除'),
        content: const Text('このメモを削除しますか？この操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(memoListNotifierProvider.notifier).deleteMemo(memo.id);
              Navigator.pop(context); // ダイアログを閉じる
              Navigator.pop(context); // 詳細画面を閉じる
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('メモを削除しました')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '今日 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨日 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

}