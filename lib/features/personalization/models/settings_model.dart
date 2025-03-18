import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final String? id;
  double taxRate;
  double shippingCost;
  double? freeShippingThreshold;
  String appName;
  String appLogo;

  SettingsModel({
    this.id,
    this.taxRate = 0.0,
    this.shippingCost = 0.0,
    this.freeShippingThreshold,
    this.appName = '',
    this.appLogo = '',
  });

  //COnvert Model to Json
  Map<String, dynamic> toJson() {
    return {
      'TaxRate': taxRate,
      'ShippingCost': shippingCost,
      'FreeShippingThreshold': freeShippingThreshold,
      'AppName': appName,
      'AppLogo': appLogo,
    };
  }

  //Factory method to create document snapshot
  factory SettingsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return SettingsModel(
        id: document.id,
        taxRate: (data['TaxRate'] as num?)?.toDouble() ?? 0.0,
        shippingCost: (data['ShippingCost'] as num?)?.toDouble() ?? 0.0,
        freeShippingThreshold: (data['FreeShippingThreshold'] as num?)?.toDouble() ?? 0.0,
        appName: data['AppName'] ?? '',
        appLogo: data['AppLogo'] ?? '',
      );
    }
    // Return a default SettingsModel instance if the document data is null
    return SettingsModel(
      id: '',
      taxRate: 0.0,
      shippingCost: 0.0,
      freeShippingThreshold: 0.0,
      appName: '',
      appLogo: '',
    );
  }
}
