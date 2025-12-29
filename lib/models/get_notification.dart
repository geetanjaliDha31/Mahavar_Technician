import 'dart:convert';

GetNotification GetNotificationFromJson(String str) =>
    GetNotification.fromJson(json.decode(str));

String GetNotificationToJson(GetNotification data) => json.encode(data.toJson());


class GetNotification {
    String? response;
    bool? error;
    String? message;
    List<ResultArray>? resultArray;

    GetNotification({this.response, this.error, this.message, this.resultArray});

    GetNotification.fromJson(Map<String, dynamic> json) {
        response = json["response"];
        error = json["error"];
        message = json["message"];
        resultArray = json["result_array"] == null ? null : (json["result_array"] as List).map((e) => ResultArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["response"] = response;
        _data["error"] = error;
        _data["message"] = message;
        if(resultArray != null) {
            _data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class ResultArray {
    String? date;
    List<Timeline>? timeline;

    ResultArray({this.date, this.timeline});

    ResultArray.fromJson(Map<String, dynamic> json) {
        date = json["date"];
        timeline = json["timeline"] == null ? null : (json["timeline"] as List).map((e) => Timeline.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["date"] = date;
        if(timeline != null) {
            _data["timeline"] = timeline?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Timeline {
    int? notificationId;
    String? message;
    String? createdOn;
    String? time;

    Timeline({this.notificationId, this.message, this.createdOn, this.time});

    Timeline.fromJson(Map<String, dynamic> json) {
        notificationId = json["notification_id"];
        message = json["message"];
        createdOn = json["created_on"];
        time = json["time"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["notification_id"] = notificationId;
        _data["message"] = message;
        _data["created_on"] = createdOn;
        _data["time"] = time;
        return _data;
    }
}