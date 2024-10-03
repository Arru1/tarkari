import 'package:dio/dio.dart';
import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/mapforprodet.dart';
import 'package:final_year_project/views/orderform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool showMore = false;
  late TapGestureRecognizer readMoreGestureRecognizer;

  @override
  void initState() {
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.product.image,
                    ))),
          ),
          Row(
            children: [
              Text(widget.product.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: const Color.fromARGB(255, 11, 109, 14))),
              const Spacer(),
              Text(
                "Rs ${widget.product.price}",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.green,
                    ),
              ),
              Text(
                " per ${widget.product.unit}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text("Available Quantity : ", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),),
               
              Text('${widget.product.availableQuantity} ${widget.product.unit}')
            ],
          ),
          
 const SizedBox(
            height: 5,
          ),
          
          Text(
            "Product Description:",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showMore
                      ? widget.product.description
                      : widget.product.description.length > 10
                          ? "${widget.product.description.substring(0, widget.product.description.length - 10)}..."
                          : widget.product.description,
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showMore ? "     Read less" : "    Read more", 
                  style: TextStyle(
                    color: Colors.black,fontWeight:FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [],
                ),
              )
            ],
          ),
          // SizedBox(height: 5),
         GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreenProduct(latitude:widget.product.lat!,longitude:widget.product.longi!,sellername:widget.product.sellerName!)// Replace AnotherPage with the page you want to navigate to
      ),
    );
  },
  child: Row(
    children: [
      Icon(
        Icons.location_on,
        color: Colors.green,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          children: [
            Text("${widget.product.location}",style: TextStyle(color: Color.fromARGB(255, 9, 199, 56)),),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                '(${widget.product.haversineDistance!.toStringAsFixed(2)} km away)',
              ),
            )
          ],
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 15),
          Text(
            "Delivery  : ${widget.product.deliveryOption}",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 15),
          Text("Delivery Description:",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: widget.product.deliveryOption == "Not Available"
                      ? 'Pickup from Seller'
                      : (showMore
                          ? widget.product.deliveryDescrip
                          : (widget.product.deliveryDescrip.length > 10
                              ? "${widget.product.deliveryDescrip.substring(0, widget.product.deliveryDescrip.length - 10)}..."
                              : widget.product.deliveryDescrip)),
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showMore ? "   Read less" : "    Read more",
                  style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "Seller : ${widget.product.sellerName}",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                // child: Icon(
                //   Icons.star,
                //   size: 20,
                //   color: Color.fromARGB(255, 28, 211, 11),
                // ),
              ),
             // Text("  ${widget.product.rating}"),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),

          const SizedBox(height: 20),
          // Text(
          //   "Related products",
          //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //         fontWeight: FontWeight.bold,
          //       ),
          // ),
          const SizedBox(height: 10),
          // SizedBox(
          //   height: 90,
          //   child: ListView.separated(
          //       physics: const BouncingScrollPhysics(),
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           height: 90,
          //           width: 80,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(9),
          //             image: DecorationImage(
          //                 fit: BoxFit.cover,
          //                 image: NetworkImage(
          //                   products[index].image,
          //                 )),
          //           ),
          //         );
          //       },
          //       separatorBuilder: (context, index) => const SizedBox(
          //             width: 10,
          //           ),
          //       itemCount: products.length),
          // ),
          const SizedBox(height: 20),
        Row(
  children: [
    SizedBox(width: 23,),
    FilledButton.icon(
      onPressed: () async {
        String phoneNumber = widget.product.seller_ph.toString();
        String url = 'tel:$phoneNumber';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      label: const Text("Call Seller"),
      icon: const Icon(IconlyLight.call),
    ),
    SizedBox(width: 10),
  Visibility(
    visible: widget.product.deliveryOption=="Available"?true : false,
      child: FilledButton.icon(
        onPressed: () {
         Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) =>  OrderFormWidget(
      productName: widget.product.name,
      quantity: widget.product.availableQuantity,
      price: widget.product.price,
      product: widget.product,
      sellerName: widget.product.sellerName,
      id: widget.product.id,
      sellerPh:widget.product.usernamePh, 
      unit:widget.product.unit,
      bechdakophone:widget.product.seller_ph,
    ),
  ),
);
            //pay();
          
        },
        label: const Text("Buy Now"),
        icon:Icon(IconlyLight.buy)),
    ),
       
     
    
  ],
)


        ],
      ),
    );
    
  }
  pay()
  {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(amount: (widget.product.price * 100).toInt(), productIdentity: 'fzone{widget.product.id.toString()}', productName: widget.product.name),
      preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking
      ],
     onSuccess: (value){verify(value.token, value.amount);}, 
     onFailure: (value){}
     );
  }
  verify(String token, int amount) async
  {
    Dio dio = Dio();
    dio.options.headers={
"content-type":"application/json",
"authorization":"Key test_secret_key_c9509c35a585441887dede250864c05e"

    };
    var jsonData={
      "token":token,
      "amount":amount
    };
    try{
   var response= await dio.post("https://khalti.com/api/v2/payment/verify/",data: jsonData);
   if(response.statusCode==200)
   {
print(response.data);
print("Hello KHalti");
   }
   else{
    print(response.statusCode);
    print('mareko khalti');
   }
    }catch(e){print(e);}
  }
}
