import 'package:agro_help_app/Screens/PostDetailScreen.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import 'package:agro_help_app/resources/session.dart';

class LikesPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.t('saveds')),
      ),
      body: _showBody(context),
    );
  }

  Widget _showBody(BuildContext context) {
    return FutureBuilder(
      future: dbHelper.getFavorites(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _listV(context, snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listV(context, List ctg) {
    if (ctg.length == 0) {
      return Center(
        child: Text(
          Strings.t('notFound'),
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      );
    }
    List<Widget> wlist = [const SizedBox(height: 5.0)];

    String tfield = 'name';
    if (session.getString('language') == 'ky') {
      tfield = 'name_ky';
    }
    ctg.forEach((item) {
      wlist.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: txtSubhead(context, item[tfield], clr(context, 'primary')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PostDetailScreen(item['post_id'], item[tfield]),
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
}
