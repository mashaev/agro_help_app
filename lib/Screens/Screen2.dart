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
              child: grey18(Strings.t('notFound')),
            );

          List<Widget> wlist = [const SizedBox(height: 5.0)];
          String lng = session.getString('language');
          snapshot.data.forEach((item) {
            String title;
            if (lng == 'ky') {
              title = item.getTitleKy;
            } else {
              title = item.getTitle;
            }
            wlist.add(Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    height: 100,
                    color: clr(context, 'accent'),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: txtTitle(context, title, Colors.white),
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
                            builder: (context) => Screen2(item.getId, title)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Posts(item.getId, title)));
                  }
                },
              ),
            ));
          });

          wlist.add(const SizedBox(height: 5.0));
          return ListView(
            children: wlist,
          );
        },
      ),
    );
  }
}
