import 'package:flutter/material.dart';
import 'package:internet_radio_app/models/radio_station.dart';
import 'package:internet_radio_app/services/player_state_provider.dart';
import 'package:provider/provider.dart';

class RadioStationWidget extends StatefulWidget {
  final RadioStation radioStation;
  final bool isFavoriteOnlyRadios;

  RadioStationWidget({Key key, this.radioStation, this.isFavoriteOnlyRadios})
      : super(key: key);

  @override
  _RadioStationWidgetState createState() => _RadioStationWidgetState();
}

class _RadioStationWidgetState extends State<RadioStationWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildRadioStationWidget();
  }

  Widget _buildRadioStationWidget() {
    var playerProvider =
        Provider.of<PlayerStateProvider>(context, listen: false);
    //print("is null ${playerProvider.currentRadio.id}");
    // final bool _isRadioSelected = this.widget.radioStation.id == playerProvider.currentRadio.id;
    final bool _isRadioSelected = false;
    return ListTile(
      title: new Text(
        this.widget.radioStation.name,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff182545),
        ),
      ),
      leading: _image(this.widget.radioStation.pic),
      subtitle: new Text(
        this.widget.radioStation.desc,
        maxLines: 2,
      ),
      trailing: Wrap(
        spacing: -10.0,
        runSpacing: 0.0,
        children: [
          _buildPlayStopIcon(
              playerProvider: playerProvider,
              isRadioSelected: _isRadioSelected),
          _buildAddFavoriteIcon(),
        ],
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
          color: Color(0xffffe5ec),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3))
          ]),
    );
  }

  Widget _buildPlayStopIcon(
      {PlayerStateProvider playerProvider, bool isRadioSelected}) {
    return IconButton(
      icon: _buildPlayStopPauseButton(
          playerStateProvider: playerProvider,
          isRadioSelected: isRadioSelected),
      onPressed: () {
        if (!playerProvider.isStopped() && isRadioSelected) {
          playerProvider.stopRadio();
        }
        if (!playerProvider.isLoading()) {
          playerProvider.initAudioPlugin();
          playerProvider.setAudioPlayer(this.widget.radioStation);
          playerProvider.playRadio();
        }
      },
    );
  }

  Widget _buildPlayStopPauseButton(
      {PlayerStateProvider playerStateProvider, bool isRadioSelected}) {
    if (!isRadioSelected) {
      return Icon(Icons.play_circle_filled);
    }
    if (playerStateProvider.isLoading()) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      );
    }

    if (!playerStateProvider.isStopped()) {
      return Icon(Icons.stop);
    }

    return Icon(Icons.play_circle_filled);
  }

  Widget _buildAddFavoriteIcon() {
    var playerStateProvider =
        Provider.of<PlayerStateProvider>(context, listen: true);
    return IconButton(
      icon: this.widget.radioStation.isBookmarked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      color: Color(0xff9097A6),
      onPressed: () {
        playerStateProvider.radioBookmarked(
            this.widget.radioStation.id, !this.widget.radioStation.isBookmarked,
            isFavoriteOnly: this.widget.isFavoriteOnlyRadios);
      },
    );
  }
}
