import 'package:internet_radio_app/models/radio_api_service.dart';
import 'package:internet_radio_app/models/radio_station.dart';
import 'package:internet_radio_app/services/network_service.dart';
import '../constants.dart';
import 'db_service.dart';
import 'dart:developer' as developer;

class NetworkDownloadService {

  static Future<bool> checkLocalDBExists(RadioApiService radioApiService) async {
    await DB.init();
    DateTime radioApiDateTime = DateTime.parse(radioApiService.timeLatestUpdate);
    bool isLatest = await DB.getTimeLatestUpdate(radioApiDateTime);
    List<Map<String, dynamic>> _results = await DB.query(RadioStation.TABLE_NAME);

    if(isLatest){
      return false;
    }

    return  _results.isNotEmpty;
  }

  static Future<RadioApiService> fetchAllRadioList() async {
    final serviceResponse = await WebService().getData(Constants.API_URL);
    return serviceResponse;
  }

  static Future<List<RadioStation>> fetchLocalDB({
    String searchQuery,
    bool isFavoriteOnly,
  }) async {
    RadioApiService radioApiService = await fetchAllRadioList();

    if (!await checkLocalDBExists(radioApiService)) {
      //developer.log(checkIfNotExist.toString(), name: "shohieb fetching initiated?");

      developer.log(radioApiService.radioStationList.length.toString(),
          name: "response shohieb");

      if (radioApiService.radioStationList.length > 0) {
        await DB.init();
        DB.clearTables();
        DB.rawInsert("INSERT OR REPLACE INTO radio_time_update (time_latest_data) VALUES ('${radioApiService.timeLatestUpdate}')");

        radioApiService.radioStationList.forEach((RadioStation radioStation) {
          developer.log(radioStation.name, name: "shohieb inserting");
          DB.insert(RadioStation.TABLE_NAME, radioStation);
        });
      }
    }

    String rawQuery = "";

    if(!isFavoriteOnly){
      rawQuery = DB.getAllWithFav();
    }
    else if(!isFavoriteOnly && searchQuery.isNotEmpty){
      rawQuery = DB.getAllWithFavAndSearchQuery(searchQuery);
    }

    developer.log(isFavoriteOnly.toString(), name: "shohieb passed: is fav only");

    if(isFavoriteOnly){
      rawQuery = DB.getFavOnly();
    }
    else if(isFavoriteOnly && searchQuery.isNotEmpty){
      rawQuery = DB.getFavOnlyWithQuery(searchQuery);
    }

    List<Map<String, dynamic>> _resultList =
        await DB.rawQuery(rawQuery);
    List<RadioStation> radioStationList = new List<RadioStation>();
    radioStationList =
        _resultList.map((item) => RadioStation.fromMap(item)).toList();
    /*radioStationList.forEach((element) {
      developer.log("url " + element.pic, name: "radio_pic");
    });*/

    return radioStationList;
  }


}
