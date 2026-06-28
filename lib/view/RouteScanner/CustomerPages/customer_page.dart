import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page_idit.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/widget/action_button.dart';
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: SolidColors.appBorColor,
        actions: [
          IconButton(
            onPressed: () async {
              final customerInfoBloc = context.read<CustomerInfoBloc>();
              final customerEditBloc = context.read<CustomerEditBloc>();
              if (customerInfoBloc.state is CustomerInfoLoaded &&
                  widget.index != null &&
                  widget.index! <
                      (customerInfoBloc.state as CustomerInfoLoaded)
                          .customers
                          .length) {
                final customer = (customerInfoBloc.state as CustomerInfoLoaded)
                    .customers[widget.index!];
                customerEditBloc.add(
                  TaskComplete(customer.customerCode.toString()),
                );
                if (context.mounted) {
                  customerInfoBloc.add(CustomerInfoFetchData());
                }
              }
            },
            icon: const Icon(Icons.check_circle_outline, size: 28),
            color: SolidColors.accentColor,
          ),
          IconButton(
            onPressed: () {
              final customerInfoBloc = context.read<CustomerInfoBloc>();
              final locationSyncBloc = context.read<LocationSyncBloc>();
              if (customerInfoBloc.state is CustomerInfoLoaded &&
                  widget.index != null &&
                  widget.index! <
                      (customerInfoBloc.state as CustomerInfoLoaded)
                          .customers
                          .length) {
                final customer = (customerInfoBloc.state as CustomerInfoLoaded)
                    .customers[widget.index!];
                locationSyncBloc.add(
                  ChangeLocation(customer.customerCode.toString()),
                );
              }
            },
            icon: const Icon(Icons.location_on_outlined, size: 28),
            color: SolidColors.primaryColor,
          ),
          const SizedBox(width: 8),
        ],
      ),
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

  void crmDialogDescription(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("توضیحات مشتری", style: MyTextStyle.textBlack16),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: context
                      .read<CustomerEditBloc>()
                      .crmCustomerDescription,
                  maxLines: 5,
                  style: MyTextStyle.textBlak12,
                  decoration: MyDecorations.inputDecoration.copyWith(
                    labelText: "توضیحات",
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CustomerEditBloc, CustomerEditState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "آیا به مشتری سر زده میشود؟",
                            style: MyTextStyle.checkboxFont,
                          ),
                          value: state.isCustomerVisit,
                          activeColor: SolidColors.primaryColor,
                          onChanged: (val) => context
                              .read<CustomerEditBloc>()
                              .add(ToggleCustomerVisit(val ?? false)),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "آیا صاحب مغازه در مغازه هست؟",
                            style: MyTextStyle.checkboxFont,
                          ),
                          value: state.isOwnerInShop,
                          activeColor: SolidColors.primaryColor,
                          onChanged: (val) => context
                              .read<CustomerEditBloc>()
                              .add(ToggleOwnerInShop(val ?? false)),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "آیا مشتری همکاری میکند؟",
                            style: MyTextStyle.checkboxFont,
                          ),
                          value: state.isCooperation,
                          activeColor: SolidColors.primaryColor,
                          onChanged: (val) => context
                              .read<CustomerEditBloc>()
                              .add(ToggleCooperation(val ?? false)),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(16),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  final customerInfoBloc = context.read<CustomerInfoBloc>();
                  if (customerInfoBloc.state is CustomerInfoLoaded) {
                    final customer =
                        (customerInfoBloc.state as CustomerInfoLoaded)
                            .customers[index];
                    context.read<CustomerEditBloc>().add(
                      SendCRMCustomerDescription(
                        customer.customerCode,
                        context
                            .read<CustomerEditBloc>()
                            .crmCustomerDescription
                            .text,
                        context.read<CustomerEditBloc>().state.isCustomerVisit,
                        context.read<CustomerEditBloc>().state.isOwnerInShop,
                        context.read<CustomerEditBloc>().state.isCooperation,
                      ),
                    );
                    if (context.mounted) {
                      context.read<CustomerInfoBloc>().add(
                        CustomerInfoFetchData(),
                      );
                    }
                  }
                },
                style: MyDecorations.mainButtom,
                child: Text("ذخیره", style: MyTextStyle.bottomstyle),
              ),
            ),
          ],
        );
      },
    );
  }
}
