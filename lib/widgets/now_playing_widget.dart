import 'package:flutter/material.dart';
import 'package:internet_radio_app/services/player_state_provider.dart';
import 'package:provider/provider.dart';

class NowPlayingWidget extends StatelessWidget {
  final String radioTitle;
  final String radioImageURL;

  NowPlayingWidget({this.radioTitle, this.radioImageURL});

  @override
  Widget build(BuildContext context) {
      return Container(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Color(0xff182545)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nowPlayingText(context, this.radioTitle, this.radioImageURL)
              ],
            ),
          ),
        ),
      );

  }


  Widget _nowPlayingText(BuildContext context, String title, String imageUrl) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: ListTile(
        title: new Text(
          title,
          style: new TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xffffffff)),
        ),
        subtitle: new Text(
          "Now Playing",
          textScaleFactor: 0.8,
          style: new TextStyle(
            color: Color(0xffffffff),
          ),
        ),
        leading: buildImageWidget(imageUrl, size: 50.0),
        trailing: Wrap(
          spacing: -10.0,
          children: [_buildStopIcon(context), _buildShareIcon()],
        ),
      ),
    );
  }

  Widget buildImageWidget(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: Color(0xff182545),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildStopIcon(BuildContext context) {
    var playerStateProvider = Provider.of<PlayerStateProvider>(context, listen: false);



    return IconButton(
        icon: Icon(Icons.stop), color: Color(0xff9097A6), onPressed: (){
          playerStateProvider.stopRadio();
    });
  }

  Widget _buildShareIcon() {
    return IconButton(
      icon: Icon(Icons.share),
      color: Color(0xff9097A6),
      onPressed: () {},
    );
  }
}
