class HelpDeskResponse {
  int? id;
  String? title;
  String? body;

  HelpDeskResponse({this.id, this.title, this.body});

  HelpDeskResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}
