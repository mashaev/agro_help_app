import 'package:flutter/material.dart';
import './categories.dart';
import 'package:agro_help_app/Screens/likesPage.dart';
import 'package:agro_help_app/resources/session.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Agro Helper!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Categories(0)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Post'),
            // onTap: () {
            //   Navigator.of(context).pushReplacementNamed(
            //     OrdersScreen.routeName,
            //   );
            // },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Likes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LikesPage()));
            },
          ),
          Divider(),
          selectLang(context),
          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: Text('Manage Products'),
          //   // onTap: () {
          //   //   Navigator.of(context).pushReplacementNamed(
          //   //     UserProductsScreen.routeName,
          //   //   );
          //   // },
          // ),
          //  Divider(),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   // onTap: () {
          //   //   Navigator.of(context).pop();
          //   //   Navigator.of(context).pushReplacementNamed('/');
          //   //   // Navigator.of(context).pushReplacementNamed(
          //   //   //   UserProductsScreen.routeName,
          //   //   // );
          //   //   Provider.of<Auth>(context,listen: false).logout();
          //   // },
          // ),
        ],
      ),
    );
  }

  Widget selectLang(BuildContext context) {
    String lang = session.getString('language') ?? 'ru';
    String lang2, lang2Label;
    if (lang == 'ky') {
      lang2 = 'ru';
      lang2Label = 'Русский';
    } else {
      lang2 = 'ky';
      lang2Label = 'Кыргызча';
    }
    return ListTile(
      leading: Icon(Icons.translate),
      title: Text(lang2Label),
      onTap: () {
        session.setString('language', lang2);
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Categories', (Route<dynamic> route) => false);
      },
    );
  }
}
