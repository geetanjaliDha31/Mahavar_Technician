import 'dart:convert';

ClosedRequestData ClosedRequestDataFromJson(String str) =>
    ClosedRequestData.fromJson(json.decode(str));

String ClosedRequestDataToJson(ClosedRequestData data) =>
    json.encode(data.toJson());

class ClosedRequestData {
    String? response;
    bool? error;
    List<ResultArray>? resultArray;
    String? message;

    ClosedRequestData({this.response, this.error, this.resultArray, this.message});

    ClosedRequestData.fromJson(Map<String, dynamic> json) {
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
    List<ServiceDetailsArray>? serviceDetailsArray;

    ResultArray({this.serviceDetailsArray});

    ResultArray.fromJson(Map<String, dynamic> json) {
        serviceDetailsArray = json["service_details_array"] == null ? null : (json["service_details_array"] as List).map((e) => ServiceDetailsArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(serviceDetailsArray != null) {
            _data["service_details_array"] = serviceDetailsArray?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class ServiceDetailsArray {
    String? customerName;
    String? customerMobileNo;
    String? brandName;
    String? modelName;
    String? esignPath;
    String? photoPhoto1;
    String? photoPhoto2;
    String? photoPhoto3;
    String? comments;
    String? stickerPhoto;

    ServiceDetailsArray({this.customerName, this.customerMobileNo, this.brandName, this.modelName, this.esignPath, this.photoPhoto1, this.photoPhoto2, this.photoPhoto3, this.comments, this.stickerPhoto});

    ServiceDetailsArray.fromJson(Map<String, dynamic> json) {
        customerName = json["customer_name"];
        customerMobileNo = json["customer_mobile_no"];
        brandName = json["brand_name"];
        modelName = json["model_name"];
        esignPath = json["esign_path"];
        photoPhoto1 = json["photo_photo1"];
        photoPhoto2 = json["photo_photo2"];
        photoPhoto3 = json["photo_photo3"];
        comments = json["comments"];
        stickerPhoto = json["sticker_photo"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["customer_name"] = customerName;
        _data["customer_mobile_no"] = customerMobileNo;
        _data["brand_name"] = brandName;
        _data["model_name"] = modelName;
        _data["esign_path"] = esignPath;
        _data["photo_photo1"] = photoPhoto1;
        _data["photo_photo2"] = photoPhoto2;
        _data["photo_photo3"] = photoPhoto3;
        _data["comments"] = comments;
        _data["sticker_photo"] = stickerPhoto;
        return _data;
    }
}