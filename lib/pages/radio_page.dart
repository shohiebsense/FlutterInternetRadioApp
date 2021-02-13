import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:internet_radio_app/models/radio_station.dart';
import 'package:internet_radio_app/services/network_download_service.dart';
import 'package:internet_radio_app/services/player_state_provider.dart';
import 'package:internet_radio_app/widgets/now_playing_widget.dart';
import 'package:internet_radio_app/widgets/radio_station_widget.dart';
import 'package:provider/provider.dart';

class RadioPage extends StatefulWidget {
  final bool isFavoriteOnly;

  RadioPage({Key key, this.isFavoriteOnly}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    print("is fav onlyy : ${this.widget.isFavoriteOnly.toString()}");
    var playerProvider = Provider.of<PlayerStateProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStream();
    playerProvider.fetchAllRadios(isFavoriteOnly: this.widget.isFavoriteOnly);

    _searchQuery.addListener(_onSearchChanged());
  }

  _onSearchChanged() {
    var stateProvider = Provider.of<PlayerStateProvider>(context, listen: false);

    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), (){
      stateProvider.fetchAllRadios(
        isFavoriteOnly: this.widget.isFavoriteOnly,
        searchQuery: _searchQuery.text
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildAppLogo(),
          _buildSearchBar(),
          _buildRadioListWidget(),
          _getNowPlayingWidget()
        ],
      ),
    );
  }

  Widget _getNowPlayingWidget() {
    PlayerStateProvider playerProvider =
        Provider.of<PlayerStateProvider>(context, listen: true);
    return Visibility(
      visible: playerProvider.getPlayerState() == RadioPlayerState.PLAY,
      child: NowPlayingWidget(
          radioTitle: "Current Radio: ",
          radioImageURL: "http://isharpeners.com/sc_logo.png"),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: double.infinity,
      color: Color(0xff182545),
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: new Text(
            "Radio App",
            style: TextStyle(fontSize: 30, color: Color(0xffffffff)),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
              child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(5),
              hintText: "Search Radio",
            ),
            controller: _searchQuery,
          )),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildNoDataWidget() {
    String noDataText = "";
    bool showTextMessage = false;

    if (this.widget.isFavoriteOnly ||
        (this.widget.isFavoriteOnly && _searchQuery.text.isNotEmpty)) {
      noDataText = "No Favorites";
      showTextMessage = true;
    } else if (_searchQuery.text.isNotEmpty) {
      noDataText = "No Radio Found";
      showTextMessage = true;
    }

    return Column(
      children: [
        new Expanded(
          child: Center(
              child: showTextMessage
                  ? new Text(
                      noDataText,
                      textScaleFactor: 1,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  : CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildRadioListWidget() {
    return Consumer<PlayerStateProvider>(
      builder: (context, radioStation, child) {
        if (radioStation.totalRadio <= 0) {
          return new Expanded(
            child: _buildNoDataWidget(),
          );
        }

        return new Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RadioStationWidget(
                        radioStation: radioStation.allRadio[index],
                        isFavoriteOnlyRadios: this.widget.isFavoriteOnly,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: radioStation.totalRadio)
              ],
            ),
          ),
        );

        return CircularProgressIndicator();
      },
    );
  }

/*Widget _buildRadioListWidget(){
    return new Expanded(
      child: Padding(
        child: ListView(
          children: [
            ListView.separated(
                itemBuilder: (context, index) {
                  return RadioStationWidget(radioStation: radioStation);
                }, separatorBuilder: (context, index) {
                  return Divider();
            }, shrinkWrap: true, itemCount: 30, physics: ScrollPhysics(),)
          ],
        ),
        padding: EdgeInsets.fromLTRB(0, 5,0, 5),
      ),
    );
  }*/

/*Widget _buildRadioListWidget() {
    return new FutureBuilder(
      future: NetworkDownloadService.fetchLocalDB(),
      builder:
          (BuildContext context, AsyncSnapshot<List<RadioStation>> radioList) {
        if (radioList.hasData) {
          return new Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ListView(
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RadioStationWidget(
                            radioStation: radioList.data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: radioList.data.length)
                ],
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }*/
}
