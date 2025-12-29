import 'dart:convert';

GetInventoryList GetInventoryListFromJson(String str) =>
    GetInventoryList.fromJson(json.decode(str));

String GetInventoryListToJson(GetInventoryList data) =>
    json.encode(data.toJson());

class GetInventoryList {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;
  String? message;

  GetInventoryList({this.response, this.error, this.resultArray, this.message});

  GetInventoryList.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    resultArray = json["result_array"] == null
        ? null
        : (json["result_array"] as List)
            .map((e) => ResultArray.fromJson(e))
            .toList();
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["response"] = response;
    _data["error"] = error;
    if (resultArray != null) {
      _data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    _data["message"] = message;
    return _data;
  }
}

class ResultArray {
  List<InventoryDetailsArray>? inventoryDetailsArray;

  ResultArray({this.inventoryDetailsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    inventoryDetailsArray = json["inventory_details_array"] == null
        ? null
        : (json["inventory_details_array"] as List)
            .map((e) => InventoryDetailsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (inventoryDetailsArray != null) {
      _data["inventory_details_array"] =
          inventoryDetailsArray?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class InventoryDetailsArray {
  String? partName;
  int? qty;

  InventoryDetailsArray({this.partName, this.qty});

  InventoryDetailsArray.fromJson(Map<String, dynamic> json) {
    partName = json["part_name"];
    qty = json["qty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["part_name"] = partName;
    _data["qty"] = qty;
    return _data;
  }
}
