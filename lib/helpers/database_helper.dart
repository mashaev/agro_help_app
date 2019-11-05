import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:agro_help_app/models/Category.dart';
import '../models/Post.dart';
import '../models/PostCategory.dart';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:agro_help_app/resources/session.dart';
import 'package:agro_help_app/helpers/endpoints.dart';
//import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
// Construct a file path to copy database to
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    cprint('initDB is run');

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "asset_database3.db");
    var exists = await databaseExists(path);
    //await deleteDatabase(path);
    if (!exists) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'agrohelp.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await Directory(databasesPath).create(recursive: true);
      await new File(path).writeAsBytes(bytes);
    }
    var theDb = await openDatabase(
      path,
      version: 1,
    );
    return theDb;
  }

  Future<bool> syncCategoryData(Category cat) async {
    var dbCategory = await db;

    String sql;
    sql = "SELECT * FROM category WHERE id = ${cat.getId}";
    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      dbCategory.insert("category", cat.toMap());
    } else {
      /* String ctgTitle = cat.getTitle.replaceAll("'", "''");
      String ctgTitleKy = cat.getTitleKy.replaceAll("'", "''");
      sql =
          "UPDATE category SET title = '$ctgTitle', title_ky = '$ctgTitleKy', parent_id = ${cat.getparentId}, sort = ${cat.getSort}, updated_at = ${cat.getUpdatedAt} WHERE id = ${cat.getId}";
      dbCategory.rawUpdate(sql); */

      dbCategory.update('category', cat.toMap(),
          where: 'id= ?', whereArgs: [cat.getId]);
    }

    return true;
  }

  Future<bool> fetchCategory() async {
    try {
      final result = await InternetAddress.lookup('agro.prosoft.kg');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        DatabaseHelper db = DatabaseHelper();
        Future<bool> saved;

        final int maxUpdatedAt = await db.getMaxTimestamp('category');

        final response = await http.get(
            'https://agro.prosoft.kg/api/categories/list?updated_later=$maxUpdatedAt');

        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          final result = json.decode(response.body);

          List resultList = result as List;
          if (resultList.length == 0) {
            cprint('nothing to update category');
            return false;
          }

          for (var item in resultList) {
            var cat = Category.fromJson(item);
            cprint('updated_value: ${cat.getTitle}');
            saved = db.syncCategoryData(cat);
            // saved.then((val) {});
          }

          return saved;
          /* return (result as List)
            .map<Category>((json) => new Category.fromJson(json))
            .toList(); */
        } else {
          // If that response was not OK, throw an error.
          return false;
        }
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<List<Category>> getCategoryModelData(int parentId) async {
    var dbCategory = await db;
    String sql;

    if (parentId == null) {
      sql = "SELECT * FROM category WHERE parent_id IS NULL";
    } else {
      sql = "SELECT * FROM category WHERE parent_id = $parentId";
    }

    var result = await dbCategory.rawQuery(sql);
    //cprint('getCategoryModelData($parentId) $result');

    if (result.length == 0) return null;

    List<Category> list = result.map((item) {
      return Category.fromMap(item);
    }).toList();

    //print(result);
    return list;
  }

  Future<int> getMaxTimestamp(String table) async {
    var dbCategory = await db;
    String sql;
    // sql = "SELECT * FROM category WHERE parent_id = $parentId";

    sql = "SELECT MAX(updated_at) FROM $table";

    var result = await dbCategory.rawQuery(sql);

    //print(result);
    if (result.length == 0) {
      cprint('db result.length is 0');
      return null;
    }

    cprint('db $table result max upd: ${result[0]['MAX(updated_at)']}');
    return result[0]['MAX(updated_at)'];
  }

  Future<bool> syncPostData(Post post) async {
    var dbCategory = await db;

    String sql;
    sql = "SELECT * FROM post WHERE id = ${post.getPostId}";
    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      dbCategory.insert("post", post.toMap());
    } else {
      /* sql = "UPDATE post SET name = '${post.getPostTitle}', name_ky = '${post.getPostTitleKy}'," +
          " content = ${post.getPostDescription}, content_ky = ${post.getPostDescriptionKy}," +
          " sort = ${post.getPostSort}, updated_at = ${post.getPostUpdatedAt} WHERE id = ${post.getPostId}";

       dbCategory.rawUpdate(sql); */
      dbCategory.update('post', post.toMap(),
          where: 'id= ?', whereArgs: [post.getPostId]);
    }

    return true;
  }

  Future<bool> fetchPost() async {
    try {
      final result = await InternetAddress.lookup('agro.prosoft.kg');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        DatabaseHelper db = DatabaseHelper();
        Future<bool> saved;

        final int maxUpdatedAt = await db.getMaxTimestamp('post');

        final response = await http.get(
            'https://agro.prosoft.kg/api/posts/list?updated_later=$maxUpdatedAt');

        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          final result = json.decode(response.body);

          List resultList = result as List;
          if (resultList.length == 0) {
            cprint('nothing to update post');
          }

          // print('fetched posts: ${resultList.first}');

          for (var item in resultList) {
            var cat = Post.fromMap(item);
            // print('updated_value: ${cat.getTitle}');
            saved = db.syncPostData(cat);
            // saved.then((val) {});
          }

          return saved;
          /* return (result as List)
            .map<Category>((json) => new Category.fromJson(json))
            .toList(); */
        } else {
          // If that response was not OK, throw an error.
          return null;
        }
      }
    } on SocketException catch (_) {
      return null;
    }
    return null;
  }

  // Future<List<Post>> getPostModelData(int categoryId) async {
  //   var dbCategory = await db;
  //   String sql;
  //   sql = "SELECT * FROM post WHERE id = $categoryId";

  //   var result = await dbCategory.rawQuery(sql);
  //   if (result.length == 0) {
  //     print("table is empty");
  //     return null;
  //   }
  //   List<Post> list = result.map((item) {
  //     return Post.fromMap(item);
  //   }).toList();

  //   //print(result);
  //   return list;
  // }

  Future<List<Post>> getPostCategoryModelList(int categoryId) async {
    var dbCategory = await db;
    String sql;
    sql =
        "SELECT *,p.id as pid FROM post p JOIN post_category pc ON pc.post_id = p.id WHERE pc.category_id = $categoryId";

    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      cprint("table is empty");
      return null;
    }
    //print('here12q: ${result[1]}');
    List<Post> list = result.map((item) {
      return Post.fromMap(item);
    }).toList();

    //print(result);
    return list;
  }

  Future<Post> getPostModelData(int postId) async {
    var dbCategory = await db;
    String sql;
    sql = "SELECT *,id as pid FROM post WHERE id = $postId";

    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      cprint("post table is empty $postId");
      return null;
    }
    // cprint('postId: $postId, result: $result');
    Post post = Post.fromMap(result[0]);

    //print(result);
    return post;
  }

  Future<bool> fetchPostCategory() async {
    try {
      final result = await InternetAddress.lookup('agro.prosoft.kg');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        DatabaseHelper db = DatabaseHelper();
        Future<bool> saved;

        final int maxUpdatedAt = await db.getMaxTimestamp('post_category');

        final response = await http.get(
            'https://agro.prosoft.kg/api/post-category/list?updated_later=$maxUpdatedAt');

        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          final result = json.decode(response.body);

          List resultList = result as List;
          if (resultList.length == 0) {
            cprint('nothing to update postCategory');
          }

          for (var item in resultList) {
            var postCtg = PostCategory.fromMap(item);
            // print('updated_value: ${cat.getTitle}');
            saved = db.syncPostCategoryData(postCtg);
            // saved.then((val) {});
          }

          return saved;
          /* return (result as List)
            .map<Category>((json) => new Category.fromJson(json))
            .toList(); */
        } else {
          // If that response was not OK, throw an error.
          return null;
        }
      }
    } on SocketException catch (_) {
      return null;
    }
    return null;
  }

  Future<bool> syncPostCategoryData(PostCategory postCtg) async {
    var dbCategory = await db;
    String sql;
    sql = "SELECT * FROM post_category WHERE id = ${postCtg.getPostCategoryId}";
    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      dbCategory.insert("post_category", postCtg.toMap());
    } else {
      sql =
          "UPDATE post_category SET category_id = '${postCtg.getCategoryId}', post_id = '${postCtg.getPostId}',  updated_at = ${postCtg.getPostCategoryUpdatedAt} WHERE id = ${postCtg.getPostCategoryId}";
      dbCategory.rawUpdate(sql);
    }

    return true;
  }

  Future<int> deleteDeleted(String tbl) async {
    Future<int> ret;
    try {
      final result = await InternetAddress.lookup('agro.prosoft.kg');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final int maxUpdatedAt = await getMaxTimestamp(tbl);
        //cprint('delete $maxUpdatedAt');

        final response = await http
            .get(Endpoints.deleted + '/list?updated_later=$maxUpdatedAt');

        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          final result = json.decode(response.body);

          List resultList = result as List;
          if (resultList.length == 0) {
            cprint('nothing to delete $tbl');
          } else {
            for (var item in resultList) {
              String fld = tbl + '_id';
              if (item[fld] != null) {
                cprint('delete ${item[fld]}');
                var myDb = await db;
                ret = myDb.delete(tbl, where: 'id = ?', whereArgs: [item[fld]]);
              }
            }
          }
        }
      }
    } on SocketException catch (_) {
      //cprint('socket exception');
    }
    return ret;
  }

  Future<int> saveFavorite(int postId) async {
    var myDb = await db;
    Future<int> ret;
    List list = await getFavorite(postId);
    if (list.length > 0) {
      myDb.rawDelete("DELETE FROM favorite WHERE post_id=$postId");
      ret = Future<int>.value(0);
    } else {
      myDb.rawInsert("INSERT INTO favorite VALUES(NULL,$postId)");
      ret = Future<int>.value(1);
    }

    return ret;
  }

  Future<List> getFavorite(int postId) async {
    var myDb = await db;
    return myDb.rawQuery("SELECT post_id FROM favorite WHERE post_id=$postId");
  }

  Future<List> getFavorites() async {
    var myDb = await db;
    return myDb.rawQuery(
        "SELECT f.post_id,p.name, p.name_ky FROM favorite f JOIN post p ON f.post_id=p.id");
  }

  void test() async {
    var dbc = await db;
    String sql;
    sql = "SELECT id, name FROM post";
    //sql = "SELECT id,picture FROM category WHERE parent_id IS NULL";
    //sql = "SELECT * FROM category WHERE parent_id = $parentId";

    var result = await dbc.rawQuery(sql);
    cprint('test $result');
  }

  void fake() async {
    var dbc = await db;
  }
}
