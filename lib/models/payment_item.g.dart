// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentItem _$PaymentItemFromJson(Map<String, dynamic> json) {
  return PaymentItem(
    json['label'] as String,
    json['amount'] as double,
  );
}

Map<String, dynamic> _$PaymentItemToJson(PaymentItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
    };
