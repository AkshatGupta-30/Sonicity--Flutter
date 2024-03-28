import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class Queue {
  final String id;
  final String name;
  final String songCount;
  final DateTime dateCreated;
  List<Song> ? songs;

  Queue({required this.id, required this.name, required this.dateCreated, required this.songCount, this.songs});

  factory Queue.fromDb(Map<String, dynamic> data) {
    return Queue(
      id: data[QueueDatabase.colQueueId].toString(),
      name: data[QueueDatabase.colName].toString().replaceAll('_', ' '),
      songCount: data[QueueDatabase.colSongCount].toString(),
      dateCreated: DateTime.parse(data[QueueDatabase.colDateCreated]),
    );
  }

  factory Queue.empty() {
    return Queue(id: '', name: '', dateCreated: DateTime.now(), songCount: '');
  }
}