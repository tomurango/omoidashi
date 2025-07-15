import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 静的にアプリ情報を定義
  static const String _appName = 'オモイダシ';
  static const String _version = '1.0.0';
  static const String _buildNumber = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildAppInfoSection(context),
          const Divider(),
          _buildLegalSection(context),
          const Divider(),
          _buildSupportSection(context),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'アプリ情報',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('アプリ名'),
          subtitle: const Text(_appName),
        ),
        ListTile(
          leading: const Icon(Icons.tag),
          title: const Text('バージョン'),
          subtitle: const Text('$_version ($_buildNumber)'),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '法的情報',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('利用規約'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('プライバシーポリシー'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacyScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'サポート',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('お問い合わせ'),
          subtitle: const Text('ご質問・ご要望はこちらから'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _launchEmail(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('アプリを評価'),
          subtitle: const Text('App Store/Google Playで評価'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _launchAppStore(context);
          },
        ),
      ],
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@omoidashi.app',
      query: 'subject=オモイダシ - お問い合わせ&body=',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('メールアプリを開くことができませんでした'),
          ),
        );
      }
    }
  }

  Future<void> _launchAppStore(BuildContext context) async {
    // TODO: 実際のApp Store/Google PlayのURLに変更する
    const String appStoreUrl = 'https://apps.apple.com/app/omoidashi';
    const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.omoidashi_app';
    
    // iOS/Androidに応じて適切なURLを使用
    final Uri uri = Uri.parse(Theme.of(context).platform == TargetPlatform.iOS 
        ? appStoreUrl 
        : playStoreUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ストアを開くことができませんでした'),
          ),
        );
      }
    }
  }
}