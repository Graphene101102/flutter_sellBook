import 'dart:convert';

class Invoice {
  late final String customerName;
  late final int quantity;
  late final double price;
  late final double totalAmount;
  late final bool isPaid;
  late final bool isVip;

  Invoice({
    required this.customerName,
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.isPaid,
     required this.isVip,
  });

Invoice.fromJson(Map<String, dynamic> json) {
   customerName = json['customerName'];
    quantity = json['quantity'];
    price = json['price'];
    totalAmount = json['totalAmount'];
    isPaid = json['isPaid'];
    isVip = json['isVip'];
  }

  Map<String, dynamic> toJson() {
    return {
    'customerName': customerName, 'quantity': quantity, 'price': price, 'totalAmount': totalAmount, 'isPaid': isPaid,'isVip':isVip};
  }
}
