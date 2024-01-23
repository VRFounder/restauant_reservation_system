import 'menu_item.dart';

class Menu {
  List<MenuItem> items;

  Menu(this.items);

  void displayMenu() {
    for (var item in items) {
      print('${item.name} - \$${item.price}\nIngredients: ${item.ingredients}\n');
    }
  }

  void addMenuItem(String name, double price, String ingredients) {
    items.add(MenuItem(name: name, price: price, ingredients: ingredients));
  }

  void removeMenuItem(String name) {
    items.removeWhere((item) => item.name == name);
  }

  void updateMenuItem(String name, double newPrice, String newIngredients) {
    for (var item in items) {
      if (item.name == name) {
        item.price = newPrice;
        item.ingredients = newIngredients;
        return;
      }
    }
    print('Item not found.');
  }

  List<MenuItem> searchMenuItems(String keyword) {
    return items.where((item) =>
    item.name.toLowerCase().contains(keyword.toLowerCase()) ||
        item.ingredients.toLowerCase().contains(keyword.toLowerCase())).toList();
  }
}

