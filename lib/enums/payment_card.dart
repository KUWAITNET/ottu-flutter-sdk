enum PaymentCard {
  Amex,
  CartesBancaires,
  Discover,
  Eftpos,
  Electron,
  Elo,
  idCredit,
  Interac,
  JCB,
  Mada,
  Maestro,
  MasterCard,
  PrivateLabel,
  QuicPay,
  Suica,
  Visa,
  VPay
}

extension RawPaymentCard on PaymentCard {
  String get getRawValue {
    switch (this) {
      case PaymentCard.Amex:
        return "Amex";
      case PaymentCard.CartesBancaires:
        return "CartesBancaires";
      case PaymentCard.Discover:
        return "Discover";
      case PaymentCard.Eftpos:
        return "Eftpos";
      case PaymentCard.Electron:
        return "Electron";
      case PaymentCard.idCredit:
        return "idCredit";
      case PaymentCard.Interac:
        return "Interac";
      case PaymentCard.JCB:
        return "JCB";
      case PaymentCard.Maestro:
        return "Maestro";
      case PaymentCard.MasterCard:
        return "MasterCard";
      case PaymentCard.PrivateLabel:
        return "PrivateLabel";
      case PaymentCard.QuicPay:
        return "QuicPay";
      case PaymentCard.Suica:
        return "Suica";
      case PaymentCard.Visa:
        return "Visa";
      case PaymentCard.VPay:
        return "VPay";
      case PaymentCard.Elo:
        return "Elo";
      case PaymentCard.Mada:
        return "Mada";
      default:
        return "";
    }
  }
}
