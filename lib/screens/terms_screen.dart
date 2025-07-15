import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
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
              'オモイダシ利用規約',
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
              '第1条（適用）',
              'この利用規約（以下「本規約」といいます。）は、オモイダシ（以下「本サービス」といいます。）の利用条件を定めるものです。ユーザーの皆さま（以下「ユーザー」といいます。）には、本規約に従って、本サービスをご利用いただきます。',
            ),
            _buildSection(
              context,
              '第2条（利用登録）',
              '本サービスにおいては、利用登録は不要です。本アプリケーションをダウンロードし、起動することで、本サービスをご利用いただけます。',
            ),
            _buildSection(
              context,
              '第3条（禁止事項）',
              'ユーザーは、本サービスの利用にあたり、以下の行為をしてはなりません。\n\n'
              '1. 法令または公序良俗に違反する行為\n'
              '2. 犯罪行為に関連する行為\n'
              '3. 本サービスの内容等、本サービスに含まれる著作権、商標権ほか知的財産権を侵害する行為\n'
              '4. 本サービスのサーバーやネットワークシステムに支障を与える行為\n'
              '5. 本サービスの運営を妨害するおそれのある行為\n'
              '6. 不正アクセスをし、またはこれを試みる行為\n'
              '7. その他、当社が不適切と判断する行為',
            ),
            _buildSection(
              context,
              '第4条（本サービスの提供の停止等）',
              '当社は、以下のいずれかの事由があると判断した場合、ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。\n\n'
              '1. 本サービスにかかるコンピュータシステムの保守点検または更新を行う場合\n'
              '2. 地震、落雷、火災、停電または天災などの不可抗力により、本サービスの提供が困難となった場合\n'
              '3. コンピュータまたは通信回線等が事故により停止した場合\n'
              '4. その他、当社が本サービスの提供が困難と判断した場合',
            ),
            _buildSection(
              context,
              '第5条（著作権）',
              'ユーザーが本サービスに投稿したコンテンツ（メモ、タグ等）の著作権は、当該ユーザーに帰属します。ただし、本サービスの機能提供のために必要な範囲で、当社は当該コンテンツを利用できるものとします。',
            ),
            _buildSection(
              context,
              '第6条（免責事項）',
              '当社は、本サービスに関して、明示または黙示を問わず、完全性、正確性、確実性、有用性等、いかなる保証もいたしません。\n\n'
              '当社は、本サービスに起因してユーザーに生じたあらゆる損害について、一切の責任を負いません。',
            ),
            _buildSection(
              context,
              '第7条（サービス内容の変更等）',
              '当社は、ユーザーに通知することなく、本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし、これによってユーザーに生じた損害について一切の責任を負いません。',
            ),
            _buildSection(
              context,
              '第8条（利用規約の変更）',
              '当社は、必要と判断した場合には、ユーザーに通知することなくいつでも本規約を変更することができるものとします。なお、本規約の変更後、本サービスの利用を開始した場合には、当該ユーザーは変更後の規約に同意したものとみなします。',
            ),
            _buildSection(
              context,
              '第9条（準拠法・裁判管轄）',
              '本規約の解釈にあたっては、日本法を準拠法とします。\n\n'
              '本サービスに関して紛争が生じた場合には、東京地方裁判所を専属的合意管轄とします。',
            ),
            _buildSection(
              context,
              '第10条（お問い合わせ）',
              '本サービスに関するお問い合わせは、以下の連絡先までお願いいたします。\n\n'
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