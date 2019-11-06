class Category {
  int id;
  int parentId;
  String title;
  String titleKy;
  int sort;
  int updatedAt;
  String picture;

  Category(
      {this.id,
      this.parentId,
      this.title,
      this.titleKy,
      this.sort,
      this.updatedAt,
      this.picture});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      parentId: json["parent_id"],
      title: json["name"],
      titleKy: json["name_ky"],
      // sort: json["sort"],
      sort: 0,
      updatedAt: json["updated_at"],
      picture: json["picture"],
    );
  }

  Category.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.parentId = obj["parent_id"];
    this.title = obj["title"];
    this.titleKy = obj["title_ky"];
    this.sort = obj["sort"];
    this.updatedAt = obj["updated_at"];
    this.picture = obj["picture"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["parent_id"] = parentId;
    map["title"] = title;
    map["title_ky"] = titleKy;
    map["sort"] = sort;
    map["updated_at"] = updatedAt;
    map["picture"] = picture;

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
  String get getPicture => picture;
  int get getSort => sort;
  int get getUpdatedAt => updatedAt;
}
