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
        child: Text(
          Strings.t('notFound'),
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      );
    }
    return ListView(
      children: ctg.map((item) {
        String title = item.getPostTitle;
        if (session.getString('language') == 'ky') {
          title = item.getPostTitleKy;
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                height: 150,
                color: Colors.blue,
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(item.id, title),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
