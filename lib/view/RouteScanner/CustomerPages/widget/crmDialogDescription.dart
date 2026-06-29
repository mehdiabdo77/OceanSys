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

void crmDialogDescription(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
