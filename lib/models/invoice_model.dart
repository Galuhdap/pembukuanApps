import 'package:fajarjayaspring_app/models/customer_model.dart';
import 'package:fajarjayaspring_app/models/suplaier_model.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final InvoiceSub sub;
  final List<InvoiceItem> items;


  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.sub,
    required this.items,
  });
}

class InvoiceInfo {
  final DateTime date;
  final String pay;
  final String kode_invoice;

  const InvoiceInfo({
    required this.date,
    required this.pay,
    required this.kode_invoice,
  });
}

class InvoiceSub {
  final int subtotal;
  final int ongkir;
  final int lain;
  final int potongan;
  final int total;

  const InvoiceSub({
    required this.subtotal,
    required this.ongkir,
    required this.lain,
    required this.potongan,
    required this.total,
  });
}
class InvoiceItem {
  final String description;
  final int quantity;
  final int total;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.total,
  });
}
