class Note {
  int? id;
  String? title;
  String? content;
  int? userId; // Add userId field

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  // Convert Note object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'userId': userId, // Include userId in the map
    };
  }

  // Convert Map object to Note object
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      userId: map['userId'], // Assign userId from the map
    );
  }
}
