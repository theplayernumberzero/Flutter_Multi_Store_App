import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mac_store_app/consts_api.dart';

class StripeController {
  StripeController._();

  static final StripeController instance = StripeController._();

  Future<void> makePayment(double amount) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount.toInt(), "usd");
      if (paymentIntentClientSecret == null) {
        throw Exception("Ödeme başlatılamadı");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "Bahadir Kilic"),
      );

      await _processPayment();
      // Eğer buraya kadar geldiyse ödeme başarılıdır
    } catch (e) {
      print("Stripe ödeme hatası: $e");
      throw e; // Hatayı yukarı ilet
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency
      };

      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer ${stripeSecretKey}",
            "Content-Type": 'application/x-www-form-urlencoded'
          }));
      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print("Payment intent oluşturma hatası: $e");
      throw e;
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("Ödeme işlemi hatası: $e");
      throw e;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
