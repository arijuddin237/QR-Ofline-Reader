import 'package:flutter/material.dart';

import 'package:qr_offline_order/screen/mainBody.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:qr_offline_order/screen/settingScreen.dart';
import 'package:qr_offline_order/widget/appbar.dart';
import 'package:qr_offline_order/widget/bottomAppBar.dart';
import 'package:qr_offline_order/widget/responsiveWidget.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;
import 'package:qr_offline_order/library/librarySizeConfig.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int lastSelected = 0;

  void _selectedTab(int index){
    setState(() {
      lastSelected = index;
    });
  }

  Widget body(){
    if(lastSelected == 0){
      return MainBody();
    } else {
      return SettingScreen();
    }
  }
  
  Widget fabBottomAppBar(String text){
    return FABBottomApBar(
      centerItemText: text,
      backgroundColor: Colors.grey[900],
      color: Colors.grey,
      selectedColor: Colors.red,
      notchedShape: CircularNotchedRectangle(),
      onTabSelected: _selectedTab,
      items: [
        FABBottomAppBarItem(iconData: Icons.menu, text: 'List'),
        FABBottomAppBarItem(iconData: Icons.settings, text: 'Setting'),
      ],
    );
  }

  Widget streamFabBottomAppBar(BuildContext context){
    return StreamBuilder<List>(
      stream: blocQRReader.subject.stream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length > 0){
            List splitNumber;
            for (var i = 0; i < snapshot.data.length; i++) {
              splitNumber = snapshot.data[i][1].split('/');
            }
            if(splitNumber[0] == splitNumber[1]){
              return fabBottomAppBar('Decrypt');
            } else {
              return fabBottomAppBar('Scan QR');
            }
          } return fabBottomAppBar('Scan QR');
        } return fabBottomAppBar('Scan QR');
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width.toString());
    appsSetting.fontSizeHeading = ResponsiveWidget.isSmallScreen(context)
      ? 15 : ResponsiveWidget.isMediumScreen(context)
      ? 15 : 17;
    appsSetting.fontSizeContent = ResponsiveWidget.isSmallScreen(context)
      ? 13 : ResponsiveWidget.isMediumScreen(context)
      ? 13 : 15;
    appsSetting.fontSizeContentUser = ResponsiveWidget.isSmallScreen(context)
      ? 17 : ResponsiveWidget.isMediumScreen(context)
      ? 17 : 20;
    SizeConfig().init(context);
    return Scaffold(
      appBar: getAppBar('QR Offline Order', context, lastSelected),
      body: body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatActionButton(context),
      bottomNavigationBar: streamFabBottomAppBar(context)
    );
  }
}