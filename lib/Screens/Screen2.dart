import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../Screens/Posts.dart';

import '../helpers/database_helper.dart';
import 'package:agro_help_app/resources/session.dart';

class Screen2 extends StatelessWidget {
  final int parentID;
  final String categoryTitle;

  Screen2(this.parentID, this.categoryTitle);

  final DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: FutureBuilder<List<Category>>(
        future: db.getCategoryModelData(parentID),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text(
                Strings.t('notFound'),
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            );

          return ListView(
            children: snapshot.data.map((item) {
              String title = item.getTitle;
              if (session.getString('language') == 'ky') {
                title = item.getTitleKy;
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      height: 120,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    var result = await db.getCategoryModelData(item.getId);
                    if (result != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Screen2(item.getId, title)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Posts(item.getId, title)));
                    }
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
