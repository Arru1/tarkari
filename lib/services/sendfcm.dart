import 'package:dio/dio.dart';



// final String serverKey =
    // 'AAAAvfFUPxo:APA91bHwJ5SM1YHzK2sT3GDvXUWiRuyhdS0zfz1npVhaWwXTg5QY69HknjYkLXCcfsWjPT-CUjUT5_8I63x0jRjy3BHtOVVpfgYlSS6JDkykKdethA9MxiuCZXxNQNAWmHCuye2ZEn1n';
final String serverKey ='AAAAdFPRiVw:APA91bHIJdhqr4KqKsd-HJwnvs4EYWVt0anxnYq71dlQ0-p0mwr4M5p43iWzUYgRhtIIgARyAvG-OkLqtzXQjO2u74SdO63t6ZV2PFdshMQzBkjKAAh9U5IbYDi_3z3Iqd7xg17JzBVD';
final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
Dio dio = Dio();

class SendNotifcation {
  static Future<Response?> sendFCMNotification(
      String username,
      String ownerImage,
      String? userRequesting,
      String? request,
      String? bookingDate,
      String? name,
      String? location) async {
   // Venueapiservice venueapiservice = Venueapiserviceimpl();
    //List<String?> tokens = await venueapiservice.getTokens(username);
    String tokens ='dLNfQavxQd6dPp8ups7i-u:APA91bHmv3if-8wVkuOoXWKMN1JygwmZg2NjlDC_SM-IMusmK7mkuvmD960th_IcSFS31CRaBo3QZzjObXHrszTxWk9jZlMTgM_YdqEP62n50OnuBIQuxl3BKqmKC86TmcvkHDjSKiqA';
    bool sentSuccessfully = false;
    RequestOptions requestOptions = RequestOptions();

    try {
      if (tokens.isNotEmpty) {
       // for (String? token in tokens) {
         // if (token != null) {
            Map<String, dynamic> notification = {
              'to': tokens,
              'notification': {
                'title': request,
                'body': "${userRequesting} has ordered your ${name} venue",
                'image': ownerImage,
              },
              'data': {
                'bookingDate': bookingDate,
                'location': location,
              },
            };

            Options options = Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=$serverKey',
              },
            );

            Response response = await dio.post(
              fcmEndpoint,
              options: options,
              data: notification,
            );

            if (response.statusCode == 200 || response.statusCode == 201) {
              print('Notification sent successfully to token: $tokens');
              sentSuccessfully = true;
            } else {
              print('Failed to send notification to token: $tokens');
            }
         // }
        //}
      } else {
        print('No tokens found or empty token list');

        return Response(
            statusCode: 404,
            statusMessage: 'No tokens found or empty token list',
            requestOptions: requestOptions);
      }
    } catch (e) {
      print('Error sending FCM notifications: $e');

      return null;
    }

    return sentSuccessfully
        ? Response(statusCode: 200, requestOptions: requestOptions)
        : null;
  }
}
 
