import '../enum/seat_enum.dart';

class SeatModel {
  int row;
  int column;
  SeatEnum status;

  SeatModel({required this.row, required this.column, required this.status});
}
