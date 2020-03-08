import 'package:flutter/material.dart';
import 'package:knotes/components/models/knote_model.dart';
import 'package:knotes/components/repositories/RepositoryServiceKnote.dart';
import 'package:knotes/components/repositories/theme_repository/textField_custom_theme.dart'
    as ct;

class SingleKnote extends StatefulWidget {
  KnoteModel knoteModel;

  SingleKnote(this.knoteModel);

  @override
  _SingleKnoteState createState() => _SingleKnoteState();
}

class _SingleKnoteState extends State<SingleKnote> {
  TextEditingController _titleController = TextEditingController();

  TextEditingController _contentController = TextEditingController();

  bool _displayFloatingButton;

  @override
  void initState() {
    super.initState();
    _displayFloatingButton = false;
    _titleController.text = widget.knoteModel.title;
    _contentController.text = widget.knoteModel.content;

    //print("Tapping on ${widget.id}!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(230, 230, 230, 1.0),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: MediaQuery.of(context).padding,
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  cursorWidth: 3.0,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Title',
                    hintStyle: ct.titleHint_singleKnote,
                    focusedBorder: InputBorder.none,
                  ),
                  style: (MediaQuery.of(context).platformBrightness ==
                          Brightness.dark)
                      ? ct.title_singleKnote_Dark
                      : ct.title_singleKnote,
                  maxLines: null,
                  onChanged: (value) => _onTitleChanged(value),
                ),
                TextField(
                  controller: _contentController,
                  cursorColor: Colors.black,
                  cursorWidth: 2.0,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    border: InputBorder.none,
                    hintText: 'Knotes',
                    hintStyle: ct.contentHint_singleKnote,
                    focusedBorder: InputBorder.none,
                  ),
                  style: (MediaQuery.of(context).platformBrightness ==
                          Brightness.dark)
                      ? ct.content_singleKnote_Dark
                      : ct.content_singleKnote  ,
                  maxLines: null,
                  onChanged: (value) => _onContentChanged(value),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _displayFloatingButton
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  height: 10.0,
                ),
                //sFloatingActionButton(onPressed: null),
              ],
            )
          : null,
    );
  }

  _displayFloatingButtonWidget() {
    setState(() {
      _displayFloatingButton = true;
    });
  }

  _onTitleChanged(String value) async {
    _displayFloatingButtonWidget();

    print("Changing value : $value");

    await RepositoryServiceKnote.updateTitleKnote(widget.knoteModel.id, value);
  }

  _onContentChanged(String value) async {
    _displayFloatingButtonWidget();

    print("Changing value : $value");

    await RepositoryServiceKnote.updateContentKnote(
        widget.knoteModel.id, value);
  }
}
