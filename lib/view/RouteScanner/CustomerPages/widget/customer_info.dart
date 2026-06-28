import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});

  final CustomerInfoModel customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: MyDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow(
            Icons.phone_outlined,
            'شماره همراه',
            customer.mobile ?? '',
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.phone_android_outlined,
            'شماره ثابت',
            customer.phone ?? '',
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.badge_outlined,
            'کد ملی',
            customer.nationalCode ?? '',
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.local_post_office_outlined,
            'کد پستی',
            customer.postalCode ?? '',
          ),
          const SizedBox(height: 16),
          buildInfoRow(Icons.pin_drop_outlined, 'محدوده', customer.area ?? ''),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.location_city_outlined,
            'آدرس',
            customer.address ?? '',
            isMultiLine: true,
          ),
        ],
      ),
    );
  }
}

Widget buildInfoRow(
  IconData icon,
  String label,
  String value, {
  bool isMultiLine = false,
}) {
  return Row(
    crossAxisAlignment: isMultiLine
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: SolidColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: SolidColors.primaryColor, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: MyTextStyle.caption),
            const SizedBox(height: 2),
            Text(
              value,
              style: MyTextStyle.textBlak12,
              maxLines: isMultiLine ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}
