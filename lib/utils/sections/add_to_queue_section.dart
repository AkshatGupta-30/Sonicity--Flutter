import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/service_locator.dart';
import 'package:sonicity/src/audio/audio.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class AddToQueueDialog extends StatelessWidget {
  final Song song;
  AddToQueueDialog(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final audioManager = getIt<AudioManager>();
    final settings = Get.find<SettingsController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 5, borderRadius: BorderRadius.circular(12),
          color: Colors.transparent, shadowColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: song.image.medQuality,
                    height: 150, width: 150, fit: BoxFit.fill,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        "assets/images/songCover/songCover500x500.jpg",
                        fit: BoxFit.fill, width: 150, height: 150
                      );
                    },
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/songCover/songCover500x500.jpg",
                        fit: BoxFit.fill, width: 150, height: 150
                      );
                    },
                  ),
                ),
              ),
              Gap(3),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 250, height: 55, color: Colors.black,
                  child: BackgroundGradientDecorator(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      child: Column(
                        children: [
                          Text(song.title, style: theme.textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(song.subtitle, style: theme.textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(10),
        Container(
          width: double.maxFinite, padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white, width: 0.5),
          ),
          child: GetBuilder(
            init: QueueController(song),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add To Queue', style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal),),
                  Gap(10),
                  Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.queues.length,
                    itemBuilder: (context, index) {
                      Queue queue = controller.queues[index];
                      return QueueName(queue, controller, index: index,);
                    },
                  )),
                  ValueListenableBuilder(
                    valueListenable: audioManager.currentSongNotifier,
                    builder: (context, currentSong, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => NewQueueDialog(controller),
                            ),
                            style: ButtonStyle(
                              alignment: Alignment.centerLeft,
                              backgroundColor: MaterialStatePropertyAll(settings.getAccentDark.withOpacity(0.75))
                            ),
                            child: Text('＋ New Queue', style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
                          ),
                          (currentSong != null)
                              ? TextButton(
                                onPressed: () => audioManager.add(song.toMediaItem()),
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  backgroundColor: MaterialStatePropertyAll(settings.getAccentDark.withOpacity(0.75))
                                ),
                                child: Row(
                                  children: [
                                    Text('Current ', style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
                                    Iconify(MaterialSymbols.android_now_playing, size: 32,),
                                  ],
                                )
                              )
                              : Spacer(),
                        ],
                      );
                    }
                  )
                ],
              );
            }
          ),
        ),
      ],
    );
  }
}