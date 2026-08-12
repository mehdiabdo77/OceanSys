import 'package:flutter/material.dart';

class DialogPersianCalendar extends StatefulWidget {
  final DateTime? initialDate;

  const DialogPersianCalendar({super.key, this.initialDate});

  @override
  State<DialogPersianCalendar> createState() => _DialogPersianCalendarState();
}

class _DialogPersianCalendarState extends State<DialogPersianCalendar> {
  late int _selectedJalaliYear;
  late int _selectedJalaliMonth;
  late int _selectedJalaliDay;
  late DateTime _selectedGregorianDate;

  @override
  void initState() {
    super.initState();
    DateTime initialDateTime = widget.initialDate ?? DateTime.now();
    var jalaliDate = _toJalali(initialDateTime);
    _selectedJalaliYear = jalaliDate[0];
    _selectedJalaliMonth = jalaliDate[1];
    _selectedJalaliDay = jalaliDate[2];
    _selectedGregorianDate = initialDateTime;
  }

  List<int> _toJalali(DateTime dt) {
    int gy = dt.year;
    int gm = dt.month;
    int gd = dt.day;

    final List<int> gDaysInMonth = [
      31,
      28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    int jy = (gy <= 1600) ? 0 : 979;
    gy -= (gy <= 1600) ? 621 : 1600;
    int gy2 = (gm > 2) ? (gy + 1) : gy;
    int days =
        (365 * gy) +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) -
        80 +
        gd;
    for (int i = 0; i < gm - 1; ++i) {
      days += gDaysInMonth[i];
    }
    jy += 33 * (days ~/ 12053);
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    jy += (days - 1) ~/ 365;
    if (days > 365) days = (days - 1) % 365;
    int jm = (days < 186) ? 1 + (days ~/ 31) : 7 + ((days - 186) ~/ 30);
    int jd = 1 + ((days < 186) ? (days % 31) : ((days - 186) % 30));
    return [jy, jm, jd];
  }

  DateTime _toGregorian(int jy, int jm, int jd) {
    int gy = (jy <= 979) ? 621 : 1600;
    jy -= (jy <= 979) ? 0 : 979;
    int days =
        (365 * jy) +
        ((jy ~/ 33) * 8) +
        (((jy % 33) + 3) ~/ 4) +
        78 +
        jd +
        ((jm < 7) ? (jm - 1) * 31 : ((jm - 7) * 30) + 186);
    int gy2 = (400 * (days ~/ 146097)).toInt();
    days %= 146097;
    if (days > 36524) {
      gy2 += (100 * (--days ~/ 36524)).toInt();
      days %= 36524;
      if (days >= 365) days++;
    }
    gy2 += (4 * (days ~/ 1461)).toInt();
    days %= 1461;
    gy2 += ((days - 1) ~/ 365).toInt();
    if (days > 365) days = (days - 1) % 365;
    int gd = days + 1;
    List<int> sal_a = [
      0,
      31,
      ((gy2 % 4 == 0 && gy2 % 100 != 0) || (gy2 % 400 == 0)) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    int gm;
    for (gm = 0; gm < 13; gm++) {
      int v = sal_a[gm];
      if (gd <= v) break;
      gd -= v;
    }
    return DateTime(gy + gy2, gm, gd);
  }

  final List<String> _monthNames = [
    '',
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  int _getDaysInMonth(int jy, int jm) {
    if (jm <= 6) return 31;
    if (jm <= 11) return 30;
    bool leap = (((jy - 474) % 2828) + 474) * 682 % 2816 < 682;
    return leap ? 30 : 29;
  }

  int _getFirstWeekdayOfMonth(int jy, int jm) {
    DateTime firstDayGregorian = _toGregorian(jy, jm, 1);
    int gWeekday = firstDayGregorian.weekday;
    if (gWeekday == 6) return 0;
    if (gWeekday == 7) return 1;
    return gWeekday + 1;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _getDaysInMonth(
      _selectedJalaliYear,
      _selectedJalaliMonth,
    );
    int firstWeekday = _getFirstWeekdayOfMonth(
      _selectedJalaliYear,
      _selectedJalaliMonth,
    );

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                if (_selectedJalaliMonth < 12) {
                  _selectedJalaliMonth++;
                } else {
                  _selectedJalaliMonth = 1;
                  _selectedJalaliYear++;
                }
                if (_selectedJalaliDay >
                    _getDaysInMonth(
                      _selectedJalaliYear,
                      _selectedJalaliMonth,
                    )) {
                  _selectedJalaliDay = _getDaysInMonth(
                    _selectedJalaliYear,
                    _selectedJalaliMonth,
                  );
                }

                // بروزرسانی تاریخ میلادی متناسب با تاریخ شمسی جدید
                _selectedGregorianDate = _toGregorian(
                  _selectedJalaliYear,
                  _selectedJalaliMonth,
                  _selectedJalaliDay,
                );
              });
            },
          ),
          Text(
            '${_monthNames[_selectedJalaliMonth]} $_selectedJalaliYear',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                if (_selectedJalaliMonth > 1) {
                  _selectedJalaliMonth--;
                } else {
                  _selectedJalaliMonth = 12;
                  _selectedJalaliYear--;
                }
                if (_selectedJalaliDay >
                    _getDaysInMonth(
                      _selectedJalaliYear,
                      _selectedJalaliMonth,
                    )) {
                  _selectedJalaliDay = _getDaysInMonth(
                    _selectedJalaliYear,
                    _selectedJalaliMonth,
                  );
                }

                // بروزرسانی تاریخ میلادی متناسب با تاریخ شمسی جدید
                _selectedGregorianDate = _toGregorian(
                  _selectedJalaliYear,
                  _selectedJalaliMonth,
                  _selectedJalaliDay,
                );
              });
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('ش', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('ی', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('د', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('س', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('چ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('پ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('ج', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday) {
                  return const SizedBox.shrink();
                }
                int day = index - firstWeekday + 1;
                bool isSelected = day == _selectedJalaliDay;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedJalaliDay = day;
                      // بروزرسانی تاریخ میلادی متناسب با روز شمسی انتخاب شده
                      _selectedGregorianDate = _toGregorian(
                        _selectedJalaliYear,
                        _selectedJalaliMonth,
                        _selectedJalaliDay,
                      );
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: () {
            String formattedMonth = _selectedGregorianDate.month
                .toString()
                .padLeft(2, '0');
            String formattedDay = _selectedGregorianDate.day.toString().padLeft(
              2,
              '0',
            );
            String gregorianStr =
                '${_selectedGregorianDate.year}-$formattedMonth-$formattedDay';

            String jMonth = _selectedJalaliMonth.toString().padLeft(2, '0');
            String jDay = _selectedJalaliDay.toString().padLeft(2, '0');
            String jalaliStr = '$_selectedJalaliYear/$jMonth/$jDay';

            Navigator.of(
              context,
            ).pop({'jalali': jalaliStr, 'gregorian': gregorianStr});
          },
          child: const Text('انتخاب'),
        ),
      ],
    );
  }
}
