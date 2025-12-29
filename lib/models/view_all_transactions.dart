import 'dart:convert';

ViewAllTransactions ViewAllTransactionsFromJson(String str) =>
    ViewAllTransactions.fromJson(json.decode(str));

String ViewAllTransactionsToJson(ViewAllTransactions data) =>
    json.encode(data.toJson());

class ViewAllTransactions {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;
  String? message;

  ViewAllTransactions(
      {this.response, this.error, this.resultArray, this.message});

  ViewAllTransactions.fromJson(Map<String, dynamic> json) {
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
  int? callsId;
  String? customerName;
  int? paidAmount;
  String? callCloseDate;

  ResultArray(
      {this.callsId, this.customerName, this.paidAmount, this.callCloseDate});

  ResultArray.fromJson(Map<String, dynamic> json) {
    callsId = json["calls_id"];
    customerName = json["customer_name"];
    paidAmount = json["paid_amount"];
    callCloseDate = json["call_close_date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["calls_id"] = callsId;
    data["customer_name"] = customerName;
    data["paid_amount"] = paidAmount;
    data["call_close_date"] = callCloseDate;
    return data;
  }
}
