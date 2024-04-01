import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

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
      id: data[colId].toString(),
      name: data[colName].toString().replaceAll('qpzm', ' - ').replaceAll('_', ' '),
      songCount: data[colSongCount].toString(),
      dateCreated: DateTime.parse(data[colDateCreated]),
      isCurrent: (data[colCurrentQueue] == 0) ? false : true,
      isPlaying: (data[colPlayingQueue] == 0) ? false : true,
    );
  }

  factory Queue.empty() {
    return Queue(id: '', name: '', dateCreated: DateTime.now(), songCount: '', isCurrent: false, isPlaying: false);
  }
}