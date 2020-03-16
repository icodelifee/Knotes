import 'package:knotes/components/models/knote_model.dart';
import 'package:knotes/components/repositories/database_creator.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryServiceKnote {
  static Future<List<KnoteModel>> getAllKnotes() async {
    final sql = '''select * from ${DatabaseCreator.knotes_table}''';

    final data = await db.rawQuery(sql);

    List<KnoteModel> knotes = List();
    KnoteModel knote;

    for (final node in data) {
      knote = KnoteModel.fromJSON(node);
      knotes.add(knote);
    }
    return knotes;
  }

  static Future<KnoteModel> getKnote(String id) async {
    final sql =
        '''select * from ${DatabaseCreator.knotes_table} where ${DatabaseCreator.id} == $id''';

    final data = await db.rawQuery(sql);

    final knote = KnoteModel.fromJSON(data[0]);

    return knote;
  }

  static Future<void> addTempData(KnoteModel knoteModel) async {
    final sql = '''insert into ${DatabaseCreator.temp_table} (
      ${DatabaseCreator.title},
      ${DatabaseCreator.content}
    )
    values(
      ?,?
    )''';

    List<dynamic> params = [knoteModel.title, knoteModel.content];

    final sql2 = '''DELETE FROM ${DatabaseCreator.temp_table}''';

    Batch batch = db.batch();
    batch.execute(sql2);
    batch.execute(sql, params);

    await batch.commit();
    print(params);
  }

  static Future<KnoteModel> getTempData() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.temp_table}''';

    final data = await db.rawQuery(sql);
    KnoteModel knoteModel;
    if (data.isEmpty) {
      knoteModel = KnoteModel("", "", "");
      return knoteModel;
    }
    knoteModel = KnoteModel.fromJSON(data[0]);

    print(knoteModel.title + " " + knoteModel.content);

    return knoteModel;
  }

  static Future<void> addKnote(KnoteModel knoteModel) async {
    final sql = '''insert into ${DatabaseCreator.knotes_table} (
      '${DatabaseCreator.id}',
      '${DatabaseCreator.title}',
      '${DatabaseCreator.content}'
    ) 
    values(?,?,?)''';
    List<dynamic> params = [
      knoteModel.id,
      knoteModel.title,
      knoteModel.content
    ];
    final sql2 = '''DELETE FROM ${DatabaseCreator.temp_table}''';

    Batch batch = db.batch();
    batch.execute(sql, params);
    batch.execute(sql2);

    await batch.commit();
  }

  static Future<void> updateKnote(KnoteModel knoteModel) async {
    final sql =
        '''update ${DatabaseCreator.knotes_table} set ${DatabaseCreator.title} = ? and ${DatabaseCreator.content} = ? id = ?''';

    List<dynamic> params = [
      knoteModel.title,
      knoteModel.content,
      knoteModel.id
    ];

    await db.rawUpdate(sql, params);
  }

  static Future<void> updateTitleKnote(String id, String value) async {
    final sql =
        '''update ${DatabaseCreator.knotes_table} set ${DatabaseCreator.title} = ? where id = ?''';

    List<dynamic> params = [value, id];

    await db.rawUpdate(sql, params);

    print("Success!");
  }

  static Future<void> updateContentKnote(String id, String value) async {
    final sql =
        '''update ${DatabaseCreator.knotes_table} set ${DatabaseCreator.content} = ? where id = ?''';

    List<dynamic> params = [value, id];

    await db.rawUpdate(sql, params);
    print("Success!");
  }

  static Future<void> deleteKnote(KnoteModel knoteModel) async {
    Batch _batch = db.batch();
    final sql =
        '''delete from ${DatabaseCreator.knotes_table} where ${DatabaseCreator.id} = ?''';
    List<dynamic> params = [knoteModel.id];

    _batch.execute(sql, params);

    await _batch.commit();
  }

  static Future<int> knotesCount() async {
    final data = await db
        .rawQuery('''select count(*) from ${DatabaseCreator.knotes_table}''');

    int count = data[0].values.elementAt(0);

    return count;
  }
}
