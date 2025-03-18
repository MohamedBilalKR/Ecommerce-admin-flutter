import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String doorNo;
  final String country;
  final DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.doorNo,
    required this.country,
    this.dateTime,
    this.selectedAddress = true,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
        id: '',
        name: '',
        phoneNumber: '',
        street: '',
        city: '',
        state: '',
        doorNo: '',
        country: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'DoorNo': doorNo,
      'Country': country,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    try {
      return AddressModel(
        id: map['Id'] ?? '', // Provide default value if null
        doorNo: map['DoorNo'] ?? '', // Provide default value if null
        state: map['State'] ?? '',
        selectedAddress: map['SelectedAddress'] ?? false,
        country: map['Country'] ?? '',
        phoneNumber: map['PhoneNumber'] ?? '', // This might be null
        street: map['Street'] ?? '',
        city: map['City'] ?? '',
        dateTime:
            (map['DateTime'] as Timestamp?)?.toDate(), // Handle null safely
        name: map['Name'] ?? '',
      );
    } catch (e) {
      throw "Error parsing Address: $e";
    }
  }

  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return AddressModel(
      id: snapshot.id,
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      state: data['State'] ?? '',
      doorNo: data['DoorNo'] ?? '',
      country: data['Country'] ?? '',
      dateTime: (data['DateTime'] as Timestamp).toDate(),
      selectedAddress: data['SelectedAddress'] ?? false,
    );
  }

  @override
  String toString() {
    return '$doorNo, $street, $city, $state, $country';
  }
}
