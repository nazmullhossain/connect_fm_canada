import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:connectfm/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waveui/waveui.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final String apiKey = "AIzaSyBQ-qqAba3kU_ncfxtBpXiIR8njnMB78GQ";
  final String channelId = "UChVmpG7svTIbwlA1Ie4BfKA";

  int maxResults = 10; // Initial number of videos to retrieve
  String nextPageToken = ''; // Used for pagination
  bool isLoading = false;
  List<YoutubeModel> videos = [];
  bool isError = false;

  var unescape = HtmlUnescape();

  final ScrollController _scrollController = ScrollController();
  final AppController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list, load more videos
        _loadMoreVideos();
      }
    });

    // Initial load of videos
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      isLoading = true;
    });

    String apiUrl = "https://www.googleapis.com/youtube/v3/search";
    String params =
        "?part=snippet&channelId=$channelId&type=video&videoType=any&videoDuration=medium&order=date&maxResults=$maxResults&pageToken=$nextPageToken&key=$apiKey";

    Uri url = Uri.parse(apiUrl+params);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(response.body);

      if (data.containsKey('items')) {
        for (var item in data['items']) {
          videos.add(YoutubeModel.fromJson(item));
        }

        nextPageToken = data.containsKey('nextPageToken')
            ? data['nextPageToken']
            : ''; // Use an empty string if nextPageToken is null
      }
      setState(() {
        isError = false;
      });
    } else {
      log(response.statusCode.toString() + response.body);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMoreVideos() async {
    if (!isLoading) {
      _loadVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Get.theme.cardColor,
      appBar: WaveAppBar(
        onBackPressed: () => controller.currentNavIndex.value = 0,
        title: Text('Latest Videos'),
      ),
      body: isError
          ? const Column(
              children: [Text("Please try again later, failed to load videos")],
            )
          : ListView.separated(
              separatorBuilder: (context, index) =>  Container(),
              shrinkWrap: true,
              itemCount: videos.length + 1, // +1 for the loading indicator
              controller: _scrollController,

              itemBuilder: (context, index) {
                if (index < videos.length) {
                  Snippet item = videos[index].snippet;
                  return InkWell(
                    onTap: () => _launchYouTubeVideo(videos[index].id.videoId),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: width * 0.3,
                                      width: width * 0.45,
                                      imageUrl: item.thumbnails.high.url),
                                  const Icon(
                                    Icons.play_circle_fill_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 8,

                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      unescape.convert(item.title),
                                      maxLines: 3,
                                      style: GoogleFonts.roboto(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500

                                      )
                                      // const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FluentIcons.calendar_12_regular,
                                          size: 14,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          DateFormat.yMMMMd().format(
                                              DateTime.parse(item.publishTime)),
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.black45),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(),
                          // SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Loading indicator
                  return LinearProgressIndicator();
                }
              },
            ),
    );
  }
}

void _launchYouTubeVideo(String videoId) async {
  Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
  await launchUrl(url);
}
