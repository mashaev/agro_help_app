class Post {
  int id;
  String title;
  String titleKy;
  String description;
  String descriptionKy;
  int sort;

  int updatedAt;

  Post(this.id, this.title, this.titleKy, this.description, this.descriptionKy,
      this.sort, this.updatedAt);

  int get getPostId => id;
  String get getPostTitle => title;
  String get getPostTitleKy => titleKy;
  String get getPostDescription => description;
  String get getPostDescriptionKy => descriptionKy;
  int get getPostSort => sort;

  int get getPostUpdatedAt => updatedAt;

  Post.fromMap(dynamic obj) {
    this.id = obj["pid"];
    this.title = obj["name"];
    this.titleKy = obj["name_ky"];
    this.description = obj["content"];
    this.descriptionKy = obj["content_ky"];
    this.sort = obj["position"];
    this.updatedAt = obj["updated_at"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["name"] = title;
    map["name_ky"] = titleKy;
    map["content"] = description;
    map["content_ky"] = descriptionKy;
    map["position"] = sort;
    map["updated_at"] = updatedAt;

    return map;
  }
}
