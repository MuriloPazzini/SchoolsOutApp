import 'package:schools_out/entities/comicsPage.dart';

class Comics {
  List<ComicsPage> pages;
  String name;
  int edition;
  List<int> previewPages;
  double price;
  String description;
  String id;

  Comics(this.name, this.edition, this.pages, this.description, this.price, this.id);
}
