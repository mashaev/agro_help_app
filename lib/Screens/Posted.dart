import 'dart:async';

import 'package:agro_help_app/models/post_category.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';




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
  Future<List<PostCategory>> localPostCtgs;
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
     db.initDb();
    // fetchSuccessful = fetchCategory() as bool;
    localPostCtgs = db.getPostCategoryModelData(widget.categoryID);

    serverCtgsSaved = db.fetchPost();

    db.fetchPostCategory();

   
  }

  Future<Null> _refreshPost(BuildContext context) async {
    print('let runnnnnnnnnnn');
    db.fetchPost().then((val) {
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
        title: Text('Post'),
      ),
      
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => _refreshPost(context),
          child: _showBody(context)),
    );
  }
  
  Widget _showBody(BuildContext context) {
    if (!localShowed) {
      localPostCtgs.then((lctg) {
        setState(() {
          finalWidget = _listV(context, lctg);
        });
      });
      localShowed = true;
    }

    if (!serverShowed) {
      serverCtgsSaved.then((saved) {
        setState(() {
          localPostCtgs = db.getPostCategoryModelData(widget.categoryID);
        });
        localShowed = false;
      });
      serverShowed = true;
    }
   
    return finalWidget;
  }

  Widget _listV(context, List<PostCategory> ctg) {
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
                        widget.postTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        //item.getPostTitleKy,
                        'asdf',
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

