import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_state.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page_idit.dart';

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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: MyDecorations.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'شماره همراه',
                        customer.mobile ?? '',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.phone_android_outlined,
                        'شماره ثابت',
                        customer.phone ?? '',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.badge_outlined,
                        'کد ملی',
                        customer.nationalCode ?? '',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.local_post_office_outlined,
                        'کد پستی',
                        customer.postalCode ?? '',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.pin_drop_outlined,
                        'محدوده',
                        customer.area ?? '',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.location_city_outlined,
                        'آدرس',
                        customer.address ?? '',
                        isMultiLine: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildActionButton(
                      icon: Icons.toggle_off_outlined,
                      label: 'غیر فعال / فعال',
                      color: SolidColors.secondaryColor,
                      onTap: () {
                        if (widget.index != null) {
                          sendDisActive(context, widget.index!);
                        }
                      },
                    ),
                    _buildActionButton(
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
                    _buildActionButton(
                      icon: Icons.report_outlined,
                      label: 'شکایت مشتری',
                      color: Colors.orange,
                      onTap: () {
                        if (widget.index != null) {
                          crmDialogDescription(context, widget.index!);
                        }
                      },
                    ),
                    _buildActionButton(
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

  Widget _buildInfoRow(
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'dona',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
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
                        final customerInfoBloc = context
                            .read<CustomerInfoBloc>();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                          context
                              .read<CustomerEditBloc>()
                              .state
                              .selectedProducts,
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
