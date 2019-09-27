import 'dart:convert';

// Category categoryFromJson(String str) {
//     final jsonData = json.decode(str);
//     return Category.fromJson(jsonData);
// }

// String categoryToJson(Category data) {
//     final dyn = data.toJson();
//     return json.encode(dyn);
// }

// Future<http.Response> fetchCategory() {
//   return http.get('https://jsonplaceholder.typicode.com/posts/1');
// }

class Category {
  int id;
  int parentId;
  String title;
  String titleKy;
  int sort;
  int updated_at;

  Category({
    this.id,
    this.parentId,
    this.title,
    this.titleKy,
    this.sort,
    this.updated_at,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      parentId: json["parent_id"],
      title: json["name"],
      titleKy: json["name_ky"],
      // sort: json["sort"],
      sort: 0,
      updated_at: json["updated_at"],
    );
  }

  Category.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.parentId = obj["parent_id"];
    this.title = obj["title"];
    this.titleKy = obj["title_ky"];
    this.sort = obj["sort"];
    this.updated_at = obj["updated_at"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["parent_id"] = parentId;
    map["title"] = title;
    map["title_ky"] = titleKy;
    map["sort"] = sort;
    map["updated_at"] = updated_at;

    return map;
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "parent_id": parentId,
  //       "title": title,
  //       "title_ky": titleKy,
  //       "sort": sort,
  //     };

  int get getId => id;
  int get getparentId => parentId;
  String get getTitle => title;
  String get getTitleKy => titleKy;
  int get getSort => sort;
  int get getUpdatedAt => updated_at;
}
