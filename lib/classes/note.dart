class Note{
  final int ?id;
  final String content;
  final String title;
  Note({required this.content, this.id,required this.title});
   Map<String,dynamic> tomap(){
    return {
      "id":id,
      "title":title,
      "content":content
    };
   }
}