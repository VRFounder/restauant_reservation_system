import 'table.dart';
import 'reservation.dart';

class Restaurant {
  String name;
  String address;
  List<Table> tables;
  List<Table> reservedTables;

  Restaurant(this.name, this.address, this.tables) : reservedTables = [];

  List<Table> getAvailableTables(int numberOfGuests, DateTime date, String time) {
    return tables.where((table) =>
    table.seats >= numberOfGuests && table.isAvailable(date)).toList();
  }

  bool reserveTable(int tableId, Reservation reservation) {
    var table = tables.firstWhere((t) => t.id == tableId);
    if (table.isAvailable(reservation.date)) {
      table.reservations.add(reservation);
      reservation.table = table; // Linking the reserved table with the reservation
      return true;
    }
    return false;
  }

}