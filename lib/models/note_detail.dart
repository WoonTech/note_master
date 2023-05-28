class NoteDetail {
  int? id;
  int? noteId;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();
  String? content;

  NoteDetail(
      {this.id, this.noteId, this.createdAt, this.updatedAt, this.content});

  factory NoteDetail.fromJson(Map<String, dynamic> json) {
    return NoteDetail(
        id: json['ID'],
        noteId: json['NoteID'],
        createdAt: json['CreatedAt'],
        updatedAt: json['UpdatedAt'],
        content: json['Content']);
  }
}
