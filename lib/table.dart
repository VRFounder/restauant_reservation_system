import 'reservation.dart';

class Table {
  int id;
  int seats;
  List<Reservation> reservations;

  Table({required this.id, required this.seats}): reservations = [];

  bool isAvailable(DateTime date) {
    for (var reservation in reservations) {
      if (reservation.date.year == date.year &&
          reservation.date.month == date.month &&
          reservation.date.day == date.day) {
        return false; // Table is not available if already reserved for this date
      }
    }
    return true; // Table is available if no reservation is found for this date
  }

  void addReservation(Reservation reservation) {
    reservations.add(reservation);
  }
}