import 'dart:convert';
import 'package:internet_radio_app/models/base_model.dart';
import 'package:http/http.dart' as http;
import 'package:internet_radio_app/models/radio_api_service.dart';
import 'dart:developer' as developer;
import 'package:internet_radio_app/models/radio_station.dart';

/*class RadioStationList {
  List<RadioStation> data;
  RadioStationList({this.data});
}*/

class WebService {
  Future<BaseModel> getData(String url) async {
    final response = await http.get(url);
    print("url -> $url");
    Map<String, dynamic> list = json.decode(response.body);
    Iterable data = list['data'];

   /* developer.log(data.length.toString(), name: "shohieb");

    data.forEach((element) {
      print(element['radio_name']);
      // RadioStation.fromJson('radio_name');
    });*/


    //developer.log(radioStationList.length.toString(), name: "shohiebbb length");
    //developer.log(list.toString(), name: "decode json");

    if (response.statusCode >= 199) {
      RadioApiService radioApiService = new RadioApiService();
      radioApiService.timeLatestUpdate = list["time_latest_update"];
      developer.log("time ${radioApiService.timeLatestUpdate}", name: "shohiebsense time");
      radioApiService.radioStationList  = List<RadioStation>.from(data.map((e) => RadioStation.fromJson(e)));
      return radioApiService;
    } else {
      throw Exception('failed to load data!');
    }
  }
}
