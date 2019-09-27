import 'dart:convert';



class Post {
  int id;
  int categoryId;
  String title;
  String titleKy;
  String description;
  String descriptionKy;
  int sort;
  String related;
  int updatedAt;


   Post(
     this.id,
     this.categoryId,
     this.title,
     this.titleKy,
     this.description,
     this.descriptionKy,
     this.sort,
     this.related,
     this.updatedAt
   );

 int get  getPostId => id;
 int get getPostCategoryId => categoryId;
 String get getPostTitle => title;
 String get getPostTitleKy => titleKy;
 String get getPostDescription => description;
 String get getPostDescriptionKy => descriptionKy;
 int get getPostSort => sort;
 String get getPostRelated => related; 
 int get getPostUpdatedAt => updatedAt;
 

 Post.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.categoryId = obj["category_id"];
    this.title = obj["title"];
    this.titleKy = obj["title_ky"];
    this.description = obj["description"];
    this.descriptionKy = obj["description_ky"];
    this.sort = obj["sort"];
    this.related = obj["related"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["category_id"] = categoryId;
    map["title"] = title;
    map["title_ky"] = titleKy;
    map["description"] = description;
    map["description_ky"] = descriptionKy;
    map["sort"] = sort;
    map["related"] = related;
    map["updated_at"] = updatedAt;

    return map;
  }

}