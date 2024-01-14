class NotificationBody {
  String title;
  String body;
  String id;
  String type;

  NotificationBody({
    required this.title,
    required this.body,
    required this.id,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'id': id,
      'type': type,
    };
  }

  factory NotificationBody.fromMap(Map<String, dynamic> map) =>
      NotificationBody(
        title: map['title'],
        body: map['body'],
        id: map['id'],
        type: map['type'],
      );
}