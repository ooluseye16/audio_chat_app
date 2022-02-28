class Message {
  String? message;

  String? date;

  Message({
    this.message,
    this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "date": date,
      };
}
