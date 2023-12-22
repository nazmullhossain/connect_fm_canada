import 'dart:convert';

import 'package:waveui/waveui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class TncPage extends StatefulWidget {
  @override
  _TncPageState createState() => _TncPageState();
}

class _TncPageState extends State<TncPage> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/getPage?type=terms-of-use'));
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
        title: 'Terms of Use',
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
