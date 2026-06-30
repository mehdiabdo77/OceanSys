import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';

class CustomerPageIdit extends StatefulWidget {
  final int? index;

  const CustomerPageIdit({super.key, this.index});

  @override
  State<CustomerPageIdit> createState() => _CustomerPageIditState();
}

class _CustomerPageIditState extends State<CustomerPageIdit> {
  final _formKey = GlobalKey<FormState>();

  final RegExp _mobileReg = RegExp(r'^09\d{9}$');
  final RegExp _phoneReg = RegExp(r'^(021|026)\d{8}$');
  final RegExp _tenDigits = RegExp(r'^\d{10}$');

  String? _validator(RegExp pattern, String label, String? v) {
    if (v == null || v.isEmpty) return null;
    if (!pattern.hasMatch(v)) {
      return "$label فرمت صحیح ندارد";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text("ویرایش اطلاعات مشتری", style: MyTextStyle.textBlack16),
        backgroundColor: SolidColors.appBorColor,
        elevation: 0,
        centerTitle: true,
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
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: MyDecorations.cardDecoration,
                      child: Column(
                        children: [
                          _buildTextField(
                            "کد ملی",
                            context.read<CustomerEditBloc>().nationalCode,
                            customer.nationalCode,
                            validator: (v) =>
                                _validator(_tenDigits, "کد ملی", v),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            icon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "کد نقش",
                            context.read<CustomerEditBloc>().roleCode,
                            '',
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(13),
                            ],
                            icon: Icons.pin_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "کد پستی",
                            context.read<CustomerEditBloc>().postalCode,
                            customer.postalCode,
                            validator: (v) =>
                                _validator(_tenDigits, "کد پستی", v),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            icon: Icons.local_post_office_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "نام مالک",
                            context.read<CustomerEditBloc>().customername,
                            customer.customerName,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "نام تابلو مغازه",
                            context.read<CustomerEditBloc>().customerboard,
                            customer.customerBoard,
                            icon: Icons.storefront_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "آدرس مغازه",
                            context.read<CustomerEditBloc>().address,
                            customer.address,
                            icon: Icons.location_city_outlined,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: MyDecorations.cardDecoration,
                      child: Column(
                        children: [
                          _buildTextField(
                            "شماره همراه",
                            context.read<CustomerEditBloc>().mobileNumber,
                            customer.mobile,
                            validator: (v) =>
                                _validator(_mobileReg, "شماره همراه", v),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            icon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "شماره همراه 2",
                            context.read<CustomerEditBloc>().mobileNumber2,
                            '',
                            validator: (v) =>
                                _validator(_mobileReg, "شماره همراه", v),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            icon: Icons.phone_android_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "شماره ثابت",
                            context.read<CustomerEditBloc>().phoneNumber,
                            customer.phone,
                            validator: (v) =>
                                _validator(_phoneReg, "شماره ثابت", v),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            icon: Icons.phone_in_talk_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "متراژ مغازه (متر)",
                            context.read<CustomerEditBloc>().storeArea,
                            '',
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            icon: Icons.square_foot_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<CustomerEditBloc>().add(
                            SendEditCustomer(
                              customerCode: customer.customerCode,
                              nationalCode: context
                                  .read<CustomerEditBloc>()
                                  .nationalCode
                                  .text,
                              roleCode: int.tryParse(
                                context.read<CustomerEditBloc>().roleCode.text,
                              ),
                              postalCode: context
                                  .read<CustomerEditBloc>()
                                  .postalCode
                                  .text,
                              customerBoard: context
                                  .read<CustomerEditBloc>()
                                  .customerboard
                                  .text,
                              customerName: context
                                  .read<CustomerEditBloc>()
                                  .customername
                                  .text,
                              address: context
                                  .read<CustomerEditBloc>()
                                  .address
                                  .text,
                              mobileNumber: context
                                  .read<CustomerEditBloc>()
                                  .mobileNumber
                                  .text,
                              mobileNumber2: context
                                  .read<CustomerEditBloc>()
                                  .mobileNumber2
                                  .text,
                              phoneNumber: context
                                  .read<CustomerEditBloc>()
                                  .phoneNumber
                                  .text,
                              storeArea:
                                  int.tryParse(
                                    context
                                        .read<CustomerEditBloc>()
                                        .storeArea
                                        .text,
                                  ) ??
                                  0,
                            ),
                          );
                          if (context.mounted) {
                            context.read<CustomerInfoBloc>().add(
                              CustomerInfoFetchData(),
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: MyDecorations.mainButtom.copyWith(
                        minimumSize: WidgetStatePropertyAll(Size(70, 35)),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      child: Text(
                        "ذخیره تغییرات",
                        style: MyTextStyle.bottomstyle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller,
    String? initialValue, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatter,
    int maxLines = 1,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (initialValue != null && initialValue.isNotEmpty) ...[
          Row(
            children: [
              Text("$labelText فعلی:", style: MyTextStyle.caption),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  initialValue,
                  style: MyTextStyle.textSmall12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatter,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines,
          style: MyTextStyle.textBlak12,
          decoration: MyDecorations.inputDecoration.copyWith(
            labelText: labelText,
            prefixIcon: Icon(icon, color: SolidColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
