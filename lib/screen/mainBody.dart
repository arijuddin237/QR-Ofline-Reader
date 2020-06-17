import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'package:qr_offline_order/model/operator.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:qr_offline_order/bloc/blocGetOp.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/function/httpRequest.dart';
import 'package:qr_offline_order/library/libraryFontStyle.dart' as textStyle;
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;
import 'package:qr_offline_order/screen/passwordPage.dart';
import 'package:qr_offline_order/widget/responsiveWidget.dart';

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  bool isloggedIn = false;

  //-create image user-------------------------------------------------------------------
  Widget imageUser(){
    if(ResponsiveWidget.isLargeScreen(context)){
      return Row(
        children: <Widget>[
          Image.asset('image/user.png', scale: 10),
          Padding(
            padding: EdgeInsets.all(10),
          )
        ],
      );
    } else {
      return Column();
    }
  }

  //-create padding based on device size-------------------------------------------------
  EdgeInsets getPaddingValue(){
    if(ResponsiveWidget.isLargeScreen(context)){
      return EdgeInsets.only(top: MediaQuery.of(context).size.height * .05);
    } else {
      return EdgeInsets.only(top: MediaQuery.of(context).size.height * .03);
    }
  }

  //-Dialog while user press logout------------------------------------------------------
  Widget alertDialogLogout(){
    return AlertDialog(
      content: Text('Are you sure you want to Logout?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No', style: TextStyle(
            color: Colors.black
          )),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Yes', style: TextStyle(
            color: Colors.black
          )),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => PasswordScreen()
            ));
            blocSetOperator.clearIndexOperator();
          },
        )
      ],
    );
  }

  //build logout icon--------------------------------------------------------------------
  Widget logoutIcon(){
    return StreamBuilder(
      stream: blocSetOperator.subject.stream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.black),
                iconSize: MediaQuery.of(context).size.width * .1,
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return alertDialogLogout();
                    }
                  );
                },
              ),
              Text('Logout', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: appsSetting.fontSizeHeading
              ))
            ],
          );
        } else {
          return Column();
        }
      },
    );
  }

  @override
  void initState() {
    appsSetting.test.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    color: Colors.grey[900],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('image/imageSetting.png')
                      ],
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: StreamBuilder<List>(
                        stream: blocQRReader.subject.stream,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data.length > 0){

                              TimelineModel qrTimelineBuilder(BuildContext context, int i){
                                final qrTimeline = snapshot.data[i];
                                List splitNumber = qrTimeline[1].split('/');

                                Text value(){
                                  var valueBarcode = qrTimeline[3];
                                  if(valueBarcode.length > 100){
                                    return Text(valueBarcode.substring(0, 100)+'..........',
                                      style: textStyle.txtStyleCardContent);
                                  } else {
                                        return Text(valueBarcode, style: textStyle.txtStyleCardContent);
                                  }
                                }
                                
                                return TimelineModel(
                                  Card(
                                    elevation: 3,
                                    color: Colors.orange[800],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Barcode Number : ${splitNumber[0]} from ${splitNumber[1]} barcode',
                                            style: textStyle.txtStyleCardTitle),
                                          Divider(
                                            color: Colors.white,
                                          ),
                                          Text('Value : ', style: textStyle.txtStyleCardTitle),
                                          value()
                                        ],
                                      ),
                                    ),
                                  ),
                                  position: TimelineItemPosition.right,
                                  isFirst: i == 0,
                                  isLast: i == qrTimeline.length,
                                  iconBackground: Colors.red
                                );
                              }

                              qrTimelineModel(TimelinePosition position){
                                return Timeline.builder(
                                  itemBuilder: qrTimelineBuilder,
                                  itemCount: snapshot.data.length,
                                  physics: position == TimelinePosition.Left
                                    ? ClampingScrollPhysics()
                                    : BouncingScrollPhysics(),
                                  position: position,
                                );
                              }

                              return Padding(
                                padding: getPaddingValue(),
                                child: qrTimelineModel(TimelinePosition.Left)
                              );
                            } else {
                              return Padding(
                                padding: getPaddingValue(),
                                //child: timelineModel(TimelinePosition.Left),
                              );
                            }
                          } else {
                            return Padding(
                              padding: getPaddingValue(),
                              //child: timelineModel(TimelinePosition.Left),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .13,
                  right: 15.0,
                  left: 15.0
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * .15,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              imageUser(),
                              StreamBuilder(
                                stream: blocSetOperator.subject.stream,
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    isloggedIn = true;
                                    return StreamBuilder<Operator>(
                                      stream: blocGetOperator.subject.stream,
                                      builder: (context, snap){
                                        if(snap.hasData){
                                          appsSetting.operatorID = snap.data.message[snapshot.data].operatorNo;
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Operator Name : ${snap.data.message[snapshot.data].operatorName}',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: appsSetting.fontSizeHeading)),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                              ),
                                              Text('Login Time : '+appsSetting.loginTime, style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: appsSetting.fontSizeHeading
                                              )),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                              ),
                                              Text('Sell Band : '+appsSetting.endpointGetPlu.split('/')[1], style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: appsSetting.fontSizeHeading
                                              ))
                                            ],
                                          );
                                        } else {
                                          return Row();
                                        }
                                      },
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Operator Name : Admin', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: appsSetting.fontSizeContentUser
                                        )),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text('Login Time : '+appsSetting.loginTime, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: appsSetting.fontSizeContentUser
                                        )),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text('Sell Band : '+appsSetting.endpointGetPlu.split('/')[1], style: TextStyle(
                                          fontSize: appsSetting.fontSizeHeading,
                                          fontWeight: FontWeight.w500
                                        ))
                                      ],
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          logoutIcon()
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          StreamBuilder(
            stream: blocError.subject.stream,
            builder: (context, snapError){
              if(snapError.hasData){
                getPlu();
                getOperator();
                getModifier();
                if(snapError.data.length > 0){
                  Text generateText(){
                    if(snapError.data == '1'){
                      return Text("can't connect to databse ${appsSetting.apiUrl}", style: textStyle.txtStyleErrConn);
                    } else if(snapError.data == '2'){
                      return Text("Waiting for Connection...", style: textStyle.txtStyleErrConn);
                    } else {
                      return Text('Connection Time Out, Reconnecting...', style: textStyle.txtStyleErrConn);
                    }
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      elevation: 10,
                      color: Colors.orange[700],
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          children: <Widget>[
                            generateText()
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Row();
                }
              } else {
                return Row();
              }
            },
          ),
        ],
      ),
    );
  }
}