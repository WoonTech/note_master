class NoteDetail {
  int? id;
  int? noteId;
  String content;

  NoteDetail(
      {this.id, this.noteId, required this.content});

  factory NoteDetail.fromJson(Map<String, dynamic> json) {
    return NoteDetail(
        id: json['ID'],
        noteId: json['NoteID'],
        content: json['Content']);
  }
}
