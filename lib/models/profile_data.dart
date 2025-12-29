
// import 'dart:convert';

// ProfileData ProfileDataFromJson(String str) => ProfileData.fromJson(json.decode(str));

// String ProfileDataToJson(ProfileData data) => json.encode(data.toJson());

// class ProfileData {
//     String? response;
//     bool? error;
//     bool? isRegistered;
//     String? message;
//     int? techanicanId;
//     String? mobileNo;
//     String? name;
//     String? email;

//     ProfileData({this.response, this.error, this.isRegistered, this.message, this.techanicanId, this.mobileNo, this.name, this.email});

//     ProfileData.fromJson(Map<String, dynamic> json) {
//         response = json["response"];
//         error = json["error"];
//         isRegistered = json["isRegistered"];
//         message = json["message"];
//         techanicanId = json["techanican_id"];
//         mobileNo = json["mobile_no"];
//         name = json["name"];
//         email = json["email"];
//     }

//     Map<String, dynamic> toJson() {
//         final Map<String, dynamic> _data = <String, dynamic>{};
//         _data["response"] = response;
//         _data["error"] = error;
//         _data["isRegistered"] = isRegistered;
//         _data["message"] = message;
//         _data["techanican_id"] = techanicanId;
//         _data["mobile_no"] = mobileNo;
//         _data["name"] = name;
//         _data["email"] = email;
//         return _data;
//     }
// }