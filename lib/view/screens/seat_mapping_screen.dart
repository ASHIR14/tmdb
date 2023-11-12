import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/View/Utils/app_colors.dart';
import 'package:tmdb/enum/seat_enum.dart';
import 'package:tmdb/providers/tickets_provider.dart';
import 'package:tmdb/view/widgets/app_button.dart';
import 'package:tmdb/view/widgets/seats_top_bar.dart';

class SeatMappingScreen extends StatefulWidget {
  const SeatMappingScreen(
      {required this.movieName,
      required this.watchDate,
      required this.otherData,
      super.key});

  final String movieName;
  final String watchDate;
  final String otherData;

  @override
  State<SeatMappingScreen> createState() => _SeatMappingScreenState();
}

class _SeatMappingScreenState extends State<SeatMappingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<TicketsProvider>(context, listen: false).resetSeats();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<TicketsProvider>(
            builder: (context, ticketsProvider, child) => Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SeatsTopBar(
                  movieName: widget.movieName,
                  movieDate: widget.watchDate,
                  otherData: widget.otherData,
                ),
                Expanded(
                  child: Container(
                    color: AppColors.backgroundColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "lib/assets/images/screen.png",
                            width: 750,
                            fit: BoxFit.fitWidth,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 315,
                                margin:
                                    const EdgeInsets.only(bottom: 10, left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int i = 1; i <= 10; i++)
                                      Text(
                                        '$i',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: ticketsProvider.seatsMap
                                    .map(
                                      (row) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: row
                                            .map(
                                              (column) => Padding(
                                                padding: EdgeInsets.only(
                                                    right: (column.column ==
                                                                4 ||
                                                            column.column ==
                                                                18 ||
                                                            column.column == 23)
                                                        ? 25
                                                        : 5,
                                                    left: column.column == 0
                                                        ? 25
                                                        : 0,
                                                    bottom: 5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ticketsProvider
                                                        .bookUnBookSeat(column);
                                                  },
                                                  child:
                                                      column.status ==
                                                              SeatEnum.empty
                                                          ? const SizedBox(
                                                              height: 25,
                                                              width: 25,
                                                            )
                                                          : Image.asset(
                                                              column.status ==
                                                                      SeatEnum
                                                                          .regular
                                                                  ? 'lib/assets/images/seat_regular.png'
                                                                  : column.status ==
                                                                          SeatEnum
                                                                              .vip
                                                                      ? 'lib/assets/images/seat_vip.png'
                                                                      : column.status ==
                                                                              SeatEnum.unavailable
                                                                          ? 'lib/assets/images/seat_not_available.png'
                                                                          : 'lib/assets/images/seat_selected.png',
                                                              height: 25,
                                                              width: 25,
                                                            ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/seat_selected.png',
                                    height: 16,
                                    width: 17,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Selected",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/seat_not_available.png',
                                    height: 16,
                                    width: 17,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Not Available",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/seat_vip.png',
                                    height: 16,
                                    width: 17,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "VIP (150\$)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/seat_regular.png',
                                    height: 16,
                                    width: 17,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Regular (50\$)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        height: 50.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: ticketsProvider.selectedSeats.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10.w),
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.backgroundColor,
                            ),
                            margin: EdgeInsets.only(
                                left: index == 0 ? 15.w : 0,
                                right:
                                    ticketsProvider.selectedSeats.length - 1 ==
                                            index
                                        ? 15.w
                                        : 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${ticketsProvider.selectedSeats[index].column + 1} /',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${ticketsProvider.selectedSeats[index].row + 1} row",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    ticketsProvider.bookUnBookSeat(
                                        ticketsProvider.selectedSeats[index]);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            textWidget: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Total Price\n',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "\$ ${ticketsProvider.totalAmount}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            fixedSize:
                                MaterialStateProperty.all(Size(0.3.sw, 50.h)),
                            backgroundColor: AppColors.backgroundColor,
                            elevation: MaterialStateProperty.all(0),
                          ),
                          AppButton(
                            text: "Proceed to pay",
                            fixedSize:
                                MaterialStateProperty.all(Size(0.6.sw, 50.h)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
