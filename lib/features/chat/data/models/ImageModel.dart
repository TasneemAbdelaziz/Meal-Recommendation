/// results : [{"id":654571,"title":"Panna Cotta with Raspberry and Orange Sauce","image":"https://img.spoonacular.com/recipes/654571-312x231.jpg","imageType":"jpg"},{"id":642583,"title":"Farfalle with Peas, Ham and Cream","image":"https://img.spoonacular.com/recipes/642583-312x231.jpg","imageType":"jpg"},{"id":654679,"title":"Parmesan Mashed Potatoes","image":"https://img.spoonacular.com/recipes/654679-312x231.jpg","imageType":"jpg"},{"id":641836,"title":"Easy Baked Parmesan Chicken","image":"https://img.spoonacular.com/recipes/641836-312x231.jpg","imageType":"jpg"},{"id":652497,"title":"Mouthwatering Mushroom Pie","image":"https://img.spoonacular.com/recipes/652497-312x231.jpg","imageType":"jpg"},{"id":655822,"title":"Pesto Fresh Caprese Sandwich","image":"https://img.spoonacular.com/recipes/655822-312x231.jpg","imageType":"jpg"},{"id":636177,"title":"Broccoli Cheddar Soup","image":"https://img.spoonacular.com/recipes/636177-312x231.jpg","imageType":"jpg"},{"id":638893,"title":"Chocolate Cherry Cheesecake","image":"https://img.spoonacular.com/recipes/638893-312x231.jpg","imageType":"jpg"},{"id":635217,"title":"Blackberry Grilled Cheese Sandwich","image":"https://img.spoonacular.com/recipes/635217-312x231.jpg","imageType":"jpg"},{"id":650744,"title":"Mango & Goat Cheese Quesadillas","image":"https://img.spoonacular.com/recipes/650744-312x231.jpg","imageType":"jpg"}]
/// offset : 0
/// number : 10
/// totalResults : 1304

class ImageModel {
  ImageModel({
    this.results,
    this.offset,
    this.number,
    this.totalResults,});

  ImageModel.fromJson(dynamic json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
    offset = json['offset'];
    number = json['number'];
    totalResults = json['totalResults'];
  }
  List<Results>? results;
  int? offset;
  int? number;
  int? totalResults;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    map['offset'] = offset;
    map['number'] = number;
    map['totalResults'] = totalResults;
    return map;
  }

}

class Results {
  Results({
    this.id,
    this.title,
    this.image,
    this.imageType,});

  Results.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    imageType = json['imageType'];
  }
  int? id;
  String? title;
  String? image;
  String? imageType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['imageType'] = imageType;
    return map;
  }

}