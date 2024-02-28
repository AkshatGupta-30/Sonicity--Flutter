class Lyrics{
  String lyrics;
  String snippet;
  String copyright;
  Lyrics({
    required this.lyrics,
    required this.snippet,
    required this.copyright
  });

  factory Lyrics.details(Map<String, dynamic> data) {
    return Lyrics(
      lyrics: data['lyrics'],
      snippet: data['snippet'],
      copyright: data['copyright']
    );
  }

  factory Lyrics.empty() {
    return Lyrics(lyrics: "", snippet: "", copyright: "");
  }

  bool isEmpty() {
    return lyrics.isEmpty;
  }

  bool isNotEmpty() {
    return lyrics.isNotEmpty;
  }
}