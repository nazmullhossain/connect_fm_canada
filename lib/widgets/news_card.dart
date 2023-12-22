import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:connectfm/models/title_model.dart';
import 'package:connectfm/pages/news_reader_page.dart';
import 'package:tapped/tapped.dart';
import 'package:waveui/waveui.dart';

class NewsCard extends StatelessWidget {
  final TitleModel titleModel;
  final bool isCompact;
  final bool isEntertainments;
  NewsCard({
    super.key,
    required this.titleModel,
    this.isCompact = false,
    required this.isEntertainments,
  });

  final AppController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return compactNews();
    }
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: Tapped(
        onTap: titleModel.slug != null
            ? () => Get.to(NewsReaderPage(
                slug: titleModel.slug!, isEntertainments: isEntertainments))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titleModel.image != null)
              AspectRatio(
                aspectRatio: 5 / 3,
                child: CachedNetworkImage(
                  imageUrl: titleModel.image!,
                  fit: BoxFit.cover,
                  memCacheWidth: 512,
                ),
              ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Obx(
                () => Text(
                  controller.lang.value == 0
                      ? "${titleModel.title}"
                      : "${titleModel.titlePa}",
                  style: Get.textTheme.headlineMedium!.copyWith(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Obx(
                () => Text(
                  controller.lang.value == 0
                      ? "${titleModel.intro}"
                      : "${titleModel.introPa}",
                  style: Get.textTheme.bodySmall?.copyWith(fontSize: 16),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget compactNews() {
    return ListTile(
      onTap: titleModel.slug != null
          ? () => Get.to(NewsReaderPage(
              slug: titleModel.slug!, isEntertainments: isEntertainments))
          : null,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Obx(
          () => Text(
            controller.lang.value == 0
                ? "${titleModel.title}"
                : "${titleModel.titlePa}",
            style: Get.textTheme.titleLarge!.copyWith(
              fontSize: 23,
            ),
          ),
        ),
      ),
      subtitle: Row(
        children: [
          if (titleModel.image != null) ...[
            SizedBox(
              width: 100,
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: titleModel.image!,
                  fit: BoxFit.cover,
                  memCacheWidth: 256,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
          Expanded(
            child: Obx(
              () => Text(
                controller.lang.value == 0
                    ? "${titleModel.intro}"
                    : "${titleModel.introPa}",
                style: Get.textTheme.bodySmall?.copyWith(fontSize: 16),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
