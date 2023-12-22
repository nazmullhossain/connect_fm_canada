import 'dart:convert';

import 'package:waveui/waveui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/getPage?type=contact-us'));
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
        title: 'Contact Us',
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
