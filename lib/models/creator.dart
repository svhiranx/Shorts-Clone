class Creator {
  String? name;
  String id;
  String handle;
  String? pic;
  Creator(
      {required this.name,
      required this.id,
      required this.handle,
      required this.pic});
  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
        name: json["name"],
        id: json["id"],
        handle: json["handle"],
        pic: json["pic"]);
  }
}
