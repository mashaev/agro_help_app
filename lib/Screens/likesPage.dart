import 'package:agro_help_app/Screens/PostDetailScreen.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';

class LikesPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Likes'),
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
        child: Text('netu likov'),
      );
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
                        item['name'],
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
                          PostDetailScreen(item['post_id'], item['name']),
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
