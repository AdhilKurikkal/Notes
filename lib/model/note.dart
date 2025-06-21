class Note {
  final String title;
  final String description;

  Note({required this.title, required this.description});

  //to
  Map<String, dynamic> toJson() => {'title': title, 'description': description};

  //from

  factory Note.fromJson(Map<String, dynamic> json) =>
      Note(title: json['title'], description: json['description']);
}
