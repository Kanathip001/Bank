import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

  final nameCtl = TextEditingController();
  final placeCtl = TextEditingController();
  final founderCtl = TextEditingController();
  final assetCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'แบบฟอร์มเพิ่มข้อมูล',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 85, 75, 114)),
          ),
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
                          labelText: 'สินทรัพย์',
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      keyboardType: TextInputType.number,
                      controller: assetCtl,
                      validator: (String? input) {
                        try {
                          double amount = double.parse(input!);
                          if (amount < 0) {
                            return 'กรุณากรอกข้อมูลมากกว่า 0';
                          }
                        } catch (e) {
                          return 'กรุณากรอกข้อมูลเป็นตัวเลข';
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
                    ),
                  ),
          
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'ที่ตั้ง',
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      controller: placeCtl,
                    ),
                  ),
          
                  TextButton(
                      child: const Text(
                        'บันทึก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color.fromARGB(255, 85, 75, 114)),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // create transaction data object
                          var statement = Transactions(
                              keyID: null,
                              bankname: nameCtl.text,
                              asset: double.parse(assetCtl.text),
                              founder: founderCtl.text,
                              place:placeCtl.text,
                              );
          
                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(context, listen: false);
                          provider.addTransaction(statement);
          
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
