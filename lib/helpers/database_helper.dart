import 'dart:io';
import 'dart:async';

import 'package:agro_help_app/models/Category.dart';
import '../models/Post.dart';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "asset_database4.db");
    await deleteDatabase(path);

    // Load database from asset and copy
    ByteData data = await rootBundle.load(join('assets', 'agrohelp.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await new File(path).writeAsBytes(bytes);

    var theDb = await openDatabase(path, version: 1);
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
      sql =
          "UPDATE category SET title = '${cat.getTitle}', title_ky = '${cat.getTitleKy}', parent_id = ${cat.getparentId}, sort = ${cat.getSort}, updated_at = ${cat.getUpdatedAt} WHERE id = ${cat.getId}";
      dbCategory.rawUpdate(sql);
    }

    return true;
  }

  Future<List<Category>> getCategoryModelData(int parentId) async {
    var dbCategory = await db;
    String sql;
    // sql = "SELECT * FROM category WHERE parent_id = $parentId";

    sql = "SELECT * FROM category WHERE parent_id = $parentId";

    if (parentId == null)
      sql = "SELECT * FROM category WHERE parent_id IS NULL";

    var result = await dbCategory.rawQuery(sql);
    print('db_result');
    //print(result);
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
      print('db result.length is 0');
      return null;
    }

    print('db result max upd: ${result[0]['MAX(updated_at)']}');
    return result[0]['MAX(updated_at)'];
  }


   Future<bool> syncPostData(Post cat) async {
    var dbCategory = await db;

    String sql;
    sql = "SELECT * FROM post WHERE id = ${cat.getPostId}";
    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      dbCategory.insert("post", cat.toMap());
    } else {
      sql =
          "UPDATE category SET title = '${cat.getPostTitle}', title_ky = '${cat.getPostTitleKy}', category_id = ${cat.getPostCategoryId}, sort = ${cat.getPostSort}, updated_at = ${cat.getPostUpdatedAt} WHERE id = ${cat.getPostId}";
      dbCategory.rawUpdate(sql);
    }

    return true;
  }

  Future<List<Post>> getPostModelData(int categoryId) async {
    var dbCategory = await db;
    String sql;
    sql = "SELECT * FROM post WHERE category_id = $categoryId";

    var result = await dbCategory.rawQuery(sql);
    if (result.length == 0) {
      print("table is empty");
      return null;
    }
    List<Post> list = result.map((item) {
      return Post.fromMap(item);
    }).toList();

    //print(result);
    return list;
  }
}
