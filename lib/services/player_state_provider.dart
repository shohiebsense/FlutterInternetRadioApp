import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:internet_radio_app/models/radio_station.dart';
import 'package:internet_radio_app/services/network_download_service.dart';

import 'db_service.dart';

enum RadioPlayerState { LOAD, STOP, PLAY, PAUSE, COMPLETE }

class PlayerStateProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  RadioStation _radioStation;

  List<RadioStation> _radioList;
  List<RadioStation> get allRadio => _radioList;
  int get totalRadio => _radioList != null ? _radioList.length : 0;
  RadioStation get currentRadio => _radioStation;
  RadioPlayerState _playerState = RadioPlayerState.STOP;

  getPlayerState() => _playerState;
  getAudioPlayer() => _audioPlayer;
  getCurrentRadio() => _radioStation;
  StreamSubscription _positionSubscription;


  PlayerStateProvider(){
    _initStream();
  }

  void _initStream() {
    _radioList = List<RadioStation>();
    if (_radioList == null) {
      _radioStation = new RadioStation(id: 0);
    }
  }

  void resetStream() {
    _initStream();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.STOP) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(RadioStation radio) async {
    _radioStation = radio;
    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.LOAD);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      if (_playerState == RadioPlayerState.LOAD &&
          duration.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.PLAY);
      }
      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print("");
      if (state == AudioPlayerState.PLAYING) {
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(RadioPlayerState.STOP);
        notifyListeners();
      }
    });
  }

  playRadio() async {
    await _audioPlayer.play(currentRadio.url, stayAwake: true);
  }

  stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(RadioPlayerState.STOP);
      await _audioPlayer.stop();
    }
  }

  bool isPlaying() {
    return getPlayerState() == RadioPlayerState.PLAY;
  }

  bool isLoading() {
    return getPlayerState() == RadioPlayerState.LOAD;
  }

  bool isStopped() {
    return getPlayerState() == RadioPlayerState.STOP;
  }

  fetchAllRadios(
      {String searchQuery = "", bool isFavoriteOnly = false}) async {
    _radioList = await NetworkDownloadService.fetchLocalDB(
      searchQuery: searchQuery,
      isFavoriteOnly : isFavoriteOnly,
    );
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state){
    _playerState = state;
    notifyListeners();
  }

  Future<void> radioBookmarked(int radioId, bool isFavorite, {bool isFavoriteOnly = false}) async {
    int isFavoriteVal = isFavorite ? 1 : 0;
    await DB.init();
    await DB.rawInsert(
      "INSERT OR REPLACE INTO radio_bookmark (id, is_favorite) VALUES ($radioId, $isFavoriteVal)"
    );

    fetchAllRadios(isFavoriteOnly: isFavoriteOnly);
  }


}
