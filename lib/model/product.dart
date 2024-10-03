class Product {
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;
  final String? sellerName;
  final String? location;
 final String? deliveryOption;
final int? availableQuantity;
final String? seller_ph;
final double? lat;
final double? longi;
final String? usernamePh;
int? id;
 final String deliveryDescrip;
 final String? category;
 final double? haversineDistance;
  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.rating,
    required this.sellerName,
    required this.location,
    required this.deliveryOption,
    required this.deliveryDescrip,
    required this.availableQuantity,
    required this.category,
    required this.id,
    required this.haversineDistance,
    required this.seller_ph,
    required this.lat,
    required this.longi,
    required this.usernamePh,
    
  });
}
