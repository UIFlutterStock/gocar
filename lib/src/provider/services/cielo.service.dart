import 'package:flutter_cielo/flutter_cielo.dart';

class CieloService {

  Future<Sale> ExecutePagamento(Sale sale) async {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.SANDBOX, // ambiente de desenvolvimento
        merchant: Merchant(
          merchantId: "b959645a-3176-4ba3-b082-f2fb83fe5697",
          merchantKey: "AKGGXFXEDDJTNXNBVYYNITJNSVOTMNHCFWCQXIOC",
        ));
    try {
      return await cielo.createSale(sale);
    } catch (e) {
      return null;
    }
  }
}
