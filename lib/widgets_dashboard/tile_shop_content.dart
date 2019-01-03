import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class TileShopContent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    double adjustedSubFontSize = MediaQuery.of(context).size.width * 0.032;

    return Padding (
      padding: const EdgeInsets.all(24.0),
      child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Hero(
              tag: 'shop-green',
              child: Material (
                  color: FlatColors.greenTeal,
                  shape: CircleBorder(),
                  child: Padding (
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.store, color: Colors.white, size: 30.0),
                  )
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Text('Shop', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 24.0)),
            //Text("Coming Soon", style: Fonts.subHeaderTextStyle)
            Text("Purchase Rewards", style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w400, fontSize: adjustedSubFontSize)),
          ]
      ),
    );
  }
}