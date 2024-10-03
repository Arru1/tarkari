class AddItemDTO {
  String? name;
  String? usernamePh;
  String? phonenumber;
  String? location;
  String? description;
  String? price;
  String? productImage;
  double? latitude;
  double? longitude;
  String? category;
  int? id;
  String? unit;
  String? sellerName;
  String? deliveryOption;
  int? availableQuantity;
  String? deliveryDescrip;
  double? haversineDistance;

  AddItemDTO({
    this.name,
    this.usernamePh,
    this.phonenumber,
    this.location,
    this.description,
    this.price,
    this.productImage,
    this.latitude,
    this.longitude,
    this.category,
    this.unit,
    this.sellerName,
    this.deliveryOption,
    this.availableQuantity,
    this.deliveryDescrip,
    this.id
  });

  AddItemDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    usernamePh = json['usernamePh'];
    phonenumber = json['phonenumber'];
    location = json['location'];
    description = json['description'];
    price = json['price'];
    productImage = json['productImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    category = json['category'];
    unit = json['unit'];
    sellerName = json['sellerName'];
    deliveryOption = json['deliveryOption'];
    availableQuantity = json['availableQuantity'];
    deliveryDescrip = json['deliveryDescrip'];
    id=json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['usernamePh'] = this.usernamePh;
    data['phonenumber'] = this.phonenumber;
    data['location'] = this.location;
    data['description'] = this.description;
    data['price'] = this.price;
    data['productImage'] = this.productImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['category'] = this.category;
    data['unit']= this.unit;
    data['sellerName'] = this.sellerName;
    data['deliveryOption'] = this.deliveryOption;
    data['availableQuantity'] = this.availableQuantity;
    data['deliveryDescrip'] = this.deliveryDescrip;
  
    return data;
  }
}
