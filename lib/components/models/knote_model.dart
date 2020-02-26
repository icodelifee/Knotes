import 'package:knotes/components/repositories/database_creator.dart';

class KnoteModel {
  String title, content;

  KnoteModel(this.title, this.content);
  
  KnoteModel.fromJSON(Map<String, dynamic> json) {
    this.title  = json[DatabaseCreator.title];
    this.content = json[DatabaseCreator.content];
  }
}