class Ads {
  final String id;
  final String imageUrl; // network or asset path
  final String tagline; // large heading
  final String caption; // smaller description
  final String link; // website link for Explore

  Ads({
    required this.id,
    required this.imageUrl,
    required this.tagline,
    required this.caption,
    required this.link,
  });

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
    id: json['id']?.toString() ?? '',
    imageUrl: json['imageUrl'] ?? '',
    tagline: json['tagline'] ?? '',
    caption: json['caption'] ?? '',
    link: json['link'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'tagline': tagline,
    'caption': caption,
    'link': link,
  };
}