import 'package:bluetooth_thermal_printer_example/controllers/kasir/kasirC.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransaksiP extends StatelessWidget {
  final KasirC controller = Get.put(KasirC());
  final currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Riwayat Transaksi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Lunas',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Tidak Lunas',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTransactionList(),
            _buildTransactionListKasbon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Obx(() {
      if (controller.isLoading.value && controller.transaksiLunas.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.transaksiLunas.isEmpty) {
        return const Center(child: Text('Koperasi Anugrah Artha Abadi'));
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.loadMoreTransaksiLunas();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transaksiLunas.length +
              (controller.isLastPageLunas.value ? 0 : 1),
          itemBuilder: (context, index) {
            if (index == controller.transaksiLunas.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final transaction = controller.transaksiLunas[index];
            return _buildTransactionItem(transaction, false);
          },
        ),
      );
    });
  }

  Widget _buildTransactionListKasbon() {
    return Obx(() {
      if (controller.isLoading.value && controller.transaksiKasbon.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.transaksiKasbon.isEmpty) {
        return const Center(child: Text('Koperasi Anugrah Artha Abadi'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.transaksiKasbon.length,
        itemBuilder: (context, index) {
          final transaction = controller.transaksiKasbon[index];
          return _buildTransactionItem(transaction, true);
        },
      );
    });
  }

  Widget _buildTransactionItem(
      Map<String, dynamic> transaction, bool isKasbon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. ${transaction['no_transaksi_out']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(transaction['input_date']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (isKasbon ? '- ' : '') +
                        currencyFormat
                            .format(int.parse(transaction['total_transaksi'])),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isKasbon ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction['jumlah_produk']} item',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(date);
  }
}
