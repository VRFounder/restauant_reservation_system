import 'dart:io';
import 'menu.dart';
import 'menu_item.dart';
import 'restaurant.dart';
import 'table.dart';
import 'reservation.dart';

void main() {
  List<Reservation> reservations = [];

  var restaurant = Restaurant("Gourmet Place", "123 Flavor Street", [
    Table(id: 1, seats: 2, ), // Table for 2 guests
    Table(id: 2, seats: 4), // Table for 4 guests
    Table(id: 3, seats: 4),
    Table(id: 4, seats: 6), // Table for 6 guests
    Table(id: 5, seats: 8)  // Table for 8 guests

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
    print("4. Display Reservations List");
    print("0. Exit");

    stdout.write("Enter your choice: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        menu.displayMenu();
        break;
      case '2':
        makeReservation(restaurant, menu, reservations);
        break;
      case '3':
        displayReservedTables(restaurant);
        break;
      case '4':
        displayReservations(reservations);
        break;
      case '0':
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void makeReservation(Restaurant restaurant, Menu menu, List<Reservation> reservations) {
  stdout.write("Enter customer name: ");
  String customerName = stdin.readLineSync() ?? "";
  late String dateString;
  stdout.write("Enter date (yyyy-mm-dd): ");
  do{
    dateString = stdin.readLineSync() ?? "";
  }while(!isValidReservationDate(dateString));
  DateTime date = DateTime.parse(dateString);
  stdout.write("Enter time (HH:mm): ");
  String time = stdin.readLineSync() ?? "";
  stdout.write("Enter number of guests: ");
  int numberOfGuests = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;

  var availableTables = restaurant.getAvailableTables(numberOfGuests, date, time);
  if (availableTables.isEmpty) {
    print("No available tables for the selected date and time.");
    return;
  }
  List<int> availableTablesID = [];
  print("Available Tables:");
  for (var table in availableTables) {
    print("Table ID: ${table.id}, Seats: ${table.seats}");
    availableTablesID.add(table.id);
  }

  stdout.write("Enter table ID to reserve: ");
  late int tableId;
  while(true){
    tableId = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;
    if(availableTablesID.contains(tableId)){
      break;
    }
    else{
      print('ID is invalid:');
      stdout.write('Enter table ID from list above: ');
    }
  }

  var initialMeals = chooseMealsFromMenu(menu);

  var reservation = Reservation(customerName: customerName, date: date, time: time, numberOfGuests: numberOfGuests, menu: menu, selectedMeals: initialMeals);
  if (restaurant.reserveTable(tableId, reservation)) {
    reservations.add(reservation);
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

bool isValidReservationDate(String? dateString) {
  late DateTime date;
  if (dateString != null) {
    date = DateTime.parse(dateString);
  }else{
    print('Please enter valid date in the given format (yyyy-MM-dd): ');
    return false;
  }

  if (dateString == "" || !date.toString().contains(dateString)){
    print('Please enter valid date in the given format (yyyy-MM-dd): ');
    return false;
  }

  var currentDate = DateTime.now();

  if (date.isBefore(DateTime(currentDate.year, currentDate.month, currentDate.day))) {
    print('Reservation date cannot be in the past');
    stdout.write("Enter date (yyyy-mm-dd): ");
    return false;
  }

  return true;
}

void displayReservations(List<Reservation> reservations) {
  if (reservations.isEmpty) {
    print("There are no reservations.");
    return;
  }

  print("\nList of Reservations:");
  for (var reservation in reservations) {
    print("Customer Name: ${reservation.customerName}");
    print("Date: ${reservation.date.toString().substring(0, 10)}");
    print("Time: ${reservation.time}");
    print("Number of Guests: ${reservation.numberOfGuests}");
    print("Table ID: ${reservation.table?.id}");
    print("Selected Meals:");
    reservation.selectedMeals.forEach((meal, quantity) {
      print(" - ${meal.name}: $quantity");
    });
    print("");
    print("");
  }
}