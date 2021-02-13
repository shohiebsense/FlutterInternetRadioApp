import 'package:internet_radio_app/models/base_model_db.dart';
import 'dart:developer' as developer;
class RadioStation extends BaseModelDb {
  static String TABLE_NAME = 'radio';

  final int id;
  final String name;
  final String url;
  final String desc;
  final String website;
  final String pic;
  final bool isBookmarked;

  RadioStation(
      {this.id,
      this.name,
      this.url,
      this.desc,
      this.website,
      this.pic,
      this.isBookmarked});

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    developer.log(json.toString(), name: "serializing");
    return RadioStation(
      id: json["id"],
     name: json["radio_name"],
     url: json["radio_url"],
     desc: json["radio_desc"],
     website: json["radio_website"],
     pic: json["radio_pic"],
     isBookmarked: false,
    );
  }

  static RadioStation fromMap(Map<String, dynamic> map){
   return RadioStation(
     id: map['id'],
     name: map['radio_name'],
     url: map['radio_url'],
     desc: map['radio_desc'],
     website: map['radio_website'],
     pic: map['radio_pic'],
     isBookmarked: map['is_favorite'] == 1 ? true : false,
   );
  }

  Map<String, dynamic> toMap(){
   Map<String, dynamic> map = {
    'radio_name' : name,
    'radio_url' : url,
    'radio_desc' : desc,
    'radio_website' : website,
    'radio_pic' : pic
   };

   if(id != null){
    map['id'] = id;
   }
   return map;

  }
}
