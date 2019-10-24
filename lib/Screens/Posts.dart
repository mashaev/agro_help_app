import 'dart:async';
import 'package:agro_help_app/Screens/PostDetailScreen.dart';

import '../models/Post.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import 'package:agro_help_app/resources/session.dart';

class Posts extends StatefulWidget {
  final int categoryID;
  final String categoryTitle;

  Posts(this.categoryID, this.categoryTitle);

  @override
  State<StatefulWidget> createState() {
    return _PostsState();
  }
}

class _PostsState extends State<Posts> {
  DatabaseHelper db = DatabaseHelper();
  Future<List<Post>> localPostCtgs;
  Widget finalWidget = Center(child: CircularProgressIndicator());

  @override
  initState() {
    super.initState();
    localPostCtgs = db.getPostCategoryModelList(widget.categoryID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: _showBody(context),
    );
  }

  Widget _showBody(BuildContext context) {
    localPostCtgs.then((lctg) {
      setState(() {
        finalWidget = _listV(context, lctg);
      });
    });
    return finalWidget;
  }

  Widget _listV(context, List<Post> ctg) {
    if (ctg == null || ctg.length == 0) {
      return Center(
        child: grey18(Strings.t('notFound')),
      );
    }
    List<Widget> wlist = [const SizedBox(height: 5.0)];
    ctg.forEach((item) {
      String title = item.getPostTitle;
      if (session.getString('language') == 'ky') {
        title = item.getPostTitleKy;
      }
      wlist.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: txtSubhead(context, title, clr(context, 'primary')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(item.id, title),
                ),
              );
            },
          ),
        ),
      ));
    });
    wlist.add(const SizedBox(height: 5.0));
    return ListView(
      children: wlist,
    );
  }
}
