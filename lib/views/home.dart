import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controllers/player_controller.dart';
import 'package:musicplayer/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.green,
                ))
          ],
          leading: Icon(
            Icons.sort_rounded,
            color: Colors.purpleAccent,
          ),
          title: Text(
            "Beats",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioquery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                print(snapshot.data);
                return Center(child: Text("No Song Found"));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext, int index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 4),
// decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(12)
// ),
                          child: Obx(
                            () => ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: Colors.grey,
                              title: Text(
                                "${snapshot.data![index].displayNameWOExt}",
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist}",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: CircleAvatar(
                                  radius: 25,
                                  child: Icon(
                                    Icons.music_note_rounded,
                                    color: Colors.pink,
                                    size: 20,
                                  ),
                                ),
                              ),
                              trailing: controller.playIndex.value == index && controller.isPlaying.value
                                  ? Icon(
                                      Icons.play_arrow,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : null,
                              onTap: () {
                                Get.to(()=> Player(data: snapshot.data!,),
                                transition: Transition.downToUp
                                );
                                controller.playSong(
                                    snapshot.data![index].uri, index);
                              },
                            ),
                          ));
                    }),
              );
            }));
  }
}
