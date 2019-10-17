import 'dart:async';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../Screens/Screen2.dart';
import '../models/Category.dart';
import '../Screens/app_drawer.dart';
import 'package:agro_help_app/resources/session.dart';

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
    //db.initDb();
    // fetchSuccessful = fetchCategory() as bool;

    db.test();
    sendDelete();
    localFetch();
    serverCtgsSaved = db.fetchCategory();
    db.fetchPost();
    db.fetchPostCategory();
    String lang = session.getString('language') ?? 'ru';
    cprint('lang $lang');
  }

  Future<int> sendDelete() {
    db.deleteDeleted('post');
    db.deleteDeleted('post_category');
    return db.deleteDeleted('category');
  }

  void localFetch() {
    localCtgs = db.getCategoryModelData(widget.parentId);
  }

  Future<Null> _refreshCategories(BuildContext context) async {
    db.fetchCategory().then((val) {
      cprint('refres');
      var del = sendDelete();
      del.then((v) {
        localFetch();
        setState(() {
          localShowed = false;
        });
      });
      //_showBody(context);
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
      drawer: AppDrawer(),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () => _refreshCategories(context),
          child: _showBody(context)),
    );
  }

  Widget _showBody(BuildContext context) {
    if (!localShowed) {
      localCtgs.then((lctg) {
        if (lctg != null) {
          setState(() {
            finalWidget = _listV(context, lctg);
          });
        }
      });
      localShowed = true;
    }

    if (!serverShowed) {
      serverCtgsSaved.then((saved) {
        if (saved) {
          setState(() {
            localCtgs = db.getCategoryModelData(widget.parentId);
          });
          localShowed = false;
        }
      });
      serverShowed = true;
    }

    return finalWidget;
  }

  Widget _listV(context, List<Category> ctg) {
    return ListView(
      children: ctg.map(
        (item) {
          String title = item.getTitle;
          //String titleKy = item.getTitleKy;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              child: Container(
                height: 100,
                color: Colors.blue,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: txtSubhead(context, title, Colors.white),
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
          );
        },
      ).toList(),
    );
  }
}
