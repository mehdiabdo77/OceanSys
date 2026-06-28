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

void detectProductCategoryIntent(BuildContext context, int index) {
  const List<String> products = [
    'انرژی زا',
    'کلاسنو',
    'دوغزال',
    'نوشیدنی',
    'چای فله',
    'تن ماهی',
    'برنج ایرانی',
    'برنج هندی',
    'سویا',
    'چای ایرانی',
    'قند',
    'روغن',
  ];
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("خرید مشتری", style: MyTextStyle.textBlack16),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'محصولاتی که مشتری میخرد را انتخاب کنید',
                style: MyTextStyle.textBlak12,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              BlocBuilder<CustomerEditBloc, CustomerEditState>(
                builder: (context, state) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isSelected = state.selectedProducts.contains(
                        product,
                      );
                      return GestureDetector(
                        onTap: () {
                          context.read<CustomerEditBloc>().add(
                            ToggleProduct(product),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? SolidColors.accentColor
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              product,
                              style: TextStyle(
                                fontFamily: 'dona',
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
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
                if (context
                    .read<CustomerEditBloc>()
                    .state
                    .selectedProducts
                    .isNotEmpty) {
                  final customerInfoBloc = context.read<CustomerInfoBloc>();
                  if (customerInfoBloc.state is CustomerInfoLoaded) {
                    final customer =
                        (customerInfoBloc.state as CustomerInfoLoaded)
                            .customers[index];
                    context.read<CustomerEditBloc>().add(
                      SendProductCategoryCustomer(
                        customer.customerCode,
                        context.read<CustomerEditBloc>().state.selectedProducts,
                      ),
                    );
                    if (context.mounted) {
                      context.read<CustomerInfoBloc>().add(
                        CustomerInfoFetchData(),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("لطفا حداقل یک محصول را انتخاب کنید"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
              style: MyDecorations.mainButtom,
              child: Text("ارسال اطلاعات", style: MyTextStyle.bottomstyle),
            ),
          ),
        ],
      );
    },
  );
}
