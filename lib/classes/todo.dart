class ToDo{
  final int ?id;
  final int? value;
  final String title;
  ToDo({ this.value=0, this.id,required this.title});
  Map<String,dynamic> tomap(){
    return {
      "id":id,
      "title":title,
      "value":value
    };
   }
}