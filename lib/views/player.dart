import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;

  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(()=>
               Expanded(
                  child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 250,
                width: 250,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: Icon(
                    Icons.music_note_rounded,
                    size: 40,
                    color: Colors.pink,
                  ),
                ),
              )),
            ),
            const SizedBox(
              height: 10,
            ),
               Obx(()=>
                  Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          data[controller.playIndex.value].displayNameWOExt,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Obx(()=>
                         Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Slider(
                                    thumbColor: Colors.red,
                                    inactiveColor: Colors.black,
                                    activeColor: Colors.deepOrange,
                                    min: Duration(seconds: 0).inSeconds.toDouble(),
                                    max: controller.max.value,
                                    value: controller.value.value,
                                    onChanged: (newValue) {
                                      controller.changeDurationToSeconds(newValue.toInt());
                                      newValue = newValue;
                                    })),
                            Text(controller.duration.value,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.playSong(data[controller.playIndex.value-1].uri, controller.playIndex.value-1);
                              },
                              icon: Icon(
                                Icons.skip_previous,
                                size: 25,
                              )),
                          Obx(()=>
                             CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Transform.scale(
                                    scale: 2,
                                    child: IconButton(
                                        onPressed: () {
                                          if(controller.isPlaying.value){
                                            controller.audioPlayer.pause();
                                            controller.isPlaying(false);
                                          }else{
                                            controller.audioPlayer.play();
                                            controller.isPlaying(true);
                                          }
                                        },
                                        icon: controller.isPlaying.value ? Icon(
                                          Icons.pause,
                                        )
                                    :Icon(
                                  Icons.play_arrow,
                                )
                                    ))),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.playSong(data[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                              },
                              icon: Icon(
                                Icons.skip_next,
                                size: 25,
                              )),
                        ],
                      )
                    ],
                  ),
              )),
               ),

          ],
        ),
      ),
    );
  }
}
