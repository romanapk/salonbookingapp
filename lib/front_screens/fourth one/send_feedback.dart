import 'package:flutter_share/flutter_share.dart';

class ShareApp {
  static Future<void> shareContent() async {
    final shareContent = '''
    Hey there! Check out my awesome Flutter app I'm developing.

    [Link to your app's GitHub repository](YOUR_GITHUB_REPO_URL)

    Let me know what you think!  
    ''';

    await FlutterShare.share(
      title: 'Try out my Flutter app (in development)',
      text: shareContent,
    );
  }
}
