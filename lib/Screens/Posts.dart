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
  DatabaseHelper dbHelper = DatabaseHelper();
  Future<List<Post>> localPostCtgs;
  Widget finalWidget = Center(child: CircularProgressIndicator());
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool postsShowed = false;

  @override
  initState() {
    super.initState();
    localPostCtgs = dbHelper.getPostCategoryModelList(widget.categoryID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => _refreshPosts(context),
          child: _showBody(context)),
      backgroundColor: Colors.grey[350],
    );
  }

  Widget _showBody(BuildContext context) {
    if (!postsShowed) {
      localPostCtgs.then((lctg) {
        cprint('db then $lctg');
        setState(() {
          finalWidget = _listV(context, lctg);
          postsShowed = true;
        });
      });
    }
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
              color: Colors.white),
          child: ListTile(
            title: txtSubhead(context, title, clr(context, 'primary')),
            onTap: () {
              cprint('item.id ${item.id}');
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

  Future<Null> _refreshPosts(BuildContext context) async {
    cprint('refresh');
    dbHelper.deleteDeleted('post');
    dbHelper.deleteDeleted('post_category');
    Future<bool> server = dbHelper.fetchPost();
    Future<bool> server2 = dbHelper.fetchPostCategory();
    server.then((_) {
      server2.then((_) {
        setState(() {
          cprint('set state on refresh');
          localPostCtgs = dbHelper.getPostCategoryModelList(widget.categoryID);
          postsShowed = false;
        });
      });
    });
    return;
  }
}
