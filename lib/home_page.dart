import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("WalletHelper"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada transaksi."),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final title = data['title'];
              final amount = data['amount'];
              final type = data['type'];

              return ListTile(
                leading: Icon(
                  type == "income" ? Icons.arrow_downward : Icons.arrow_upward,
                  color: type == "income" ? Colors.green : Colors.red,
                ),
                title: Text(title),
                subtitle: Text(type.toUpperCase()),
                trailing: Text(
                  "Rp $amount",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: type == "income" ? Colors.green : Colors.red),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addDummyTransaction(uid);
        },
      ),
    );
  }

  void addDummyTransaction(String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add({
      "title": "Dummy Transaction",
      "amount": 10000,
      "type": "expense",
      "created": Timestamp.now(),
    });
  }
}
