import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:waveui/waveui.dart';

class WebviewPlainPage extends StatefulWidget {
  WebviewPlainPage({super.key, required this.link});
  final String link;

  @override
  State<WebviewPlainPage> createState() => _WebviewPlainPageState();
}

class _WebviewPlainPageState extends State<WebviewPlainPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      isLoading: isLoading,
      body: InAppWebView(
        initialUrlRequest: URLRequest(

          url: WebUri(widget.link),
        ),
        onLoadStart: (controller, url) => setState(() {
          isLoading = false;
        }),
        onLoadStop: (controller, url) => setState(() {
          isLoading = false;
        }),
      ),
    );
  }
}
