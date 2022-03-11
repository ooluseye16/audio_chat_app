class Message {
  String? content;
  DateTime date;
  String? idTo;
  String timeStamp;

  Message({
    this.content,
    this.idTo,
    required this.date,
    required this.timeStamp,
  });

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
      content: json["content"],
      date: DateTime.parse(json["date"]),
      idTo: json["idTo"],
      timeStamp: json["timestamp"]);

  Map<String, dynamic> toJson() => {
        "content": content,
        "idTo": idTo,
        "date": date.toString(),
        "timestamp": timeStamp,
      };
}
