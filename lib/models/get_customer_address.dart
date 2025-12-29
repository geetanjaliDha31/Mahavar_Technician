import 'dart:convert';

GetCustomerAddress GetCustomerAddressFromJson(String str) =>
    GetCustomerAddress.fromJson(json.decode(str));

String GetCustomerAddressToJson(GetCustomerAddress data) =>
    json.encode(data.toJson());

class GetCustomerAddress {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;

  GetCustomerAddress({this.response, this.error, this.resultArray});

  GetCustomerAddress.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    resultArray = json["result_array"] == null
        ? null
        : (json["result_array"] as List)
            .map((e) => ResultArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["response"] = response;
    data["error"] = error;
    if (resultArray != null) {
      data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ResultArray {
  int? addressId;
  String? pincode;
  String? city;
  String? houseNo;
  String? streetName;
  String? addressType;

  ResultArray(
      {this.addressId,
      this.pincode,
      this.city,
      this.houseNo,
      this.streetName,
      this.addressType});

  ResultArray.fromJson(Map<String, dynamic> json) {
    addressId = json["address_id"];
    pincode = json["pincode"];
    city = json["city"];
    houseNo = json["house_no"];
    streetName = json["street_name"];
    addressType = json["address_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["address_id"] = addressId;
    data["pincode"] = pincode;
    data["city"] = city;
    data["house_no"] = houseNo;
    data["street_name"] = streetName;
    data["address_type"] = addressType;
    return data;
  }
}
