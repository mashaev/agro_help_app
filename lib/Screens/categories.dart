import 'dart:async';
import 'package:agro_help_app/helpers/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  DatabaseHelper dbHelper = DatabaseHelper();
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
    //cprint('categories initState');
    //db.initDb();
    // fetchSuccessful = fetchCategory() as bool;

    //dbHelper.test();
    sendDelete();
    localFetch();
    serverCtgsSaved = dbHelper.fetchCategory();
    dbHelper.fetchPost();
    dbHelper.fetchPostCategory();
  }

  Future<int> sendDelete() {
    dbHelper.deleteDeleted('post');
    dbHelper.deleteDeleted('post_category');
    return dbHelper.deleteDeleted('category');
  }

  void localFetch() {
    localCtgs = dbHelper.getCategoryModelData(widget.parentId);
  }

  Future<Null> _refreshCategories(BuildContext context) async {
    dbHelper.fetchCategory().then((val) {
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
    //cprint('categories build');
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.t('categories')),
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
            localCtgs = dbHelper.getCategoryModelData(widget.parentId);
          });
          localShowed = false;
        }
      });
      serverShowed = true;
    }

    return finalWidget;
  }

  Widget _listV(context, List<Category> ctgs) {
    List<Widget> wlist = [const SizedBox(height: 5.0)];
    ctgs.forEach((item) {
      String title = item.getTitle;
      if (session.getString('language') == 'ky') {
        title = item.getTitleKy;
      }
      //String titleKy = item.getTitleKy;
      wlist.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: InkWell(
          child: Container(
              height: 100,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  new Opacity(
                    opacity: 0.4,
                    child: ClipRRect(
                      child: const ModalBarrier(
                          dismissible: false, color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: txtTitle(context, title, Colors.white)),
                  )
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                    //image: AssetImage("assets/images/a2.jpg"),
                    image: CachedNetworkImageProvider(
                        Endpoints.baseUrl + item.picture),
                    fit: BoxFit.cover),
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Screen2(item.getId, title)));
          },
        ),
      ));
    });
    wlist.add(const SizedBox(height: 5.0));
    return ListView(
      children: wlist,
    );
  }
}
