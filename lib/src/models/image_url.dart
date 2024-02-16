class ImageUrl {
  final List<ImageData> _imageLinks;

  ImageUrl({required List<ImageData> imageLinks}) : _imageLinks = imageLinks;

  late final String lowQuality = _getImageUrl('50x50');
  late final String standardQuality = _getImageUrl('150x150');
  late final String highQuality = _getImageUrl('500x500');

  String _getImageUrl(String quality) {
    final link = _imageLinks.firstWhere(
      (element) => element.quality == quality,
      orElse: () => ImageData(quality: '', link: ''),
    );
    return link.link;
  }

  factory ImageUrl.fromJson(List<dynamic> json) {
    List<ImageData> links = json.map((link) => ImageData.fromJson(link)).toList();
    return ImageUrl(imageLinks: links);
  }
}

class ImageData {
  final String quality;
  final String link;

  ImageData({required this.quality, required this.link});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      quality: json['quality'],
      link: json['link'],
    );
  }
}
