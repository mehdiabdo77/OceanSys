import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});

  final CustomerInfoModel customer;

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: MyDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildInfoItem(
                Icons.phone_outlined,
                'شماره همراه',
                customer.mobile ?? '',
                onTap: customer.mobile != null && customer.mobile!.isNotEmpty
                    ? () => makePhoneCall(customer.mobile!)
                    : null,
              ),
              buildInfoItem(
                Icons.phone_android_outlined,
                'شماره ثابت',
                customer.phone ?? '',
                onTap: customer.phone != null && customer.phone!.isNotEmpty
                    ? () => makePhoneCall(customer.phone!)
                    : null,
              ),
              buildInfoItem(
                Icons.badge_outlined,
                'کد ملی',
                customer.nationalCode ?? '',
              ),
              buildInfoItem(
                Icons.local_post_office_outlined,
                'کد پستی',
                customer.postalCode ?? '',
              ),
              buildInfoItem(
                Icons.pin_drop_outlined,
                'محدوده',
                customer.area ?? '',
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildInfoItem(
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

Widget buildInfoItem(
  IconData icon,
  String label,
  String value, {
  bool isMultiLine = false,
  VoidCallback? onTap,
}) {
  final Widget child = Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: isMultiLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: SolidColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: SolidColors.primaryColor, size: 18),
        ),
        const SizedBox(width: 10),
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
    ),
  );

  if (onTap != null) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }

  return child;
}
