class DownloadUrl {
  final List<DownloadData> _downloadData;

  DownloadUrl({required List<DownloadData> imageLinks}) : _downloadData = imageLinks;

  late final String lowQuality = _getImageUrl('96kbps');
  late final String standardQuality = _getImageUrl('160kbps');
  late final String highQuality = _getImageUrl('320kbps');

  String _getImageUrl(String quality) {
    final link = _downloadData.firstWhere(
      (element) => element.quality == quality,
      orElse: () => DownloadData(quality: '', link: ''),
    );
    return link.link;
  }

  factory DownloadUrl.fromJson(List<dynamic> json) {
    List<DownloadData> links = json.map((link) => DownloadData.fromJson(link)).toList();
    return DownloadUrl(imageLinks: links);
  }
}

class DownloadData {
  final String quality;
  final String link;

  DownloadData({required this.quality, required this.link});

  factory DownloadData.fromJson(Map<String, dynamic> json) {
    return DownloadData(
      quality: json['quality'],
      link: json['link'],
    );
  }
}
