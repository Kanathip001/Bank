import 'dart:ffi';

class Transactions {
  int? keyID;
  final String bankname;
  final String place;
  final String founder;
  final double asset;

  Transactions({
    this.keyID,
    required this.bankname,
    required this.place,
    required this.founder,
    required this.asset,
    
  });
}