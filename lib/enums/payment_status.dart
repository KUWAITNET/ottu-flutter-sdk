enum PaymentStatus {

  Eligible

  /// This means the current device/user has Apple pay activated but has no card belongs to the given payment networks
  ,
  NeedSetup

  /// This means the current device/user cannot use Apple pay from Apple
  ,
  NotEligible

  /// This means the to setup sessionID in Checkot
  ,
  SessionIDNotSetuped

  /// This means the to setup domainURL in Checkot
  ,
  DomainURLNotSetuped,
  CodeNotSetuped

}

class PaymentStatusHelper{
  static PaymentStatus fromString(String status) {
    switch (status){
      case "Eligible":
        return PaymentStatus.Eligible;

      case"NeedSetup":
        return PaymentStatus.NeedSetup;

      case"NotEligible":
        return PaymentStatus.NotEligible;

      case"SessionIDNotSetuped":
        return PaymentStatus.SessionIDNotSetuped;

      case"DomainURLNotSetuped":
        return PaymentStatus.DomainURLNotSetuped;
        
      case"CodeNotSetuped":
        return PaymentStatus.CodeNotSetuped;

      default:
        return PaymentStatus.NeedSetup;
    }
  }
}

extension RawStatus on PaymentStatus {

  String get getDescription {
    switch (this) {
      case PaymentStatus.Eligible:
        return "Eligible, This means the current device/user has Apple pay activated and a card belongs to the given payment networks";
      case PaymentStatus.NeedSetup:
        return "NeedSetup, This means the current device/user has Apple pay activated but has no card belongs to the given payment networks";
      case PaymentStatus.NotEligible:
        return "NotEligible, This means the current device/user cannot use Apple pay from Apple";
      case PaymentStatus.DomainURLNotSetuped:
        return "NeedSetup, This means the to setup domainURL in Checkot";
      case PaymentStatus.SessionIDNotSetuped:
        return "NeedSetup, This means the to setup sessionID in Checkot";
      case PaymentStatus.CodeNotSetuped:
        return "NeedSetup, This means the to setup code in Checkot";
      default:
        return "";
    }
  }
}
