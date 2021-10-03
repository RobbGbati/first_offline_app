class Pokemon {
  String name;
  String url;

  Pokemon({required this.name, required this.url});

  Map<String, dynamic> toJson() => {'name': name, 'url': url};

  factory Pokemon.fromJson(Map<String, dynamic> map) {
    return Pokemon( name: map['name'], url: map['url']);
  }
}
