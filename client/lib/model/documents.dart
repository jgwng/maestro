class Document{
  int? id;
  String? collection;
  String? thumbnailUrl;
  String? imageUrl;
  int? width;
  int? height;
  String? displaySiteName;
  String? docUrl;
  DateTime? datetime;
  String isFavorite;

  Document(
      {
        this.id,
        this.collection = '',
        this.thumbnailUrl = '',
        this.imageUrl = '0',
        this.width = 0,
        this.height = 0,
        this.displaySiteName,
        this.docUrl,
        this.datetime,
        this.isFavorite = 'false'
      });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        id: json['id'],
        collection: json['collection'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
        imageUrl: json['image_url'] ?? '',
        width: json['width'] ?? 0,
        height: json['height'] ?? 0,
        displaySiteName: json['display_sitename'] ?? '',
        docUrl: json['doc_url'] ?? '',
      datetime: DateTime.tryParse(json['datetime'] ?? DateTime.now().toString()),
      isFavorite: json['isFavorite'] ?? 'false');
  }

  Map<String,dynamic> toJson(){
    return {
       'id' : id,
      'collection' : collection,
      'thumbnail_url': thumbnailUrl,
      'image_url' : imageUrl,
      'width' : width,
      'height': height,
      'display_sitename' : displaySiteName,
      'doc_url' : docUrl,
      'datetime': datetime?.toIso8601String(),
      'isFavorite': isFavorite
    };
  }
}