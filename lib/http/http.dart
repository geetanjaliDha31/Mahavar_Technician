// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/models/close_request_final.dart';
import 'package:mahavar_technician/models/get_amc_details.dart';
import 'package:mahavar_technician/models/get_customer_address.dart';
import 'package:mahavar_technician/models/get_inventory_list.dart';
import 'package:mahavar_technician/models/get_notification.dart';
import 'package:mahavar_technician/models/get_quotation.dart';
import 'package:mahavar_technician/models/get_service_details_id.dart';
import 'package:mahavar_technician/models/get_used_parts_details.dart';
import 'package:mahavar_technician/models/home_data.dart';
import 'package:mahavar_technician/models/view_all_transactions.dart';
import 'package:mahavar_technician/models/view_closed_request.dart';
import 'package:mahavar_technician/models/view_service_details.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Home/view_transactions_list.dart';
import 'package:mahavar_technician/screens/Login/pin_page.dart';
import 'package:mahavar_technician/screens/Service%20Request/service_request.dart';
import 'package:mahavar_technician/screens/View%20Request%20Details/view_request_details.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class HttpApiCall {
  Future<String> retrieveTechnicianId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("technician id $technicianId");
    return technicianId = prefs.getString('techanican_id') ?? '';
  }

  Future<void> sendOTP(BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/sendOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "mobile": data['mobile'],
      "page_type": data['page_type'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (!d['error']) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PinPage(data: data),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> verifyOTP(
      BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/verifyOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'otp': data['otp'],
      "mobile": data['mobile'],
      'player_id': data['player_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      print(playerId);
      if (d['error'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("loginInned", true);
        await prefs.setString("mobile_no", d['mobile_no']);
        await prefs.setString(
          "techanican_id",
          d['techanican_id'].toString(),
        );
        await prefs.setString("first_name", d["first_name"]);
        await prefs.setString("last_name", d["last_name"]);
        await prefs.setString("email", d["email"]);
        await prefs.setString("profile_image", d["profile_image"]);

        d["isRegistered"]
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
                (route) => false,
              )
            : Navigator.of(context).pop();
      } else {
        print("Error: ${d['message']}");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> resendOTP(
      BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/resendOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "mobile": data['mobile'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> rescheduleRequest(
      BuildContext context, Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/reschedule_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'service_id': data['service_id'],
      'reschedule_date': data['reschedule_date'],
      'reason_id': data['reason_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ServiceRequest()),
            (route) => false);
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<HomeData?> getHomeData(Map<String, dynamic> data) async {
    String technicianId = await retrieveTechnicianId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_homepage_data.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
      'start_date': data['start_date'] ?? '',
      'end_date': data['end_date'] ?? '',
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return HomeDataFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> closeRequestFinal(
      BuildContext context, CloseRequestFinal data) async {
    String technicianId = await retrieveTechnicianId();

    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/close_request.php'));

    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
      'user_id': data.userId!,
      "service_id": data.serviceId!,
      "device_image1": data.image1!,
      "device_image2": data.image2 ?? '',
      "device_image3": data.image3 ?? '',
      'call_type': data.callType!,
      "payment_type": data.paymentType ?? '',
      "payment_mode": data.paymentMode ?? "",
      "remarks": data.review ?? '',
      "total_amount": data.fullAmount ?? '',
      "partial_payment": data.partialAmount ?? '',
      "e_sign": data.sign!,
      'sticker_photo': data.sticker ?? '',
      'used_parts_details': data.partsDetails!,
      'amc_start_date': data.amcStartDate ?? '',
      'is_gst': data.isGst ?? '',
      'year': data.year ?? '',
      'is_review': data.rating ?? '',
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ServiceRequest(),
          ),
        );
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<ServiceDetailsbyId?> getServiceDetailsbyID(
      Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_request_details_by_id.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ServiceDetailsbyIdFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<GetUsedParts?> getUsedPartsDetails(Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_used_parts_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetUsedPartsFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<GetAmcDetails?> getAmcDetails(Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_amc_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetAmcDetailsFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<ClosedRequestData?> getClosedRequestData(
      Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_close_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ClosedRequestDataFromJson(responsedata.body);
    }
    return null;
  }

  Future<GetInventoryList?> getInventoryList() async {
    String technicianId = await retrieveTechnicianId();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_inventory_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetInventoryListFromJson(responsedata.body);
    }
    return null;
  }

  Future<GetNotification?> getNotification() async {
    String technicianId = await retrieveTechnicianId();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_technican_notifications.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "technican_id": technicianId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetNotificationFromJson(responsedata.body);
    }
    return null;
  }

  Future<void> deleteNotification(
      BuildContext context, List<dynamic> notificationId) async {
    String technicianId = await retrieveTechnicianId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/delete_technican_notifications.php'));
    request.fields['API_KEY'] = apikey;
    request.fields['technican_id'] = technicianId;

    for (int i = 0; i < notificationId.length; i++) {
      request.fields['notification_id_array[$i]'] =
          notificationId[i].toString();
    }
    print(notificationId);
    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      print(d);
      showToast(context, d['message'], 3);
      if (d['error'] == false || d['error'] == true) {
        Navigator.pop(context);
      }
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> createQuotation(
      BuildContext context, Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/create_quotation.php'));

    request.fields.addAll({
      'API_KEY': apikey,
      "quotation_details": data['quotation_details'],
      "service_id": data['service_id'],
      "gst": data['gst'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ViewRequestDetails(
              data: data,
            ),
          ),
        );
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<void> verifyPassword(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    String technicianId = await retrieveTechnicianId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/verify_password.php'));

    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
      "pin": data['pin'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewTransactionsList(),
          ),
        );
      } else {
        print("Incorrect PIN");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<ViewAllTransactions?> viewAllTransactions() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_all_transactions.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ViewAllTransactionsFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<ViewServiceDetails?> viewServiceDetails() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_service_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "techanican_id": technicianId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ViewServiceDetailsFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> clearTransaction(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    String technicianId = await retrieveTechnicianId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/clear_transaction.php'));

    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
      'techanican_id': technicianId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ViewTransactionsList(),
          ),
          (route) => false,
        );
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<void> updateProfileDetails(BuildContext context, String firstName,
      String lastName, String email) async {
    String technicianId = await retrieveTechnicianId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/update_profile_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'techanican_id': technicianId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("first_name", firstName);
      await prefs.setString("last_name", lastName);
      await prefs.setString("email", email);
      toastification.show(
        context: context,
        title: Text(d['message']),
        alignment: const Alignment(0.5, 0.9),
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
      );
      // showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  // Future<void> updateAddress(
  //   BuildContext context,
  //   Map<String, dynamic> data,
  // ) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('$mainUrl/update_service_location.php'));
  //   request.fields.addAll({
  //     'API_KEY': apikey,
  //     'service_id': data['service_id'],
  //     "area": data['area'],
  //     'pincode': data['pincode'],
  //     'address_line_1': data['address_line_1'],
  //     'landmark': data['landmark'],
  //     'address_type': data['address_type'],
  //   });

  //   http.StreamedResponse response = await request.send();
  //   var responsedata = await http.Response.fromStream(response);

  //   if (response.statusCode == 200) {
  //     final d = json.decode(responsedata.body) as Map<String, dynamic>;

  //     print(d['message']);
  //     toastification.show(
  //       context: context,
  //       title: Text(d['message']),
  //       alignment: const Alignment(0.5, 0.9),
  //       showProgressBar: false,
  //       autoCloseDuration: const Duration(seconds: 2),
  //     );
  //     if (d['error'] == false) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (context) => ViewRequestDetails(
  //             data: data,
  //           ),
  //         ),
  //         (route) => false,
  //       );
  //     }
  //   } else {
  //     print("error");
  //     print(response.reasonPhrase);
  //   }
  // }
  Future<void> updateMapLocation(
      BuildContext context, Map<String, dynamic> data) async {
    String technicianId = await retrieveTechnicianId();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/updateMapLocation.php'));
    request.fields.addAll(
      {
        'API_KEY': apikey,
        'techanican_id': technicianId,
        'service_id': data['service_id'],
        'address_id': data['address_id'],
        "latitude": data['latitude'],
        'longitude': data['longitude'],
      },
    );

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewRequestDetails(data: data),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<GetCustomerAddress?> getCustomerAddress(
      Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_single_service_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetCustomerAddressFromJson(responsedata.body);
    }
    return null;
  }

  Future<GetQuotation?> getQuotation(Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_quatation_details.php'));

    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      print(d);
      return GetQuotationFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
      return null;
    }
  }

  Future<Map<String, dynamic>> getDropdownData() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_all_parameters.php'));
    request.fields.addAll({
      'API_KEY': apikey,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return json.decode(responsedata.body) as Map<String, dynamic>;
    } else {
      print(response.reasonPhrase);
      return {};
    }
  }
}
