import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tmdb/enum/seat_enum.dart';
import 'package:tmdb/model/seat_model.dart';

class TicketsProvider extends ChangeNotifier {
  List<DateTime> days = [];

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  int _selectedScreen = 0;
  int get selectedScreen => _selectedScreen;
  set selectedScreen(int screen) {
    _selectedScreen = screen;
    notifyListeners();
  }

  List<List<SeatModel>> seatsMap = [];

  List<SeatModel> selectedSeats = [];
  int totalAmount = 0;

  Future<void> getNextSevenDays() async {
    try {
      for (int i = 1; i <= 7; i++) {
        days.add((DateTime.now().add(Duration(days: i))));
      }
      selectedDate = days[0];
      createSeatsMap();
    } catch (error) {
      log("Error[getNextSevenDays][tickets_provider]: $error");
    }
  }

  void bookUnBookSeat(SeatModel seat) {
    if (seat.status == SeatEnum.regular || seat.status == SeatEnum.vip) {
      seat.status = SeatEnum.selected;
      selectedSeats.add(seat);
      totalAmount += seat.row < 9 ? 50 : 100;
      notifyListeners();
    } else if (seat.status == SeatEnum.selected) {
      seat.status = seat.row < 9 ? SeatEnum.regular : SeatEnum.vip;
      selectedSeats.remove(seat);
      totalAmount -= seat.row < 9 ? 50 : 100;
      notifyListeners();
    }
  }

  void resetSeats() {
    for (var seat in selectedSeats) {
      seat.status = seat.row < 9 ? SeatEnum.regular : SeatEnum.vip;
    }
    selectedSeats.clear();
    totalAmount = 0;
  }

  void createSeatsMap() {
    try {
      for (int row = 0; row < 10; row++) {
        List<SeatModel> seatsRow = [];
        for (int column = 0; column < 24; column++) {
          seatsRow.add(SeatModel(
            row: row,
            column: column,
            status: getSeatStatus(row, column),
          ));
        }
        seatsMap.add(seatsRow);
      }
    } catch (error) {
      log("Error[createSeatsMap][tickets_provider]: $error");
    }
  }

  SeatEnum getSeatStatus(int row, int column) {
    if (row == 9) {
      return SeatEnum.vip;
    } else if (row == 0) {
      if ((column >= 0 && column <= 2) || (column >= 21 && column <= 23)) {
        return SeatEnum.empty;
      }
    } else if (column == 0 || column == 23) {
      if (row > 0 && row <= 3) {
        return SeatEnum.empty;
      }
    }
    return SeatEnum.regular;
  }
}
