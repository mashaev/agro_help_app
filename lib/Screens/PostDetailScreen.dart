import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../helpers/database_helper.dart';
import 'package:agro_help_app/resources/session.dart';

import '../models/Post.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  final String title;

  PostDetailScreen(this.postId, this.title);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final DatabaseHelper db = DatabaseHelper();
  Future<Post> futurePost;
  Future<List> futureFav;
  IconData icn;
  String save = 'save';

  @override
  initState() {
    super.initState();
    futurePost = db.getPostModelData(widget.postId);
    futureFav = db.getFavorite(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          fav(),
        ],
      ),
      body: FutureBuilder<Post>(
        future: futurePost,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          String title = snapshot.data.title;
          String desc = snapshot.data.description;
          if (session.getString('language') == 'ky') {
            title = snapshot.data.titleKy;
            desc = snapshot.data.descriptionKy;
          }

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: txtTitle(context, title, null),
              ),
              Padding(
                child: HtmlWidget(
                  desc,
                  webViewJs: false,
                  bodyPadding: EdgeInsets.all(0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              SizedBox(height: 30.0)
              //_likeBtn(),
              //Html(data: snapshot.data.description)
            ],
          );
        },
      ),
    );
  }

  /* Widget _likeBtn() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
        child: Row(
          children: <Widget>[
            FlatButton(
              color: Colors.grey[200],
              child: Text(Strings.t(save)),
              onPressed: like,
            ),
            SizedBox()
          ],
        ));
  } */

  void like() {
    Future<int> savef = db.saveFavorite(widget.postId);
    savef.then((v) {
      setState(() {
        if (v == 1) {
          icn = Icons.star;
          save = 'saved';
        } else {
          icn = Icons.star_border;
          save = 'save';
        }
      });
    });
  }

  Widget fav() {
    return FutureBuilder(
      future: futureFav,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          if (icn == null) {
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                if (snapshot.data.length > 0) {
                  icn = Icons.star;
                  save = 'saved';
                } else {
                  icn = Icons.star_border;
                }
              });
            });
          }
          return IconButton(
            icon: Icon(icn),
            onPressed: like,
          );
        }
        return Container(width: 0.0, height: 0.0);
      },
    );
  }
}
