import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_state.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/gen/assets.gen.dart';
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
        toolbarHeight: 40,
        backgroundColor: SolidColors.appBorColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                final customerInfoBloc = context.read<CustomerInfoBloc>();
                final customerEditBloc = context.read<CustomerEditBloc>();
                if (customerInfoBloc.state is CustomerInfoLoaded &&
                    widget.index != null &&
                    widget.index! <
                        (customerInfoBloc.state as CustomerInfoLoaded)
                            .customers
                            .length) {
                  final customer =
                      (customerInfoBloc.state as CustomerInfoLoaded)
                          .customers[widget.index!];
                  customerEditBloc.add(
                    TaskComplete(customer.customerCode.toString()),
                  );
                }
              },
              child: const Icon(Icons.check),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                final customerInfoBloc = context.read<CustomerInfoBloc>();
                final locationSyncBloc = context.read<LocationSyncBloc>();
                if (customerInfoBloc.state is CustomerInfoLoaded &&
                    widget.index != null &&
                    widget.index! <
                        (customerInfoBloc.state as CustomerInfoLoaded)
                            .customers
                            .length) {
                  final customer =
                      (customerInfoBloc.state as CustomerInfoLoaded)
                          .customers[widget.index!];
                  locationSyncBloc.add(
                    ChangeLocation(customer.customerCode.toString()),
                  );
                }
              },
              child: const Icon(Icons.location_on_sharp),
            ),
          ],
        ),
      ),
      body: BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
        builder: (context, state) {
          if (state is! CustomerInfoLoaded ||
              widget.index == null ||
              widget.index! >= state.customers.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final customer = state.customers[widget.index!];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.store.path,
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نام مشتری : ${customer.customerBoard} ',
                            style: MyTextStyle.textBlack16,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ' نام مالک : ${customer.customerName}',
                            style: MyTextStyle.textSmall12,
                          ),
                          Text(
                            'وضعیت  : ${customer.status}',
                            style: MyTextStyle.textSmall12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'شماره همراه : ${customer.mobile}',
                        style: MyTextStyle.textSmall12,
                      ),
                      Text(
                        'شماره همراه : ${customer.phone}',
                        style: MyTextStyle.textSmall12,
                      ),
                      Text(
                        ' محدوده  : ${customer.area}',
                        style: MyTextStyle.textSmall12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'آدرس  : ${customer.address}',
                    style: MyTextStyle.textSmall12,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        ' کد ملی : ${customer.nationalCode}',
                        style: MyTextStyle.textSmall12,
                      ),
                      Text(
                        ' کد پستی : ${customer.postalCode}',
                        style: MyTextStyle.textSmall12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1, color: Colors.black),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: MyDecorations.mainButtom,
                          onPressed: () {
                            if (widget.index != null) {
                              sendDisActive(context, widget.index!);
                            }
                          },
                          child: Text(
                            "غیر فعال / فعال",
                            style: MyTextStyle.bottomstyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: MyDecorations.mainButtom,
                          onPressed: () {
                            if (widget.index != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerPageIdit(index: widget.index!),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "اصلاح اطلاعات",
                            style: MyTextStyle.bottomstyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: MyDecorations.mainButtom,
                          onPressed: () {
                            if (widget.index != null) {
                              crmDialogDescription(context, widget.index!);
                            }
                          },
                          child: Text(
                            "شکایت مشتری",
                            style: MyTextStyle.bottomstyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: MyDecorations.mainButtom,
                          onPressed: () {
                            if (widget.index != null) {
                              detectProductCategoryIntent(
                                context,
                                widget.index!,
                              );
                            }
                          },
                          child: Text(
                            "ماهیت خرید مشتری",
                            style: MyTextStyle.bottomstyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
              title: Text("دلیل غیر فعال سازی", style: MyTextStyle.textBlack16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedReason,
                    hint: Text(
                      "یک دلیل را انتخاب کنید",
                      style: MyTextStyle.textBlak12,
                    ),
                    items: reasons.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason,
                          style: const TextStyle(fontSize: 12),
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: context
                        .read<CustomerEditBloc>()
                        .disActiveDescription,
                    decoration: InputDecoration(
                      labelText: "توضیحات بیشتر",
                      labelStyle: MyTextStyle.textBlak12,
                      border: const OutlineInputBorder(),
                      focusColor: SolidColors.listCustomerColor,
                    ),
                    style: MyTextStyle.textBlak12,
                    maxLines: 4,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (context
                        .read<CustomerEditBloc>()
                        .state
                        .selectedDisActive
                        .isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("لطفا یک دلیل انتخاب کنید"),
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
                      }
                    }
                  },
                  style: MyDecorations.mainButtom,
                  child: Text("تایید", style: MyTextStyle.bottomstyle),
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
          title: Text("خرید مشتری", style: MyTextStyle.textBlack16),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Text(
                  'محصولاتی که مشتری میخرد را انتخاب کنید',
                  style: MyTextStyle.textBlak12,
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<CustomerEditBloc, CustomerEditState>(
                    builder: (context, state) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
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
                                    ? SolidColors.listCustomerColor
                                    : SolidColors.homepage,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: SolidColors.listCustomerColor,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  product,
                                  style: isSelected
                                      ? MyTextStyle.bottomstyle
                                      : MyTextStyle.textSmall12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                ElevatedButton(
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
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("لطفا حداقل یک محصول انتخاب کنید"),
                          ),
                        );
                      }
                    }
                  },
                  style: MyDecorations.mainButtom,
                  child: Text("ارسال اطلاعات", style: MyTextStyle.bottomstyle),
                ),
                const SizedBox(height: 15),
              ],
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
          title: Text("توضیحات مشتری", style: MyTextStyle.textBlack16),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                TextField(
                  controller: context
                      .read<CustomerEditBloc>()
                      .crmCustomerDescription,
                  maxLines: 6,
                  style: MyTextStyle.textBlak12,
                  decoration: InputDecoration(
                    labelText: "توضیحات",
                    labelStyle: MyTextStyle.textBlak12,
                    border: const OutlineInputBorder(),
                    focusColor: SolidColors.listCustomerColor,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder<CustomerEditBloc, CustomerEditState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(
                                "آیا به مشتری  سر زده میشود ",
                                style: MyTextStyle.checkboxFont,
                                maxLines: 2,
                              ),
                              value: state.isCustomerVisit,
                              onChanged: (val) => context
                                  .read<CustomerEditBloc>()
                                  .add(ToggleCustomerVisit(val ?? false)),
                            ),
                            CheckboxListTile(
                              title: Text(
                                "آیا صاحب مغازه در مغازه هست؟",
                                style: MyTextStyle.checkboxFont,
                                maxLines: 2,
                              ),
                              value: state.isOwnerInShop,
                              onChanged: (val) => context
                                  .read<CustomerEditBloc>()
                                  .add(ToggleOwnerInShop(val ?? false)),
                            ),
                            CheckboxListTile(
                              title: Text(
                                "آیا مشتری همکاری میکند ؟",
                                style: MyTextStyle.checkboxFont,
                                maxLines: 2,
                              ),
                              value: state.isCooperation,
                              onChanged: (val) => context
                                  .read<CustomerEditBloc>()
                                  .add(ToggleCooperation(val ?? false)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
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
                }
              },
              style: MyDecorations.mainButtom,
              child: Text("ذخیره", style: MyTextStyle.bottomstyle),
            ),
          ],
        );
      },
    );
  }
}
