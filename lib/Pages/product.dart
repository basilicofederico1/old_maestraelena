//create object product and initialize it
class Product {
  late final String name;
  late final String mainImage;
  late final String description;
  late final double price;
  late final String link;
  late final String category;

  Product(this.category, this.name, this.link, this.price, this.mainImage,
      this.description);
}
