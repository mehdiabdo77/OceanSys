import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';

void sendDisActive(BuildContext context, int index) {
  String? selectedReason;
  const List<String> reasons = [
    'عدم همکاری مشتری',
    'تغییر مالکیت',
    'تغییر آدرس',
    'سایر',
    'مشتری فعال',
  ];
  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (statefulContext, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("دلیل غیر فعال سازی", style: MyTextStyle.textBlack16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    value: selectedReason,
                    hint: Text(
                      "یک دلیل را انتخاب کنید",
                      style: MyTextStyle.textBlak12,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: reasons.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedReason = value;
                        if (value != null) {
                          context.read<CustomerEditBloc>().add(
                            SelectDisActive(value),
                          );
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: context
                      .read<CustomerEditBloc>()
                      .disActiveDescription,
                  decoration: MyDecorations.inputDecoration.copyWith(
                    labelText: "توضیحات بیشتر",
                  ),
                  style: MyTextStyle.textBlak12,
                  maxLines: 4,
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.all(16),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (context
                        .read<CustomerEditBloc>()
                        .state
                        .selectedDisActive
                        .isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("لطفا یک دلیل را انتخاب کنید"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    if (context.mounted) {
                      Navigator.of(dialogContext).pop();
                      final customerInfoBloc = context.read<CustomerInfoBloc>();
                      if (customerInfoBloc.state is CustomerInfoLoaded) {
                        final customer =
                            (customerInfoBloc.state as CustomerInfoLoaded)
                                .customers[index];
                        context.read<CustomerEditBloc>().add(
                          SendDisActiveDescription(
                            customer.customerCode,
                            context
                                .read<CustomerEditBloc>()
                                .state
                                .selectedDisActive,
                            context
                                .read<CustomerEditBloc>()
                                .disActiveDescription
                                .text,
                          ),
                        );
                        if (context.mounted) {
                          context.read<CustomerInfoBloc>().add(
                            CustomerInfoFetchData(),
                          );
                        }
                      }
                    }
                  },
                  style: MyDecorations.mainButtom,
                  child: Text("تایید", style: MyTextStyle.bottomstyle),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
