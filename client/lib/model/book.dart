class Book {
  int? id;
  List<String>? authors;
  String? contents;
  String? datetime;
  String? isbn;
  int? price;
  String? publisher;
  int? salePrice;
  String? status;
  String? thumbnail;
  String? title;
  List<String>? translators;
  String? url;

  Book(
      {
        this.id,
        this.authors,
        this.contents,
        this.datetime,
        this.isbn,
        this.price,
        this.publisher,
        this.salePrice,
        this.status,
        this.thumbnail,
        this.title,
        this.translators,
        this.url,
      });

  factory Book.fromJson(Map<String, dynamic> json,{bool isFromDB = false}) {

    return Book(
      id: json['id'],
      authors: (isFromDB == true) ? json['authors'].split(',') : json['authors'].cast<String>(),
      contents: json['contents'],
      datetime: json['datetime'],
      isbn: json['isbn'],
      price: json['price'],
      publisher: json['publisher'],
      salePrice: json['sale_price'],
      status: json['status'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      translators: (isFromDB == true) ? json['translators'].split(',') : json['translators'].cast<String>(),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authors'] = (authors ?? []).join(',');
    data['contents'] = contents;
    data['datetime'] = datetime;
    data['isbn'] = isbn;
    data['price'] = price;
    data['publisher'] = publisher;
    data['sale_price'] = salePrice;
    data['status'] = status;
    data['thumbnail'] = thumbnail;
    data['title'] = title;
    data['translators'] = (translators ?? []).join(',');
    data['url'] = url;
    return data;
  }
}