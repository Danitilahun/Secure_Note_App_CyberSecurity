import 'package:flutter/material.dart';
import 'package:noteapp/models/note_model.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteListItem({
    Key? key,
    required this.note,
    required this.color,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          note.title!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          note.content!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white70),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            note.title![0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.blue,
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
