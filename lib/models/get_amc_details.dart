import 'dart:convert';

GetAmcDetails GetAmcDetailsFromJson(String str) =>
    GetAmcDetails.fromJson(json.decode(str));

String GetAmcDetailsToJson(GetAmcDetails data) => json.encode(data.toJson());

class GetAmcDetails {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;
  String? message;

  GetAmcDetails({this.response, this.error, this.resultArray, this.message});

  GetAmcDetails.fromJson(Map<String, dynamic> json) {
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
  int? amcStatus;
  int? isGst;
  String? amcStartDate;
  String? amcEndDate;

  ResultArray({this.amcStatus, this.isGst, this.amcStartDate, this.amcEndDate});

  ResultArray.fromJson(Map<String, dynamic> json) {
    amcStatus = json["amc_status"];
    isGst = json["is_gst"];
    amcStartDate = json["amc_start_date"];
    amcEndDate = json["amc_end_date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["amc_status"] = amcStatus;
    _data["is_gst"] = isGst;
    _data["amc_start_date"] = amcStartDate;
    _data["amc_end_date"] = amcEndDate;
    return _data;
  }
}
