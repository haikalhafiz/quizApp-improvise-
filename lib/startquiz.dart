import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:quiz_app/model/quizBank.dart';

class startquiz extends StatefulWidget {
  @override
  _startquizState createState() => _startquizState();
}

class _startquizState extends State<startquiz> {

  Quiz quiz;
  List<Results> results;

  Future<void> fetchQuestion()async{
    var response = await http.get("https://opentdb.com/api.php?amount=10");
    var decResp = jsonDecode(response.body);
    print(decResp);
    quiz = Quiz.fromJson(decResp);
    results = quiz.results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("The quiz start now")),),
      body: FutureBuilder(
        //to retrieve the question from API//
        future: fetchQuestion(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Text("Press button to start.");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            case ConnectionState.done:
              //if no internet connection,the page will display blank//
              if(snapshot.hasError)return errorData (snapshot);
              return quizList();
          }
          return null;
        },
      ),
    );
  }
  //this widget ,,if no internet connection available,,this will come out//
  Padding errorData(AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("Error: No Connection")),
          SizedBox(height: 20.0,),
          RaisedButton(onPressed: (){
            fetchQuestion();
            setState(() {
            });//if internet connection is back,,the questions will come out when pressed //
          },
          child: Text("Try Again"),
          )
        ],
      ),
    );
  }



  ListView quizList(){
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context,index)=> Card(
        color: Colors.orange,
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    results[index].question,
                    style:  TextStyle(
                        fontSize: 18.0,
                        fontWeight:FontWeight.bold,
                    ),
                ),
                FittedBox(
                  //^To place the fittedbox close each other//
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FilterChip(
                        backgroundColor: Colors.orange[200],
                        label: Text(results[index].category),
                        onSelected: (b){},
                                ),
                      SizedBox(width: 10,), //to have a gap between filterchip//
                      FilterChip(
                        backgroundColor: Colors.orange[200],
                        label: Text(results[index].difficulty),
                        onSelected: (b){},
                                  )
                    ],
                  ),
                )
              ],
            ),
          ),
          leading: CircleAvatar(
                  backgroundColor: Colors.amberAccent[100],
                  child: Text(results[index].type.startsWith("m")?"M":"B",
                    //if it is MULTI CHOICE ANSWER,it will display M.otherwise it will display B(boolean)
                            style: TextStyle(color: Colors.black87),),
                   ),
          children: results[index].allAnswers.map((answ){
                   return Answer(results,index,answ);
                   }).toList(),
                   ),
              ),
          );
       }
    }

    class Answer extends StatefulWidget {
   //the widget for Answer choices //
      final List<Results> results;
      final int index;
      final String answ;

      Answer(this.results,this.index,this.answ);

      @override
      _AnswerState createState() => _AnswerState();
    }

    class _AnswerState extends State<Answer> {

      Color c = Colors.black;
        //initially the answer color is black//
      @override
      Widget build(BuildContext context) {
        return ListTile(
          onTap: (){
                 setState(() {
                   if(widget.answ == widget.results[widget.index].correctAnswer){
                     c = Colors.green;
                     //the answer's color turn Green once the user tap on the correct answer//
                   }else {
                     c = Colors.red;
                     //the answer's color turn Red once the user tap on the incorrect answer//
                   }
                 });
          },
          title : Text(
            widget.answ,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: c,
              //assigned color is "c" as per declared on top//
              fontWeight: FontWeight.bold,
            ),
          )
        );
      }
    }
