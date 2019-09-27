import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/Post.dart';

class Posted extends StatefulWidget {
 int categoryID;
  String postTitle;

  Posted(this.categoryID, this.postTitle);

  @override
  State<StatefulWidget> createState() {
    return _PostedState();
  }
}



class _PostedState extends State<Posted> {
  DatabaseHelper db = DatabaseHelper();
  Future<List<Post>> localCtgs;
  Future<bool> serverCtgsSaved;
  bool fetchSuccessful = false;

  // List<Category> list = [];
  bool localShowed = false;
  bool serverShowed = false;
  Widget finalWidget = Center(child: CircularProgressIndicator());

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  initState() {
    super.initState();
    // db.initDb();
    // fetchSuccessful = fetchCategory() as bool;
    localCtgs = db.getPostModelData(widget.categoryID);

    serverCtgsSaved = fetchPost();
  }

  Future<Null> _refreshPost(BuildContext context) async {
    print('let runnnnnnnnnnn');
    fetchPost().then((val) {
      serverShowed = false;
      _showBody(context);
    });

    return;
  }

  // localCtgs = serverCtgs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
      ),
      
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => _refreshPost(context),
          child: _showBody(context)),
    );
  }
  
  Widget _showBody(BuildContext context) {
    if (!localShowed) {
      localCtgs.then((lctg) {
        setState(() {
          finalWidget = _listV(context, lctg);
        });
      });
      localShowed = true;
    }

    if (!serverShowed) {
      serverCtgsSaved.then((saved) {
        setState(() {
          localCtgs = db.getPostModelData(widget.categoryID);
        });
        localShowed = false;
      });
      serverShowed = true;
    }

    return finalWidget;
  }

  Widget _listV(context, List<Post> ctg) {
    return ListView(
      children: ctg
          .map(
            (item) =>  Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    height: 150,
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(
                        item.getPostTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.getPostTitleKy,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             Screen2(item.getId, item.getTitle)));
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

Future<bool> fetchPost() async {
  try {
    final result = await InternetAddress.lookup('agro.prosoft.kg');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      DatabaseHelper db = DatabaseHelper();
      Future<bool> saved;

      final int maxUpdatedAt = await db.getMaxTimestamp('post');

      final response = await http.get(
          'https://agro.prosoft.kg/api/posts/list?updated_later=$maxUpdatedAt');

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        final result = json.decode(response.body);

        List resultList = result as List;
        if (resultList.length == 0) {
          print('nothing to update');
        }

        for (var item in resultList) {
          var cat = Post.fromMap(item);
          // print('updated_value: ${cat.getTitle}');
          saved = db.syncPostData(cat);
          // saved.then((val) {});
        }

        return saved;
        /* return (result as List)
            .map<Category>((json) => new Category.fromJson(json))
            .toList(); */
      } else {
        // If that response was not OK, throw an error.
        return null;
      }
    }
  } on SocketException catch (_) {
    return null;
  }
  return null;
}