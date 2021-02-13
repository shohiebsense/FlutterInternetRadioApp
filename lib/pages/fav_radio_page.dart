import 'package:flutter/material.dart';
import 'package:internet_radio_app/pages/radio_page.dart';


class FavRadioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RadioPage(isFavoriteOnly: true);
  }

}