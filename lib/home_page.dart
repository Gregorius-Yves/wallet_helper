import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'add_note.dart';
import 'transaction_detail_dialog.dart';
import 'balance_card.dart';
import 'calendar_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime currentDate = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + offset);
    });
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF585CE5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color yellowColor = const Color(0xFFFFF78A);
    Color peachColor = const Color(0xFFF6A987);
    String formattedDate = DateFormat('MMM/yyyy').format(currentDate);

    return Scaffold(
      backgroundColor: yellowColor,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, Ripia!",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        "Selamat datang kembali",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.person, color: Colors.black54),
                  ),
                ],
              ),
            ),

            BalanceCard(
              formattedDate: formattedDate,
              onPrevMonth: () => _changeMonth(-1),
              onNextMonth: () => _changeMonth(1),
              onSelectMonth: _selectMonth,
              totalBalance: 1500000,
              totalIncome: 2500000,
              totalExpense: 1000000,
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: peachColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CalendarPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Text("Selengkapnya", style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildDateHeader("Thu, 31 Oct", "Rp32.000"),
                          _buildTransactionCard(
                            title: "Transportation", subtitle: "Gasoline", amount: -20000, icon: Icons.local_taxi, color: Colors.orange, dateStr: "31 Oct 2024",
                          ),
                          _buildTransactionCard(
                            title: "Food", subtitle: "Ayam Kremes Bu Las", amount: -12000, icon: Icons.fastfood, color: Colors.redAccent, dateStr: "31 Oct 2024",
                          ),
                          const SizedBox(height: 12),
                          _buildDateHeader("Wed, 30 Oct", "Rp362.000"),
                          _buildTransactionCard(
                            title: "Clothes", subtitle: "Hoodie H&M", amount: -350000, icon: Icons.checkroom, color: Colors.blueAccent, dateStr: "30 Oct 2024",
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SizedBox(
          width: 55,
          height: 55,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotePage()));
            },
            backgroundColor: const Color(0xFFFDE047),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: const Icon(Icons.add, size: 32, color: Colors.black),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Statistics"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date, String totalExpense) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
              Text(date, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[700])),
            ],
          ),
          Text("Expenses: $totalExpense", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String title, required String subtitle, required int amount, required IconData icon, required Color color, required String dateStr,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return TransactionDetailDialog(
              title: title, subtitle: subtitle, amount: amount, icon: icon, color: color, date: dateStr,
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Text(
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: amount < 0 ? const Color(0xFFFF5252) : Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}