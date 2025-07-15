import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'プライバシーポリシー',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '最終更新日: 2025年7月15日',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. 基本方針',
              'オモイダシ（以下「本アプリ」といいます。）では、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシーは、本アプリにおける個人情報の取扱いについて説明するものです。',
            ),
            _buildSection(
              context,
              '2. 収集する情報',
              '本アプリでは、以下の情報を収集する場合があります。\n\n'
              '■ ユーザーが作成したメモ・タグ情報\n'
              '• ユーザーが本アプリに入力したメモの内容\n'
              '• ユーザーが設定したタグ情報\n'
              '• メモの作成日時・更新日時\n'
              '• お気に入り設定情報\n\n'
              '■ 使用状況情報\n'
              '• アプリの使用状況（クラッシュレポート等）\n'
              '• デバイス情報（OS、バージョン等）',
            ),
            _buildSection(
              context,
              '3. 情報の保存場所',
              'ユーザーが作成したメモ・タグ情報は、すべてユーザーのデバイス内にローカル保存されます。これらの情報は、外部サーバーに送信されることはありません。',
            ),
            _buildSection(
              context,
              '4. 情報の利用目的',
              '収集した情報は、以下の目的で利用します。\n\n'
              '• 本アプリの機能提供\n'
              '• アプリの改善・最適化\n'
              '• 技術的な問題の解決\n'
              '• ユーザーサポートの提供',
            ),
            _buildSection(
              context,
              '5. 第三者への提供',
              '当社は、以下の場合を除き、ユーザーの同意なく個人情報を第三者に提供することはありません。\n\n'
              '• 法令に基づく場合\n'
              '• 人の生命、身体または財産の保護のために必要がある場合\n'
              '• 公衆衛生の向上または児童の健全な育成の推進のために特に必要がある場合',
            ),
            _buildSection(
              context,
              '6. 広告について',
              '本アプリでは、第三者配信の広告サービスを利用する場合があります。これらの広告配信事業者は、ユーザーの興味に応じた広告を表示するために、当該ユーザーの本アプリへのアクセスに関する情報を使用することがあります。',
            ),
            _buildSection(
              context,
              '7. データの削除',
              'ユーザーは、本アプリをアンインストールすることで、デバイス内に保存されたすべてのデータを削除することができます。',
            ),
            _buildSection(
              context,
              '8. セキュリティ',
              '当社は、個人情報の漏洩、滅失またはき損の防止その他個人情報の安全管理のために、適切な技術的・組織的安全管理措置を講じます。',
            ),
            _buildSection(
              context,
              '9. 子どもの個人情報',
              '本アプリは、13歳未満の子どもから意図的に個人情報を収集することはありません。',
            ),
            _buildSection(
              context,
              '10. プライバシーポリシーの変更',
              '当社は、本プライバシーポリシーを必要に応じて変更することがあります。変更後のプライバシーポリシーは、本アプリ内で通知した時点から効力を生じるものとします。',
            ),
            _buildSection(
              context,
              '11. お問い合わせ',
              '本プライバシーポリシーに関するお問い合わせは、以下の連絡先までお願いいたします。\n\n'
              'メール: support@omoidashi.app',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '以上',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}