import '../enums/payment_status.dart';

abstract class PaymentDelegate{

  void paymentFinished(bool idApproved);

  void paymentDismissed();

  void paymentInfo(PaymentStatus status);

}