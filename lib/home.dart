import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteapp/classes/note.dart';
import 'package:noteapp/classes/sqel.dart';
import 'package:noteapp/classes/todo.dart';
import 'package:path/path.dart';

class hompage extends StatefulWidget {
  const hompage({super.key});

  @override
  State<hompage> createState() => _hompageState();
}

class _hompageState extends State<hompage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('note&todo'),
        actions: [
         IconButton(onPressed: (){
          setState(() {
            sqelhelper().deletallnote();
            sqelhelper().deletalltodo();
          });
         }, icon: Icon(Icons.delete))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map>>(
                  future: sqelhelper().loadnote(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                sqelhelper()
                                    .deletnote(snapshot.data![index]['id']);
                              },
                              child: Card(
                                color: Colors.amber,
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showeditd(context,snapshot.data![index]['title'],snapshot.data![index]['content'],snapshot.data![index]['id']);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    Text(
                                      ("id: ") + (snapshot.data![index]["id"]).toString(),
                                    ),
                                    Text(
                                      ("title: ") +
                                          (snapshot.data![index]["title"]).toString(),
                                    ),
                                    Text(
                                      ("content: ") +
                                          (snapshot.data![index]["content"]).toString(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),


 Expanded(
              child: FutureBuilder<List<Map>>(
                  future: sqelhelper().loadtodo(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            bool isdone=snapshot.data![index]['value']==0?false:true;
                            return Card(
                              color: isdone? Colors.purple:Colors.red[200],
                              child: Row(
                                children: [
                                 Checkbox(value: isdone, onChanged: (bool ? val){
                                  sqelhelper().updatcheck(snapshot.data![index]["id"],snapshot.data![index]["value"]).whenComplete(() => setState(() {
                                    
                                  }));
                                 }),
                               
                                  Text(
                                    ("title: ") +
                                        (snapshot.data![index]["title"]).toString(),
                                  ),
                                
                                ],
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),




          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "addtodo",
            onPressed: () {
              showd(context);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.pink,
          ),
          SizedBox(width: 15,),
          FloatingActionButton(
            tooltip: "addnote",
            onPressed: () {
              showtodo(context);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  void showd(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
            color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: Text("add new note"),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text("no"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("yes"),
                  onPressed: () {
                    sqelhelper()
                        .insertnote(
                          Note(
                              content: contentcontroller.text,
                              title: titlecontroller.text),
                        )
                        .whenComplete(() => setState(() {}));
                        titlecontroller.clear();
                        contentcontroller.clear();
                  },
                ),
              ],
              content: Column(
                children: [
                  TextField(
                    controller: titlecontroller,
                  ),
                  TextField(
                    controller: contentcontroller,
                  )
                ],
              ),
            ),
          );
        });
  }
//todo dialgo
void showtodo(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
                   color: Colors.white.withOpacity(0.3),
            child: CupertinoAlertDialog(
              title: Text("add new todo"),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text("no"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("yes"),
                  onPressed: () {
                    sqelhelper()
                        .inserttodo(
                          ToDo(
                              title: titlecontroller.text),
                        )
                        .whenComplete(() => setState(() {}));
                        titlecontroller.clear();
                        
                  },
                ),
              ],
              content: Column(
                children: [
                  TextField(
                    controller: titlecontroller,
                  ),
                
                ],
              ),
            ),
          );
        });
  }
  void showeditd(context,String title,String content,int id) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return Material(
            child: CupertinoAlertDialog(
              title: Text("edit new note"),

              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text("no"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(child: Text("yes"), onPressed: () {
sqelhelper().updatenote(Note(content: content, title: title,id: id)).whenComplete(() => setState(() {
  
}));

                }),
              ],
              content: Column(
                children: [
                TextFormField(
                  initialValue:title ,
                  onChanged: (val){
title=val;
                  },
                ),
                 TextFormField(
                  initialValue:content ,
                  onChanged: (val){
content=val;
                  },
                ),
                ],
              ),
            ),
          );
        });
  }
}
