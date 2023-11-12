import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/providers/tickets_provider.dart';
import 'package:tmdb/view/widgets/app_button.dart';
import 'package:tmdb/view/widgets/seats_top_bar.dart';

import '../Utils/app_colors.dart';
import 'seat_mapping_screen.dart';

class GetTicketsScreen extends StatefulWidget {
  const GetTicketsScreen(
      {required this.movieName, required this.movieDate, super.key});

  final String movieName;
  final String movieDate;

  @override
  State<GetTicketsScreen> createState() => _GetTicketsScreenState();
}

class _GetTicketsScreenState extends State<GetTicketsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      Provider.of<TicketsProvider>(context, listen: false).getNextSevenDays();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SeatsTopBar(
                movieName: widget.movieName, movieDate: widget.movieDate),
            Expanded(
              child: Container(
                width: 1.sw,
                color: AppColors.backgroundColor,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Consumer<TicketsProvider>(
                      builder: (context, ticketsProvider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, bottom: 5.h),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ticketsProvider.days.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    ticketsProvider.selectedDate =
                                        ticketsProvider.days[index];
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    margin: EdgeInsets.only(
                                        left: 15.w,
                                        right: (index ==
                                                ticketsProvider.days.length - 1)
                                            ? 15
                                            : 0,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ticketsProvider.selectedDate ==
                                              ticketsProvider.days[index]
                                          ? AppColors.blueColor
                                          : AppColors.lightGreyColor,
                                      boxShadow: ticketsProvider.selectedDate ==
                                              ticketsProvider.days[index]
                                          ? [
                                              BoxShadow(
                                                color: AppColors.blueColor
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateFormat('d MMM').format(
                                            ticketsProvider.days[index]),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: ticketsProvider.selectedDate ==
                                                  ticketsProvider.days[index]
                                              ? AppColors.whiteColor
                                              : AppColors.darkBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            SizedBox(
                              height: 200.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    ticketsProvider.selectedScreen = index;
                                  },
                                  child: Container(
                                    width: 249.w,
                                    margin: EdgeInsets.only(
                                        left: 15.w,
                                        right: (index == 2) ? 15 : 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '1${index + 2}:30',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.darkBlue,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "   Cinetech + Hall ${index + 1}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 145.h,
                                          width: 1.sw,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: ticketsProvider
                                                          .selectedScreen ==
                                                      index
                                                  ? AppColors.blueColor
                                                  : AppColors.lightGreyColor,
                                              width: 1,
                                            ),
                                          ),
                                          child: Image.asset(
                                              "lib/assets/images/seats.png"),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'From ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.greyColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "${(index + 2) * 25}\$",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.darkBlue),
                                              ),
                                              TextSpan(
                                                text: ' or ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.greyColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${(index * 500) + 2500} bonus",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.darkBlue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    AppButton(
                      text: "Select Seats",
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SeatMappingScreen(
                              movieName: widget.movieName,
                              watchDate: Provider.of<TicketsProvider>(context,
                                      listen: false)
                                  .selectedDate
                                  .toString(),
                              otherData:
                                  "1${Provider.of<TicketsProvider>(context, listen: false).selectedScreen + 2}:30 Hall ${Provider.of<TicketsProvider>(context, listen: false).selectedScreen + 1}",
                            ),
                          ),
                        );
                      },
                      minimumSize:
                          MaterialStateProperty.all(Size(0.9.sw, 50.h)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
