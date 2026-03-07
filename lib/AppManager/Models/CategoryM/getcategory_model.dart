class GetCategoryModel {

  bool? success;
  String? message;
  List<CategoryData>? data;

  GetCategoryModel({
    this.success,
    this.message,
    this.data,
  });

  GetCategoryModel.fromJson(Map<String, dynamic> json) {

    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {

      data = <CategoryData>[];

      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });

    }

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = {};

    data['success'] = success;
    data['message'] = message;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }

}

class CategoryData {

  int? catId;
  String? categoryName;
  int? status;
  int? subLevelId;
  int? webTypeId;

  CategoryData({
    this.catId,
    this.categoryName,
    this.status,
    this.subLevelId,
    this.webTypeId,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {

    catId = json['catId'];
    categoryName = json['categoryName'];
    status = json['status'];
    subLevelId = json['subLevelId'];
    webTypeId = json['webTypeId'];

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = {};

    data['catId'] = catId;
    data['categoryName'] = categoryName;
    data['status'] = status;
    data['subLevelId'] = subLevelId;
    data['webTypeId'] = webTypeId;

    return data;

  }

}