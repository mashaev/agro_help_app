// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import '../helpers/database_helper.dart';
// import 'package:http/http.dart' as http;

// import '../models/Post.dart';
// import '../Screens/PostDetailScreen.dart';

// class Posts extends StatefulWidget {
//   int categoryID;
//   String postTitle;

//   Posts(this.categoryID, this.postTitle);

//   @override
//   _PostsState createState() => _PostsState();
// }

// class _PostsState extends State<Posts> {
//   DatabaseHelper db = DatabaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.postTitle),
//       ),
//       body: FutureBuilder<List<Post>>(
//         // future: db.getPostModelData(categoryID),
//         future: db.getPostModelData(widget.categoryID),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(
//               child: Center(
//                 child: Text(
//                   'Нету Поста!',
//                   style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );

//           return ListView(
//             children: snapshot.data
//                 .map((item) => ListTile(
//                       onTap: () {
//                         db.getPostModelData(item.id);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PostDetailScreen(
//                               item.categoryId,
//                               item.getPostTitle,
//                               item.getPostDescription,
//                             ),
//                           ),
//                         );
//                       },
//                       title: Text(item.getPostTitle),
//                     ))
//                 .toList(),
//           );
//         },
//       ),
//     );
//   }
// }




// Future<bool> fetchPost() async {
//   try {
//     final result = await InternetAddress.lookup('agro.prosoft.kg');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       DatabaseHelper db = DatabaseHelper();
//       Future<bool> saved;

//       final int maxUpdatedAt = await db.getMaxTimestamp('post');

//       final response = await http.get(
//           'https://agro.prosoft.kg/api/posts/list?updated_later=$maxUpdatedAt');

//       if (response.statusCode == 200) {
//         // If server returns an OK response, parse the JSON
//         final result = json.decode(response.body);

//         List resultList = result as List;
//         if (resultList.length == 0) {
//           print('nothing to update');
//         }

//         for (var item in resultList) {
//           var cat = Post.fromMap(item);
//           // print('updated_value: ${cat.getTitle}');
//           saved = db.syncPostData(cat);
//           // saved.then((val) {});
//         }

//         return saved;
//         /* return (result as List)
//             .map<Category>((json) => new Category.fromJson(json))
//             .toList(); */
//       } else {
//         // If that response was not OK, throw an error.
//         return null;
//       }
//     }
//   } on SocketException catch (_) {
//     return null;
//   }
//   return null;
// }
