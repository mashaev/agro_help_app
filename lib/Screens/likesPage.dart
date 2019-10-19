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
    String tfield = 'name';
    if (session.getString('language') == 'ky') {
      tfield = 'name_ky';
    }
    return ListView(
      children: ctg
          .map(
            (item) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    height: 150,
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(
                        item[tfield],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
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
          )
          .toList(),
    );
  }
}
