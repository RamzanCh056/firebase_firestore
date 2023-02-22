class DataModel {
  String? name;
  String? topicTalk;
  String? textTitle;
  String? doc;

  DataModel({
    this.name,
    this.topicTalk,
    this.textTitle,
    this.doc,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "topicTalk": this.topicTalk,
      "textTitle": this.textTitle,
      "doc": this.doc,
    };
  }

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json["name"] ?? "",
      topicTalk: json["topicTalk"] ?? "",
      textTitle: json["textTitle"] ?? "",
      doc: json["doc"] ?? "",
    );
  }
}
