import 'dart:convert';

GetUsedParts GetUsedPartsFromJson(String str) =>
    GetUsedParts.fromJson(json.decode(str));

String GetUsedPartsToJson(GetUsedParts data) =>
    json.encode(data.toJson());

class GetUsedParts {
    String? response;
    bool? error;
    List<ResultArray>? resultArray;
    String? message;

    GetUsedParts({this.response, this.error, this.resultArray, this.message});

    GetUsedParts.fromJson(Map<String, dynamic> json) {
        response = json["response"];
        error = json["error"];
        resultArray = json["result_array"] == null ? null : (json["result_array"] as List).map((e) => ResultArray.fromJson(e)).toList();
        message = json["message"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["response"] = response;
        _data["error"] = error;
        if(resultArray != null) {
            _data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
        }
        _data["message"] = message;
        return _data;
    }
}

class ResultArray {
    List<UsedPartDetailsDetailsArray>? usedPartDetailsDetailsArray;

    ResultArray({this.usedPartDetailsDetailsArray});

    ResultArray.fromJson(Map<String, dynamic> json) {
        usedPartDetailsDetailsArray = json["used_part_details_details_array"] == null ? null : (json["used_part_details_details_array"] as List).map((e) => UsedPartDetailsDetailsArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(usedPartDetailsDetailsArray != null) {
            _data["used_part_details_details_array"] = usedPartDetailsDetailsArray?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class UsedPartDetailsDetailsArray {
    int? partId;
    String? partName;
    int? quantity;

    UsedPartDetailsDetailsArray({this.partId, this.partName, this.quantity});

    UsedPartDetailsDetailsArray.fromJson(Map<String, dynamic> json) {
        partId = json["part_id"];
        partName = json["part_name"];
        quantity = json["quantity"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["part_id"] = partId;
        _data["part_name"] = partName;
        _data["quantity"] = quantity;
        return _data;
    }
}