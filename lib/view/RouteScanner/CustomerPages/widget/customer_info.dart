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
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                'اطلاعات تماس',
                style: TextStyle(
                  fontFamily: 'dona',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SolidColors.primaryColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.phone_iphone,
                    label: 'موبایل',
                    value: customer.mobile ?? '—',
                    onTap:
                        customer.mobile != null && customer.mobile!.isNotEmpty
                        ? () => makePhoneCall(customer.mobile!)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.phone,
                    label: 'ثابت',
                    value: customer.phone ?? '—',
                    onTap: customer.phone != null && customer.phone!.isNotEmpty
                        ? () => makePhoneCall(customer.phone!)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.badge,
                    label: 'کد ملی',
                    value: customer.nationalCode ?? '—',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.markunread_mailbox,
                    label: 'کد پستی',
                    value: customer.postalCode ?? '—',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.place,
              label: 'محدوده',
              value: customer.area ?? '—',
              isFullWidth: true,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.location_city,
              label: 'آدرس',
              value: customer.address ?? '—',
              isFullWidth: true,
              isAddress: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isFullWidth = false,
    bool isAddress = false,
  }) {
    final Widget child = Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isFullWidth ? 12 : 8,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: isAddress
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'dona',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'dona',
                      fontSize: isAddress ? 12 : 13,
                      fontWeight: isAddress ? FontWeight.w500 : FontWeight.bold,
                      color: Colors.grey[800],
                      height: isAddress ? 1.4 : 1.0,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: isAddress ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: SolidColors.primaryColor, size: 18),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      );
    }

    return child;
  }
}
