class Transaction {
  int? id;
  String? buyerContact;
  String? buyerName;
  String? productName;
  String? boughtQuantity;
  String? deliveryAddress;
  String? deliveryContact;
  String? sellerContact;
  int? changedQuantity;
  double? price;
  String? bechdakophone;

  Transaction({
     this.id,
    this.buyerContact,
     this.buyerName,
     this.productName,
    this.boughtQuantity,
     this.deliveryAddress,
     this.deliveryContact,
     this.sellerContact,
     this.changedQuantity,
     this.price,
     this.bechdakophone,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      buyerContact: json['buyerContact'],
      buyerName: json['buyerName'],
      productName: json['productName'],
      boughtQuantity: json['boughtQuantity'],
      deliveryAddress: json['deliveryAddress'],
      deliveryContact: json['deliveryContact'],
      sellerContact: json['sellerContact'],
      changedQuantity: json['changedQuantity'],
      price: json['price'].toDouble(),
      bechdakophone: json['bechdakophone']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerContact': buyerContact,
      'buyerName': buyerName,
      'productName': productName,
      'boughtQuantity': boughtQuantity,
      'deliveryAddress': deliveryAddress,
      'deliveryContact': deliveryContact,
      'sellerContact': sellerContact,
      'changedQuantity': changedQuantity,
      'price': price,
      'bechdakophone':bechdakophone,
    };
  }
}
