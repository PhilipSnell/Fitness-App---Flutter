import 'package:flutter/material.dart';
import 'package:xcell/theme/style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPopup extends StatelessWidget {
  final String url;
  final String name;
  VideoPopup({this.url, this.name});

  Widget build(BuildContext context) {
    String videoID= YoutubePlayer.convertUrlToId(url);
    return new AlertDialog(
      title: Text("$name",textAlign: TextAlign.center,),

      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoID, //Add videoID.
            flags: YoutubePlayerFlags(
              hideControls: false,
              controlsVisibleAtStart: true,
              autoPlay: true,
              mute: false,
              ),
            ),
            bottomActions: [
              const SizedBox(width: 14.0),
              CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(isExpanded: true,),
              RemainingDuration(),
              const PlaybackSpeedButton(),
            ],
            progressIndicatorColor: featureColor,
          ),

        ],
      ),
      actions: <Widget>[
        Center(
          child: new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child:const Text('Close', textAlign: TextAlign.center,),
            ),
          ),
        ),
      ],
    );
  }

}