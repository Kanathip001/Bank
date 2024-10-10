import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final banknameCtl = TextEditingController();
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
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 74, 61),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildTextField(
                  label: 'ชื่อธนาคาร',
                  controller: banknameCtl,
                ),
                _buildTextField(
                  label: 'สินทรัพย์',
                  controller: assetCtl,
                  keyboardType: TextInputType.number,
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
                _buildTextField(
                  label: 'ผู้ก่อตั้ง',
                  controller: founderCtl,
                ),
                _buildTextField(
                  label: 'ที่ตั้ง',
                  controller: placeCtl,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 74, 61),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: const Text(
                    'บันทึก',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var statement = Transactions(
                        keyID: null,
                        bankname: banknameCtl.text,
                        asset: double.parse(assetCtl.text),
                        founder: founderCtl.text,
                        place: placeCtl.text,
                      );

                      var provider = Provider.of<TransactionProvider>(context, listen: false);
                      provider.addTransaction(statement);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10),
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
