import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:knotes/components/models/DynamicTheme.dart';
import 'package:knotes/components/models/knote_model.dart';
import 'package:knotes/components/repositories/RepositoryServiceKnote.dart';
import 'package:knotes/screens/modules/empty_list.dart';
import 'package:knotes/screens/note_taking_screen.dart';
import 'package:knotes/components/repositories/theme_repository/textField_custom_theme.dart'
    as ct;

import 'modules/single_knote.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<KnoteModel>> _future;

  UniqueKey _cardKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _getFuture();
  }

  _getFuture() {
    setState(() {
      _future = RepositoryServiceKnote.getAllKnotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Text("Knotes"),
            ),
          ),
          FutureBuilder<List<KnoteModel>>(
            future: RepositoryServiceKnote.getAllKnotes(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return _getKnotes(snapshot);
              // snapshot.data.map((knote) => _buildList(knote)).toList());
              else
                return EmptyList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          PageTransition(
            child: NoteTakingScreen(),
            type: PageTransitionType.rippleRightUp,
            curve: Curves.easeInOut,
            duration: Duration(
              milliseconds: 300,
            ),
            alignment: Alignment.bottomRight,
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(KnoteModel knoteModel, int index) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Card(
        child: InkWell(
          onLongPress: () {
            print("Long press");
            showModalBottomSheet(
              // backgroundrColor: Colors.grey,
              context: context,
              builder: (context) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0,
                ),
                child: Center(
                  child: InkWell(
                    onTap: () async =>
                        await RepositoryServiceKnote.deleteKnote(knoteModel)
                            .then((value) {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 5.0,
                        ),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                height: 100.0,
              ),
            );
          },
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: SingleKnote(index + 1, knoteModel),
                type: PageTransitionType.transferUp,
                duration: Duration(
                  milliseconds: 400,
                ),
              ),
              // MaterialPageRoute(
              //   fullscreenDialog: true,
              //   builder: (context) => SingleKnote(index + 1, knoteModel),
              // ),
            );
          },
          // highlightColor: Colors.black,
          // splashColor: Colors.grey,
          focusColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    "${knoteModel.title}",
                    style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Text(
                      "${knoteModel.content}",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontFamily: 'NexaLight',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     IconButton(
                //       onPressed: null,
                //       icon: Icon(Icons.edit),
                //     ),
                //     IconButton(
                //       onPressed: null,
                //       icon: Icon(Icons.delete),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getKnotes(AsyncSnapshot<List<KnoteModel>> snapshot) {
    return SliverGrid.count(
      key: _cardKey,
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      // crossAxisSpacing: 10.0,
      // mainAxisSpacing: 10.0,
      children: List.generate(
        snapshot.data.length,
        (index) {
          _buildList(snapshot.data[index], index);
        },
      ),
    );
  }
}
