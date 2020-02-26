import 'package:knotes/components/repositories/database_creator.dart';

class KnoteModel {
  String id, title, content;

  KnoteModel(this.id, this.title, this.content);
  
  KnoteModel.fromJSON(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.title  = json[DatabaseCreator.title];
    this.content = json[DatabaseCreator.content];
  }
}