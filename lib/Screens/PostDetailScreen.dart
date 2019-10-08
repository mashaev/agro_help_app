import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';

import '../models/PostCategory.dart';

class PostDetailScreen extends StatelessWidget {
  int postId;
  String title;
  String description;

  PostDetailScreen(this.postId, this.title, this.description);

  DatabaseHelper db = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<PostCategory>>(
        future: db.getPostCategoryModelData(postId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          height: 150,
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
