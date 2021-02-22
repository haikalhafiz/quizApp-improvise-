import 'package:flutter/material.dart';
import 'startquiz.dart';



void main()  => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      //toHideTheDebugBannerOnTheDevice//
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Quiz App")),
                ),
      backgroundColor: Colors.white ,
      body: Column(
            children: [
                      Image.asset("assets/anak2u.png"),
                      SizedBox(height: 10,),
                      Text("Press button below to start"),
                      SizedBox(height: 50,),
                      RaisedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> startquiz()));
                        },//once Pressed It Will Direct To The Quiz Page And Start//
                        textColor: Colors.white,
                        color: Colors.deepOrangeAccent,
                        child: Text("Start now",style: TextStyle(fontSize: 20,),),
                      )
                      ],

                  ),

          );
        }
      }


