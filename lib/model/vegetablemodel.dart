

class DailyPrice {
  final String commodityName;
  final String commodityUnit;
  final String minPrice;
  final String maxPrice;
  final String avgPrice;

  DailyPrice({
    required this.commodityName,
    required this.commodityUnit,
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
  });

  factory DailyPrice.fromJson(Map<String, dynamic> json) {
    return DailyPrice(
      commodityName: json['commodityname'],
      commodityUnit: json['commodityunit'],
      minPrice: json['minprice'],
      maxPrice: json['maxprice'],
      avgPrice: json['avgprice'],
    );
  }
}

