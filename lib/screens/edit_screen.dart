import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  Transactions statement;

  EditScreen({super.key, required this.statement});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();

  final nameCtl = TextEditingController();
  final assetCtl = TextEditingController();
  final founderCtl = TextEditingController();
  final placeCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameCtl.text = widget.statement.bankname;
    placeCtl.text = widget.statement.place;
    founderCtl.text = widget.statement.founder;
    assetCtl.text = widget.statement.asset.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text('แบบฟอร์มแก้ไขข้อมูล'),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'ชื่อธนาคาร',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        autofocus: false,
                        controller: nameCtl,
                        validator: (String? str) {
                          if (str!.isEmpty) {
                            return 'กรุณากรอกข้อมูล';
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'ที่ตั้ง',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        autofocus: false,
                        controller: nameCtl,
                        validator: (String? str) {
                          if (str!.isEmpty) {
                            return 'กรุณากรอกข้อมูล';
                          }
                        },
                      ),
                    ),
            
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'ผู้ก่อตั้ง',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        controller: founderCtl,
                        validator: (String? str) {
                          if (str!.isEmpty) {
                            return 'กรุณากรอกข้อมูล';
                          }
                        },
                      ),
                    ),
            
                    Container(
                      margin: const EdgeInsets.all(30),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'สินทรัพย์',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        controller: assetCtl,
                        validator: (String? str) {
                          if (str!.isEmpty) {
                            return 'กรุณากรอกข้อมูล';
                          }
                        },
                      ),
                    ),
                    
                  TextButton(
                      child: const Text('แก้ไขข้อมูล'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // create transaction data object
                          var statement = Transactions(
                                keyID: widget.statement.keyID,
                                bankname: nameCtl.text,
                                place: placeCtl.text,
                                founder: founderCtl.text,
                                asset:double.parse(assetCtl.text),
                                );

                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(context, listen: false);
                          provider.updateTransaction(statement);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) {
                                    return MyHomePage();
                                  }));
                        }
                      })
                ],
              )),
        ));
  }
}
