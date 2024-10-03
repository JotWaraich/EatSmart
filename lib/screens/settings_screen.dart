import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final String githubUrl =
      'https://github.com/your-github-username'; // Your GitHub URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About App'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Visit GitHub'),
            onTap: () {
              _launchURL(githubUrl);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('About EatSmart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EatSmart\nVersion: 1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'EatSmart is an app designed to help you scan products and get '
                'nutritional information. It aims to promote smarter and '
                'healthier food choices.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
