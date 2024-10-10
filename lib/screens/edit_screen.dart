import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Transactions statement;

  const EditScreen({super.key, required this.statement});

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
  void initState() {
    super.initState();
    nameCtl.text = widget.statement.bankname;
    placeCtl.text = widget.statement.place;
    founderCtl.text = widget.statement.founder;
    assetCtl.text = widget.statement.asset.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูล'),
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
                  controller: nameCtl,
                ),
                _buildTextField(
                  label: 'ที่ตั้ง',
                  controller: placeCtl,
                ),
                _buildTextField(
                  label: 'ผู้ก่อตั้ง',
                  controller: founderCtl,
                ),
                _buildTextField(
                  label: 'สินทรัพย์',
                  controller: assetCtl,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 74, 61), // ปรับสีพื้นหลัง
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // เพิ่มมุมมน
                    ),
                  ),
                  child: const Text(
                    'แก้ไขข้อมูล',
                    style: TextStyle(fontSize: 18, color: Colors.white), // ปรับสีข้อความ
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var statement = Transactions(
                        keyID: widget.statement.keyID,
                        bankname: nameCtl.text,
                        place: placeCtl.text,
                        founder: founderCtl.text,
                        asset: double.parse(assetCtl.text),
                      );

                      var provider = Provider.of<TransactionProvider>(context, listen: false);
                      provider.updateTransaction(statement);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // ทำให้ขอบมน
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: (String? str) {
          if (str!.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
      ),
    );
  }
}
