import 'package:account/provider/transaction_provider.dart';
import 'package:account/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 74, 61),
        title: const Text(
          "Bank",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหารายการ...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final filteredTransactions = provider.transactions.where((transaction) {
            return transaction.bankname.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          if (filteredTransactions.isEmpty) {
            return const Center(
              child: Text(
                'ไม่มีรายการ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                var statement = filteredTransactions[index];
                return Dismissible(
                  key: Key(statement.keyID.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    provider.deleteTransaction(statement.keyID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ลบ ${statement.bankname} เรียบร้อยแล้ว')),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Text(
                        statement.bankname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ที่ตั้ง: ${statement.place}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          Text('ผู้ก่อตั้ง: ${statement.founder}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          Text('สินทรัพย์: ${statement.asset.toInt()} ล้านบาท', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 255, 73, 73),
                        child: Text(
                          statement.bankname[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 45,
                        ),
                        onPressed: () {
                          provider.deleteTransaction(statement.keyID);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditScreen(statement: statement);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}