import 'package:flutter/material.dart';

void main() {
  runApp(ProductCatalogueApp());
}

class ProductCatalogueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductCatalogueScreen(),
    );
  }
}

class ProductCatalogueScreen extends StatefulWidget {
  @override
  _ProductCatalogueScreenState createState() =>
      _ProductCatalogueScreenState();
}

class _ProductCatalogueScreenState extends State<ProductCatalogueScreen> {
  String selectedPriceRange = 'Any';
  String selectedBrand = 'Any';
  String selectedRating = 'Any';

  final List<String> priceRanges = ['Any', 'Below \$50', '\$50 - \$100', 'Above \$100'];
  final List<String> brands = ['Any', 'Brand A', 'Brand B', 'Brand C'];
  final List<String> ratings = ['Any', '1 star', '2 stars', '3 stars', '4 stars', '5 stars'];

 final List<Product> products = [
  Product('Laptop', 'Electronics', 'Brand A', 1200.00, 4, 'assets/images/laptop.png'),
  Product('Shirt', 'Men', 'Brand B', 45.99, 3, 'assets/images/shirt.png'),
  Product('Dress', 'Women', 'Brand C', 80.00, 5, 'assets/images/dress.png'),
  Product('Headphones', 'Electronics', 'Brand A', 200.00, 4, 'assets/images/headphones.png'),
  Product('Sneakers', 'Men', 'Brand B', 120.00, 4, 'assets/images/sneakers.png'),
  Product('Watch', 'Women', 'Brand C', 60.00, 3, 'assets/images/watch.png'),
  Product('Tablet', 'Electronics', 'Brand B', 350.00, 4, 'assets/images/laptop.png'),
  Product('T-Shirt', 'Men', 'Brand A', 25.99, 4, 'assets/images/shirt.png'),
  Product('Sunglasses', 'Women', 'Brand C', 50.00, 5, 'assets/images/dress.png'),
  Product('Smartphone', 'Electronics', 'Brand A', 800.00, 5, 'assets/images/laptop.png'),
  Product('Jacket', 'Men', 'Brand B', 120.00, 3, 'assets/images/shirt.png'),
  Product('Skirt', 'Women', 'Brand C', 40.00, 4, 'assets/images/dress.png'),
  Product('Camera', 'Electronics', 'Brand B', 500.00, 4, 'assets/images/headphones.png'),
  Product('Shoes', 'Men', 'Brand A', 75.00, 3, 'assets/images/sneakers.png'),
  Product('Bag', 'Women', 'Brand C', 30.00, 4, 'assets/images/watch.png'),
  Product('Smartwatch', 'Electronics', 'Brand A', 150.00, 4, 'assets/images/laptop.png'),
];


  List<Product> get filteredProducts {
    return products.where((product) {
      bool matchesPrice = (selectedPriceRange == 'Any' ||
          (selectedPriceRange == 'Below \$50' && product.price < 50) ||
          (selectedPriceRange == '\$50 - \$100' && product.price >= 50 && product.price <= 100) ||
          (selectedPriceRange == 'Above \$100' && product.price > 100));
      bool matchesBrand = product.brand == selectedBrand || selectedBrand == 'Any';
      bool matchesRating = product.rating == (selectedRating == 'Any' ? product.rating : int.tryParse(selectedRating.split(' ')[0])!);

      return matchesPrice && matchesBrand && matchesRating;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Catalogue'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
          Row(
            children: [
              DropdownButton<String>(
                value: selectedPriceRange,
                items: priceRanges
                    .map((range) => DropdownMenuItem(value: range, child: Text(range)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriceRange = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: selectedBrand,
                items: brands
                    .map((brand) => DropdownMenuItem(value: brand, child: Text(brand)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: selectedRating,
                items: ratings
                    .map((rating) => DropdownMenuItem(value: rating, child: Text(rating)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRating = value!;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180, // Give a separate space for each image
                        child: Image.asset(
                          product.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(product.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('\$${product.price}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text('Rating: ${product.rating}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedAddToCartButton(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String category;
  final String brand;
  final double price;
  final int rating;
  final String imagePath;

  Product(this.name, this.category, this.brand, this.price, this.rating, this.imagePath);
}

class AnimatedAddToCartButton extends StatefulWidget {
  @override
  _AnimatedAddToCartButtonState createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton> {
  bool _isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAddedToCart = !_isAddedToCart;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: _isAddedToCart ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          _isAddedToCart ? 'Added to Cart' : 'Add to Cart',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}