import 'package:json_annotation/json_annotation.dart';


part 'payment_item.g.dart';

@JsonSerializable()
class PaymentItem {

  PaymentItem(this.label, this.amount);
  /// item name
  @JsonKey(name: 'label') String label;

  /// item cost
  @JsonKey(name: 'amount') double amount;

  factory PaymentItem.fromJson(Map<String,dynamic> json) => _$PaymentItemFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentItemToJson(this);
}
