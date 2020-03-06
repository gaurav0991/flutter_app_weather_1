import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'utils.dart' as util;
import 'package:http/http.dart' as http;
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String city="kolkata";
  Future gotoNextScreen(BuildContext context)async{
     Map results=await Navigator.of(context).push(
       new MaterialPageRoute(builder:(BuildContext context){
         return ChangeCity();
       })
     );
     if(results.isNotEmpty)
       {
          city=results['enter'].toString();
       }
  }
  void Showstuuf() async
  {
    Map data=await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        backgroundColor: Colors.orange,
        actions: <Widget>[
      IconButton(icon: Icon(Icons.menu),onPressed: (){gotoNextScreen(context);},)

        ],
      ),
      body: Stack(
        children: <Widget>[
           Center(
             child: new Image.asset('images/umbrella.png',
             fit: BoxFit.fill,
               width: 490.0,
               height: 1200,
             ),

           ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.all(8.0),
            child: Text("$city",style: TextStyle(color: Colors.white,fontSize: 30.9),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Image.asset('images/light_rain.png'),
          ),
          Container(

            margin: const EdgeInsets.fromLTRB(0.0, 390, 0, 0),
            child:updateWidget("$city")
          )
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId,String city)async
  {
    String url="http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial";
    http.Response response=await http.get(url);
    return jsonDecode(response.body);


  }
Widget updateWidget(String city)
{
  return FutureBuilder(
      future:getWeather(util.appId, city),
      builder: (BuildContext  context,AsyncSnapshot<Map> snapshot)
  {
if(snapshot.hasData)
  {
    Map content =snapshot.data;
    return Container(
      child: Column(
      children: <Widget>[
        ListTile(
        title: Text("Temp:${content['main']['temp'].toString()}",style: TextStyle(fontSize: 39.9,color: Colors.white,fontWeight: FontWeight.w500),),
          subtitle: ListTile(
            title: Text("Humidity:${content['main']['humidity'].toString()}\nMin:${content['main']['temp_min'].toString()}\nMax:${content['main']['temp_max'].toString()}",style: TextStyle(fontSize: 39.9,color: Colors.white,fontWeight: FontWeight.w500)),
          ),
        )
  ],
      ),
    );
  }
  else{
  return Container();
  }
  }
  );
}

}
class ChangeCity extends StatelessWidget {
  final TextEditingController textEditingController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
          backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: <Widget>[

          Image.asset('images/white_snow.png',width: 490,height: 1200,fit: BoxFit.fill,),
          TextField(controller: textEditingController,
          decoration: InputDecoration(
            labelText: "Enter City",
            hintText: "Kolkata"
          ),

          ),
          Container(

              margin: const EdgeInsets.fromLTRB(130.0, 70, 0.0,0.0),
            child: RaisedButton(onPressed: (){Navigator.pop(context,{'enter':textEditingController.text});}, child:Text("Get Weather",style: TextStyle(color: Colors.orange,fontSize: 21.0),)),



          )
          


        ],

      ),

    );
  }
}

