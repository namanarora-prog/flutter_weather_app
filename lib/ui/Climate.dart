import 'package:flutter/material.dart';
import 'api_info.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class climatic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new climaticState();
  }
  
}

class climaticState extends State<climatic> {
final searchedcity=Map();
String SearchedCity="Bareilly";
String ReplacedCity="Bareilly";
int indexno=1;
var img=['images/weather.png','images/cold.png','images/cloudy.png','images/sunny.png'];
  Future getsearchcityclass(BuildContext context) async{
          Map searchedcity=await Navigator.of(context).push(
            MaterialPageRoute<Map>(
              builder: (BuildContext context){
                  return searchcityclass();
              }
            )
          );
          if (searchedcity.containsKey('city') && searchedcity!=null){
            print(searchedcity.toString());
           SearchedCity=searchedcity['city'];
           if(SearchedCity.contains(" ")){
             ReplacedCity=SearchedCity.split(" ").join("+");
           }
           else{
             ReplacedCity=SearchedCity;
           }
          }
          else{
            print("not");
          }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){getsearchcityclass(context);},
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/background.jpg"),
          fit: BoxFit.cover
          )
        ),
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: updateImg(ReplacedCity),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20.0),
              child: Text(SearchedCity,
              style:cityStyle(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              /*alignment: Alignment.bottomLeft,*/
              child: updateTemp(ReplacedCity)
            ),

          ],
        )
      )
    );
  }

  Future<Map> getWeather(String apiId,String city) async{
    String apiUrl="http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=metric&cnt=1";

    http.Response rs=await http.get(apiUrl);

    return json.decode(rs.body);
  }

Widget updateImg(String city){
    return FutureBuilder(
      future:getWeather(util.apiId, city),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if (snapshot.hasData){
          if(snapshot.data['message']=="city not found"){
            return Container(
                child:  Image.asset(img[0])
            );
          }
          else{
            if (snapshot.data['main']['temp'].round()<=20){indexno=1;}
            else if(snapshot.data['main']['temp'].round()>20 && snapshot.data['main']['temp'].round()<=35){indexno=2;}
            else{indexno=3;}
            return Container(
              child: Image.asset(img[indexno])
            );
          }
        }
        else{
          return Container();
        }
      },
    );
}

  Widget updateTemp(String city){
    return FutureBuilder(
      future: getWeather(util.apiId,city),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if (snapshot.hasData){
          if(snapshot.data['message']=="city not found"){
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("City Not Found",
                  style: tempStyle(),
                  )
                ],
              ),
            );
          }
          else{
          double temp,max,min;
          String humidity;
          temp=double.parse(snapshot.data['main']['temp'].toString());
          max=double.parse(snapshot.data['main']['temp_max'].toString());
          min=double.parse(snapshot.data['main']['temp_min'].toString());
          humidity=snapshot.data['main']['humidity'].toString();
          if (max==min){
            max=max+4.09;
            min=min-4.09;
            print("max-min same "+city+" "+temp.toString());
          }
          return Container(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Temp:"+temp.toString(),
                      style: tempStyle()),
                  Text("Max:"+max.toStringAsFixed(2),
                      style:minmax()),
                  Text("Min:"+min.toStringAsFixed(2),
                      style:minmax()),
                  Text("Humidity: $humidity",
                    style: minmax(),
                  )
                ],
              )
          );
          }}
        else{
          return Container();
        }
      },
    );
  }
}

class searchcityclass extends StatefulWidget {
  @override
  _searchcityclassState createState() => _searchcityclassState();
}



class _searchcityclassState extends State<searchcityclass> {
  final citytextcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/sunny.jpg"),
              fit: BoxFit.cover,
            )
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: Theme(data: ThemeData(
                primaryColor: Colors.deepPurpleAccent,
                primaryColorDark: Colors.deepPurpleAccent,
              ), child: TextField(
                cursorColor: Colors.deepPurpleAccent,
                decoration: InputDecoration(
                    hintText: "Search City",
                    hintStyle: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: 'norwester'),
                  suffixIcon: InkWell(
                    child: Icon(Icons.search),
                    onTap: (){Navigator.pop(context,{
                      'city':citytextcontroller.text,
                    });},
                  )
                ),
                controller: citytextcontroller,
                style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: 'norwester'),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

void showmessagedialog(BuildContext context,String st){
  var alert=AlertDialog(
    title: Text("Weather"),
    content: Text(st),
    actions: <Widget>[
      FlatButton(
        child:Text("Ok"),
        onPressed:(){ Navigator.pop(context);},
      )
    ],
  );
  showDialog(context: context,child: alert);
}


TextStyle cityStyle(){
  return TextStyle(
    fontSize: 38.0,
    color: Colors.white,
  );
}

TextStyle tempStyle(){
  return TextStyle(
    fontSize: 52.0,
    color: Colors.white,
  );
}

TextStyle minmax(){
  return TextStyle(
      fontSize: 24.0,
      color: Colors.white70
  );
}