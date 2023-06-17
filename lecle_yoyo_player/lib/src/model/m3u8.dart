/// The data of the m3u8 file
class M3U8Data {
  /// The quality of the video
  final String? dataQuality;
  final int? qualityWight; // high(+1),low(-1)
  final bool isHightQuality;

  /// The video's url
  final String? dataURL;

  /// Constructor
  M3U8Data({
    this.dataURL,
    this.dataQuality,
    this.qualityWight,
    this.isHightQuality = false,
  });
}
