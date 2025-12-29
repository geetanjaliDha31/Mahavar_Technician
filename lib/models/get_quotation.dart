import 'dart:convert';

GetQuotation GetQuotationFromJson(String str) =>
    GetQuotation.fromJson(json.decode(str));

String GetQuotationToJson(GetQuotation data) => json.encode(data.toJson());


class GetQuotation {
    String? response;
    bool? error;
    List<ResultArray>? resultArray;
    String? message;

    GetQuotation({this.response, this.error, this.resultArray, this.message});

    GetQuotation.fromJson(Map<String, dynamic> json) {
        response = json["response"];
        error = json["error"];
        resultArray = json["result_array"] == null ? null : (json["result_array"] as List).map((e) => ResultArray.fromJson(e)).toList();
        message = json["message"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["response"] = response;
        data["error"] = error;
        if(resultArray != null) {
            data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
        }
        data["message"] = message;
        return data;
    }
}

class ResultArray {
    List<QuotationDetailsArray>? quotationDetailsArray;

    ResultArray({this.quotationDetailsArray});

    ResultArray.fromJson(Map<String, dynamic> json) {
        quotationDetailsArray = json["quotation_details_array"] == null ? null : (json["quotation_details_array"] as List).map((e) => QuotationDetailsArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        if(quotationDetailsArray != null) {
            data["quotation_details_array"] = quotationDetailsArray?.map((e) => e.toJson()).toList();
        }
        return data;
    }
}

class QuotationDetailsArray {
    int? partId;
    String? partName;
    int? quantity;
    int? price;

    QuotationDetailsArray({this.partId, this.partName, this.quantity, this.price});

    QuotationDetailsArray.fromJson(Map<String, dynamic> json) {
        partId = json["part_id"];
        partName = json["part_name"];
        quantity = json["quantity"];
        price = json["price"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["part_id"] = partId;
        data["part_name"] = partName;
        data["quantity"] = quantity;
        data["price"] = price;
        return data;
    }
}