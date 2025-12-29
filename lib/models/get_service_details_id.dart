// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

ServiceDetailsbyId ServiceDetailsbyIdFromJson(String str) =>
    ServiceDetailsbyId.fromJson(json.decode(str));

String ServiceDetailsbyIdToJson(ServiceDetailsbyId data) =>
    json.encode(data.toJson());

class ServiceDetailsbyId {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;
  String? message;

  ServiceDetailsbyId(
      {this.response, this.error, this.resultArray, this.message});

  ServiceDetailsbyId.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["response"] = response;
    data["error"] = error;
    if (resultArray != null) {
      data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    data["message"] = message;
    return data;
  }
}

class ResultArray {
  List<ServiceDetailsArray>? serviceDetailsArray;

  ResultArray({this.serviceDetailsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    serviceDetailsArray = json["service_details_array"] == null
        ? null
        : (json["service_details_array"] as List)
            .map((e) => ServiceDetailsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceDetailsArray != null) {
      data["service_details_array"] =
          serviceDetailsArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ServiceDetailsArray {
  int? serviceId;
  int? userId;
  String? customerName;
  String? customerMobileNo;
  int? addressId;
  String? comments;
  String? brandName;
  String? modelName;
  String? issueName;
  String? mapUrl;
  String? serviceAddress;
  String? addressType;
  String? latitude;
  String? longitude;
  String? status;

  ServiceDetailsArray(
      {this.serviceId,
      this.userId,
      this.customerName,
      this.customerMobileNo,
      this.addressId,
      this.brandName,
      this.modelName,
      this.mapUrl,
      this.issueName,
      this.comments,
      this.serviceAddress,
      this.addressType,
      this.latitude,
      this.longitude,
      this.status});

  ServiceDetailsArray.fromJson(Map<String, dynamic> json) {
    serviceId = json["service_id"];
    userId = json["user_id"];
    customerName = json["customer_name"];
    customerMobileNo = json["customer_mobile_no"];
    addressId = json["address_id"];
    comments = json["comments"];
    brandName = json["brand_name"];
    mapUrl = json["map_url"];
    modelName = json["model_name"];
    issueName = json["issue_name"];
    serviceAddress = json["service_address"];
    addressType = json["address_type"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["service_id"] = serviceId;
    data["user_id"] = userId;
    data["customer_name"] = customerName;
    data["customer_mobile_no"] = customerMobileNo;
    data["address_id"] = addressId;
    data['comments'] = comments;
    data["brand_name"] = brandName;
    data["map_url"] = mapUrl;
    data["model_name"] = modelName;
    data["issue_name"] = issueName;
    data["service_address"] = serviceAddress;
    data["address_type"] = addressType;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["status"] = status;
    return data;
  }
}
