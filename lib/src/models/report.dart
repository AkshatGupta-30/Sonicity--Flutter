class Report {
  final String screenshotUrl;
  final String message;
  Report({required this.screenshotUrl, required this.message});

  factory Report.fromJson({required String downlodUrl, required String message}) {
    return Report(
      screenshotUrl: downlodUrl,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => {
    "Message" : message,
    "Screen Shot Url" : screenshotUrl
  };
}