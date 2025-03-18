import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.shippingAddress,
    this.billingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';

  static OrderModel empty() => OrderModel(
        id: '',
        items: [],
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        totalAmount: 0,
        shippingCost: 0,
        taxCost: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserId': userId,
      'Status': status.toString(),
      'TotalAmount': totalAmount,
      'ShippingCost': shippingCost,
      'TaxCost': taxCost,
      'OrderDate': orderDate,
      'PaymentMethod': paymentMethod,
      'ShippingAddress': shippingAddress?.toJson(),
      'BillingAddress': billingAddress?.toJson(),
      'DeliveryDate': deliveryDate,
      'BillingAddressSameAsShipping': billingAddressSameAsShipping,
      'Items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;

      return OrderModel(
        docId: snapshot.id,
        id: data['Id'] ?? '',
        userId: data['UserId'] ?? '',
        status: data.containsKey('Status')
            ? OrderStatus.values.firstWhere((e) => e.toString() == data['Status'])
            : OrderStatus.processing,
        totalAmount: (data['TotalAmount'] as num?)?.toDouble() ?? 0.0,
        shippingCost: (data['ShippingCost'] as num?)?.toDouble() ?? 0.0,
        taxCost: (data['TaxCost'] as num?)?.toDouble() ?? 0.0,
        orderDate: data['OrderDate'] is Timestamp
            ? (data['OrderDate'] as Timestamp).toDate()
            : DateTime.now(),
        paymentMethod: data['PaymentMethod'] ?? 'Cash on Delivery',
        billingAddressSameAsShipping:
            data['BillingAddressSameAsShipping'] ?? true,
        billingAddress: data['BillingAddress'] != null
            ? AddressModel.fromMap(
                data['BillingAddress'] as Map<String, dynamic>)
            : null,
        shippingAddress: data['ShippingAddress'] != null
            ? AddressModel.fromMap(
                data['ShippingAddress'] as Map<String, dynamic>)
            : null,
        deliveryDate: data['DeliveryDate'] is Timestamp
            ? (data['DeliveryDate'] as Timestamp).toDate()
            : null,
        items: data['Items'] != null
            ? (data['Items'] as List<dynamic>)
                .map((itemData) =>
                    CartItemModel.fromJson(itemData as Map<String, dynamic>))
                .toList()
            : [],
      );
    } catch (e) {
      throw "Error parsing order data: $e";
    }
  }
}
