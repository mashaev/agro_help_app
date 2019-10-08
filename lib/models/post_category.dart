import 'dart:convert';

class PostCategory {
  int id;
  int postId;
  int categoryId;
  int updatedAt;

  PostCategory(
    this.id,
    this.postId,
    this.categoryId,
    this.updatedAt,
  );

  int get getPostCategoryId => id;
  int get getPostId => postId;
  int get getCategoryId => categoryId;

  int get getPostCategoryUpdatedAt => updatedAt;

  PostCategory.fromMap(dynamic obj) {
    this.id = obj["post_category_id"];
    this.postId = obj["post_id"];
    this.categoryId = obj["category_id"];
    this.updatedAt = obj["updated_at"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["post_id"] = postId;
    map["category_id"] = categoryId;
    map["updated_at"] = updatedAt;

    return map;
  }

 


}
