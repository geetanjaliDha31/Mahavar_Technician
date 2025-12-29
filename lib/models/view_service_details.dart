import 'dart:convert';

ViewServiceDetails ViewServiceDetailsFromJson(String str) =>
    ViewServiceDetails.fromJson(json.decode(str));

String ViewServiceDetailsToJson(ViewServiceDetails data) =>
    json.encode(data.toJson());

class ViewServiceDetails {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;
  String? message;

  ViewServiceDetails(
      {this.response, this.error, this.resultArray, this.message});

  ViewServiceDetails.fromJson(Map<String, dynamic> json) {
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
  List<PendingCallsArray>? pendingCallsArray;
  List<CompletedCallsArray>? completedCallsArray;

  ResultArray({this.pendingCallsArray, this.completedCallsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    pendingCallsArray = json["pending_calls_array"] == null
        ? null
        : (json["pending_calls_array"] as List)
            .map((e) => PendingCallsArray.fromJson(e))
            .toList();
    completedCallsArray = json["completed_calls_array"] == null
        ? null
        : (json["completed_calls_array"] as List)
            .map((e) => CompletedCallsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pendingCallsArray != null) {
      data["pending_calls_array"] =
          pendingCallsArray?.map((e) => e.toJson()).toList();
    }
    if (completedCallsArray != null) {
      data["completed_calls_array"] =
          completedCallsArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class CompletedCallsArray {
  int? serviceId;
  String? customerName;
  String? brandName;
  String? modelName;
  String? issueName;
  int? priorityId;
  String? priorityName;
  String? serviceDate;
  String? serviceTime;

  CompletedCallsArray({
    this.serviceId,
    this.customerName,
    this.brandName,
    this.modelName,
    this.issueName,
    this.priorityId,
    this.priorityName,
    this.serviceDate,
    this.serviceTime,
  });

  CompletedCallsArray.fromJson(Map<String, dynamic> json) {
    serviceId = json["service_id"];
    customerName = json["customer_name"];
    brandName = json["brand_name"];
    modelName = json["model_name"];
    issueName = json["issue_name"];
    priorityId = json["priority_id"];
    priorityName = json["priority_name"];
    serviceDate = json["service_date"];
    serviceTime = json["service_time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["service_id"] = serviceId;
    data["customer_name"] = customerName;
    data["brand_name"] = brandName;
    data["model_name"] = modelName;
    data["issue_name"] = issueName;
    data["priority_id"] = priorityId;
    data["priority_name"] = priorityName;
    data["service_date"] = serviceDate;
    data["service_time"] = serviceTime;
    return data;
  }
}

class PendingCallsArray {
  int? serviceId;
  String? customerName;
  String? brandName;
  String? modelName;
  String? issueName;
  int? priorityId;
  String? priorityName;
  String? serviceDate;
  String? serviceTime;

  PendingCallsArray({
    this.serviceId,
    this.customerName,
    this.brandName,
    this.modelName,
    this.issueName,
    this.priorityId,
    this.priorityName,
    this.serviceDate,
    this.serviceTime,
  });

  PendingCallsArray.fromJson(Map<String, dynamic> json) {
    serviceId = json["service_id"];
    customerName = json["customer_name"];
    brandName = json["brand_name"];
    modelName = json["model_name"];
    issueName = json["issue_name"];
    priorityId = json["priority_id"];
    priorityName = json["priority_name"];
    serviceDate = json["service_date"];
    serviceTime = json["service_time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["service_id"] = serviceId;
    data["customer_name"] = customerName;
    data["brand_name"] = brandName;
    data["model_name"] = modelName;
    data["issue_name"] = issueName;
    data["priority_id"] = priorityId;
    data["priority_name"] = priorityName;
    data["service_date"] = serviceDate;
    data["service_time"] = serviceTime;
    return data;
  }
}
