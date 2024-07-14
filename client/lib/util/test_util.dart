class MaestroTestUtil{

  List<K>? jsonToList<K>(Map<String, dynamic>? json,
      K Function(Map<String, dynamic> model) fromJson, String key) {

    if(json == null) return [];

    if (json.isEmpty || !json.containsKey(key)) return [];

    return List<K>.from(json[key].map((model) => fromJson(model)));
  }
}