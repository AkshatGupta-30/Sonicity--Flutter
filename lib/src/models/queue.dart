import 'package:sonicity/src/database/database.dart';
import 'package:sonicity/src/models/models.dart';

class Queue {
  final String id;
  final String name;
  final String songCount;
  final DateTime dateCreated;
  bool isCurrent, isPlaying;
  List<Song> ? songs;

  Queue({required this.id, required this.name, required this.dateCreated, required this.songCount, required this.isCurrent, required this.isPlaying, this.songs});

  factory Queue.fromDb(Map<String, dynamic> data) {
    return Queue(
      id: data[QueueDatabase.colId].toString(),
      name: data[QueueDatabase.colName].toString().replaceAll('qpzm', ' - ').replaceAll('_', ' '),
      songCount: data[QueueDatabase.colSongCount].toString(),
      dateCreated: DateTime.parse(data[QueueDatabase.colDateCreated]),
      isCurrent: (data[QueueDatabase.colCurrentQueue] == 0) ? false : true,
      isPlaying: (data[QueueDatabase.colPlayingQueue] == 0) ? false : true,
    );
  }

  factory Queue.empty() {
    return Queue(id: '', name: '', dateCreated: DateTime.now(), songCount: '', isCurrent: false, isPlaying: false);
  }
}