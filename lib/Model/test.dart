import 'dart:convert';

class Test {
  List<String> imagesUrl;
  List<String> userName;
  Test({
    required this.imagesUrl,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'imagesUrl': imagesUrl});
    result.addAll({'userName': userName});
  
    return result;
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      imagesUrl: List<String>.from(map['imagesUrl']),
      userName: List<String>.from(map['userName']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Test.fromJson(String source) => Test.fromMap(json.decode(source));
}
