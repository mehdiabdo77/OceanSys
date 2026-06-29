import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page_idit.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/action_button.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/app_bar.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/crm_dialog_description.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/customer_info.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/detect_product_category_intent.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/send_disactive.dart';

class CustomerPage extends StatefulWidget {
  final int? index;

  const CustomerPage({super.key, this.index});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: customAppBar(context, widget.index),
      body: BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
        builder: (context, state) {
          if (state is! CustomerInfoLoaded ||
              widget.index == null ||
              widget.index! >= state.customers.length) {
            return const Center(
              child: CircularProgressIndicator(color: SolidColors.primaryColor),
            );
          }

          final customer = state.customers[widget.index!];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: MyDecorations.cardDecoration,
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: SolidColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront,
                          color: SolidColors.primaryColor,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        customer.customerBoard ?? '',
                        style: MyTextStyle.textBlack16,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.customerName ?? '',
                        style: MyTextStyle.textSmall12,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomerInfo(customer: customer),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildActionButton(
                      icon: Icons.toggle_off_outlined,
                      label: 'غیر فعال / فعال',
                      color: SolidColors.secondaryColor,
                      onTap: () {
                        if (widget.index != null) {
                          sendDisActive(context, widget.index!);
                        }
                      },
                    ),
                    buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'اصلاح اطلاعات',
                      color: SolidColors.primaryColor,
                      onTap: () async {
                        if (widget.index != null) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerPageIdit(index: widget.index!),
                            ),
                          );
                          if (context.mounted) {
                            context.read<CustomerInfoBloc>().add(
                              CustomerInfoFetchData(),
                            );
                          }
                        }
                      },
                    ),
                    buildActionButton(
                      icon: Icons.report_outlined,
                      label: 'شکایت مشتری',
                      color: Colors.orange,
                      onTap: () {
                        if (widget.index != null) {
                          crmDialogDescription(context, widget.index!);
                        }
                      },
                    ),
                    buildActionButton(
                      icon: Icons.shopping_cart_outlined,
                      label: 'ماهیت خرید',
                      color: SolidColors.accentColor,
                      onTap: () {
                        if (widget.index != null) {
                          detectProductCategoryIntent(context, widget.index!);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
