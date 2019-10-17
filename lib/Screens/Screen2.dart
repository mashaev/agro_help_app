import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../Screens/Posts.dart';

import '../helpers/database_helper.dart';

class Screen2 extends StatelessWidget {
  int parentID;
  String categoryTitle;

  Screen2(this.parentID, this.categoryTitle);

  DatabaseHelper db = DatabaseHelper();

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
                'Нету Категории!',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            );

          return ListView(
            children: snapshot.data
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          height: 120,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              item.getTitle,
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
                                      Screen2(item.getId, item.title)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Posts(item.getId, item.title)));
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
