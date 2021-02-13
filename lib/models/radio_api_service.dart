import 'package:internet_radio_app/models/base_model.dart';
import 'package:internet_radio_app/models/radio_station.dart';

class RadioApiService extends BaseModel {
  List<RadioStation> radioStationList;
  String timeLatestUpdate;

  RadioApiService({
    this.radioStationList,
    this.timeLatestUpdate
  });


  RadioApiService.fromMap(Map<String, dynamic> map ){
    timeLatestUpdate = map['time_latest_update'];
  }

  @override
  fromJson(Map<String, dynamic> json) {
    this.radioStationList = (json["data"] as List)
        .map(
          (i) => RadioStation.fromJson(i),
        )
        .toList();
    this.timeLatestUpdate = (json["time_latest_update"]);
  }

  String getTimeLatestUpdateDbFormat(){
    try{
      DateTime dateTime = DateTime.parse(timeLatestUpdate);
      return dateTime.toIso8601String();
    } on FormatException {
      return "";
    }
  }



}
