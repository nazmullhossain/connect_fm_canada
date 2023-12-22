import 'dart:convert';

import 'package:waveui/waveui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/getPage?type=privacy-policy'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).first;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      appBar: WaveAppBar(
        title: 'Privacy Policy',
      ),
      backgroundColor: Get.theme.cardColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Html(data: snapshot.data?['content']),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
