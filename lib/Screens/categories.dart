import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

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

    serverCtgsSaved = fetchCategory();
  }

  Future<Null> _refreshCategories(BuildContext context) async {
    print('let runnnnnnnnnnn');
    fetchCategory().then((val) {
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
                        item.getTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.getTitleKy,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
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

Future<bool> fetchCategory() async {
  try {
    final result = await InternetAddress.lookup('agro.prosoft.kg');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      DatabaseHelper db = DatabaseHelper();
      Future<bool> saved;

      final int maxUpdatedAt = await db.getMaxTimestamp('category');

      final response = await http.get(
          'https://agro.prosoft.kg/api/categories/list?updated_later=$maxUpdatedAt');

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        final result = json.decode(response.body);

        List resultList = result as List;
        if (resultList.length == 0) {
          print('nothing to update');
        }

        for (var item in resultList) {
          var cat = Category.fromJson(item);
          print('updated_value: ${cat.getTitle}');
          saved = db.syncCategoryData(cat);
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
