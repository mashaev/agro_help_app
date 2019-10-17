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

  @override
  initState() {
    super.initState();
    futurePost = db.getPostCategoryModelData(widget.postId);
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

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: txtTitle(context, snapshot.data.title, null),
              ),
              Padding(
                child: HtmlWidget(
                  snapshot.data.description,
                  webViewJs: false,
                  bodyPadding: EdgeInsets.all(0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
                  child: FlatButton.icon(
                    icon: Icon(icn),
                    color: Colors.blue,
                    label: Text('Like'),
                    onPressed: like,
                  )),
              //Html(data: snapshot.data.description)
            ],
          );
        },
      ),
    );
  }

  void like() {
    Future<int> save = db.saveFavorite(widget.postId);
    save.then((v) {
      print('v is $v');
      setState(() {
        if (v == 1) {
          icn = Icons.favorite;
        } else {
          icn = Icons.favorite_border;
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
            if (snapshot.data.length > 0) {
              cprint('db has');
              icn = Icons.favorite;
            } else {
              cprint('db empty');
              icn = Icons.favorite_border;
            }
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
