import 'dart:io';

import 'package:intl/intl.dart';

import 'table.dart';
import 'menu.dart';
import 'menu_item.dart';

class Reservation {
  String customerName;
  DateTime date;
  String time;
  int numberOfGuests;
  Menu menu;
  Map<MenuItem, int> selectedMeals;
  double totalPrice;
  Table? table;

  Reservation({
    required this.customerName,
    required this.date,
    required this.time,
    required this.numberOfGuests,
    required this.menu,
    required this.selectedMeals,
  }) : totalPrice = 0 {
    calculateTotalPrice();
  }

  void addMeal(String mealName, int quantity) {
    if (selectedMeals.length >= 10) {
      print('Cannot add more than 10 meals.');
      return;
    }
    var meal = menu.searchMenuItems(mealName).first;
    if (selectedMeals.containsKey(meal)) {
      selectedMeals[meal] = selectedMeals[meal]! + quantity;
    } else {
      selectedMeals[meal] = quantity;
    }

    calculateTotalPrice();
  }

  void removeMeal(String mealName) {
    var meal = selectedMeals.keys.firstWhere(
            (item) => item.name.toLowerCase() == mealName.toLowerCase());
    selectedMeals.remove(meal);
    calculateTotalPrice();
  }

  void calculateTotalPrice() {

    totalPrice = selectedMeals.entries.fold(0, (sum, entry) =>
    sum + entry.key.price * entry.value);
  }

  @override
  String toString() {
    var dateFormat = DateFormat('dd.MM.yyyy');
    var formattedDate = dateFormat.format(date);
    var reservationDetails = 'Reservation for $customerName on $formattedDate at $time for $numberOfGuests guests.\nSelected Meals:\n';
    for (var entry in selectedMeals.entries) {
      reservationDetails += '- ${entry.key.name} (Quantity: ${entry.value}): \$${entry.key.price}\n';
    }
    reservationDetails += 'Total Price: \$${totalPrice.toStringAsFixed(2)}';
    return reservationDetails;
  }
}
