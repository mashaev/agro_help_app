import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';



import '../Screens/Screen2.dart';

import '../models/Category.dart';

import '../Screens/app_drawer.dart';

class Categories extends StatefulWidget {
  final int parentId;

  Categories(this.parentId);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesState();
  }
}

class _CategoriesState extends State<Categories> {
  DatabaseHelper db = DatabaseHelper();
  Future<List<Category>> localCtgs;
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
    localCtgs = db.getCategoryModelData(widget.parentId);

    serverCtgsSaved = db.fetchCategory();
  }

  Future<Null> _refreshCategories(BuildContext context) async {
    print('let runnnnnnnnnnn');
    db.fetchCategory().then((val) {
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
      drawer: AppDrawer(widget.parentId),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => _refreshCategories(context),
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
          localCtgs = db.getCategoryModelData(widget.parentId);
        });
        localShowed = false;
      });
      serverShowed = true;
    }

    return finalWidget;
  }

  Widget _listV(context, List<Category> ctg) {
    return ListView(
      children: ctg
          .map(
            (item) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: Container(
                  height: 100,
                  color: Colors.blue,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      item.getTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item.getTitleKy,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 30.0,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Screen2(item.getId, item.getTitle)));
                },
              ),
            ),
          )
          .toList(),
    );
  }
}


