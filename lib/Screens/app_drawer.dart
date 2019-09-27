import 'package:flutter/material.dart';
import './categories.dart';
import './Posts.dart';

class AppDrawer extends StatelessWidget {

  final int drawerId;

  const AppDrawer(this.drawerId);


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
}
