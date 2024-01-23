import 'dart:io';
import 'package:restaurant_reservation_system/menu_item.dart';
import 'package:restaurant_reservation_system/menu.dart';
import 'package:restaurant_reservation_system/restaurant.dart';
import 'package:restaurant_reservation_system/table.dart';
import 'package:restaurant_reservation_system/reservation.dart';

void main() {
  var restaurant = Restaurant("Gourmet Place", "123 Flavor Street", [
    Table(id: 1, seats: 2, ),
    Table(id: 2, seats: 4),
    Table(id: 3, seats: 4),
    Table(id: 4, seats: 6),
    Table(id: 5, seats: 8)
  ]);

  var menu = Menu([
    MenuItem(name: "Pizza", price: 9.99, ingredients: "Cheese, Tomato"),
    MenuItem(name: "Pasta", price: 12.99, ingredients: "Pasta, Pesto Sauce"),
    MenuItem(name: "Grilled Salmon", price: 15.99, ingredients: "Salmon, Lemon Herb Seasoning"),
    MenuItem(name: "Caesar Salad", price: 7.99, ingredients: "Romaine Lettuce, Croutons, Parmesan"),
    MenuItem(name: "Chicken Curry", price: 13.99, ingredients: "Chicken, Curry Sauce, Rice"),
    MenuItem(name: "Vegan Burger", price: 11.99, ingredients: "Plant-based Patty, Lettuce, Tomato"),
    MenuItem(name: "Tiramisu", price: 6.99, ingredients: "Mascarpone, Espresso"),
    MenuItem(name: "Steak", price: 18.99, ingredients: "Grilled Steak, Mashed Potatoes"),
    MenuItem(name: "Sushi Platter", price: 20.99, ingredients: "Assorted Sushi and Sashimi"),
    MenuItem(name: "Lobster Bisque", price: 14.99, ingredients: "Lobster, Creamy Soup")
  ]);

  while (true) {
    print("\nWelcome to ${restaurant.name} Reservation System");
    print("1. Display Menu");
    print("2. Make a Reservation");
    print("3. Display Reserved Tables");
    print("4. Exit");

    stdout.write("Enter your choice: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        menu.displayMenu();
        break;
      case '2':
        makeReservation(restaurant, menu);
        break;
      case '3':
        displayReservedTables(restaurant);
        break;
      case '4':
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void makeReservation(Restaurant restaurant, Menu menu) {
  stdout.write("Enter customer name: ");
  String customerName = stdin.readLineSync() ?? "";
  stdout.write("Enter date (yyyy-mm-dd): ");
  DateTime date = DateTime.tryParse(stdin.readLineSync() ?? "") ?? DateTime.now();
  stdout.write("Enter time (HH:mm): ");
  String time = stdin.readLineSync() ?? "";
  stdout.write("Enter number of guests: ");
  int numberOfGuests = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;

  var availableTables = restaurant.getAvailableTables(numberOfGuests, date, time);
  if (availableTables.isEmpty) {
    print("No available tables for the selected date and time.");
    return;
  }

  print("Available Tables:");
  for (var table in availableTables) {
    print("Table ID: ${table.id}, Seats: ${table.seats}");
  }

  stdout.write("Enter table ID to reserve: ");
  int tableId = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;

  var initialMeals = chooseMealsFromMenu(menu);

  var reservation = Reservation(customerName: customerName, date: date, time: time, numberOfGuests: numberOfGuests, menu: menu, selectedMeals: initialMeals);
  if (restaurant.reserveTable(tableId, reservation)) {
    print("Table reserved successfully.");
    print(reservation);
  } else {
    print("Failed to reserve table.");
  }
}

void displayReservedTables(Restaurant restaurant) {
  var today = DateTime.now();

  var reservedToday = restaurant.reservedTables.where((table) {
    for (var reservation in table.reservations) {
      if (reservation.date.year == today.year &&
          reservation.date.month == today.month &&
          reservation.date.day == today.day) {
        return true;
      }
    }
    return false;
  }).toList();

  if (reservedToday.isEmpty) {
    print("No tables are reserved for today.");
    return;
  }

  print("Tables Reserved for Today:");
  for (var table in reservedToday) {
    print("Table ID: ${table.id}, Seats: ${table.seats}");
  }
}


Map<MenuItem, int> chooseMealsFromMenu(Menu menu) {
  print("Choose meals from the menu:");
  menu.displayMenu();
  Map<MenuItem, int> selectedMeals = <MenuItem, int>{};

  while (true) {
    stdout.write("Enter the name of a meal to add (or 'done' to finish): ");
    var mealName = stdin.readLineSync()?.trim().toLowerCase();

    if (mealName == 'done') {
      break;
    }
    else if (mealName == null) {
      continue;
    }

    var meal = menu.searchMenuItems(mealName).firstWhere(
            (item) => !selectedMeals.containsKey(item));

    stdout.write("Enter quantity for ${meal.name}: ");
    int quantity = int.tryParse(stdin.readLineSync() ?? "1") ?? 1;
    if (selectedMeals.containsKey(meal)) {
      selectedMeals[meal] = selectedMeals[meal]! + quantity;
    } else {
      selectedMeals[meal] = quantity;
    }
  }

  return selectedMeals;
}