import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';

class CustomerPageIdit extends StatefulWidget {
  final int? index;

  const CustomerPageIdit({super.key, this.index});

  @override
  State<CustomerPageIdit> createState() => _CustomerPageIditState();
}

class _CustomerPageIditState extends State<CustomerPageIdit> {
  final _formKey = GlobalKey<FormState>();

  final RegExp _mobileReg = RegExp(r'^09\d{9}$'); // موبایل
  final RegExp _phoneReg = RegExp(r'^(021|026)\d{8}$'); // تلفن ثابت
  final RegExp _tenDigits = RegExp(r'^\d{10}$'); // عدد ها

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
        toolbarHeight: 45,
        title: Text("ویرایش اطلاعات مشتری", style: MyTextStyle.textBlack16),
        backgroundColor: SolidColors.appBorColor,
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    myTextField(
                      "کد ملی",
                      context.read<CustomerEditBloc>().nationalCode,
                      customer.nationalCode,
                      validator: (v) => _validator(_tenDigits, "کد ملی", v),
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "کد نقش",
                      context.read<CustomerEditBloc>().roleCode,
                      '',
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "کد پستی",
                      context.read<CustomerEditBloc>().postalCode,
                      customer.postalCode,
                      validator: (v) => _validator(_tenDigits, "کد پستی", v),
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "نام مالک",
                      context.read<CustomerEditBloc>().customername,
                      customer.customerName,
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "نام تابلو مغازه",
                      context.read<CustomerEditBloc>().customerboard,
                      customer.customerBoard,
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "آدرس مغازه",
                      context.read<CustomerEditBloc>().address,
                      customer.address,
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "شماره همراه",
                      context.read<CustomerEditBloc>().mobileNumber,
                      customer.mobile,
                      validator: (v) =>
                          _validator(_mobileReg, "شماره همراه", v),
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "شماره همراه 2",
                      context.read<CustomerEditBloc>().mobileNumber2,
                      '',
                      validator: (v) =>
                          _validator(_mobileReg, "شماره همراه", v),
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "شماره ثابت",
                      context.read<CustomerEditBloc>().phoneNumber,
                      customer.phone,
                      validator: (v) => _validator(_phoneReg, "شماره ثابت", v),
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    const SizedBox(height: 10),
                    myTextField(
                      "(متر بربع) متراژ مغازه",
                      context.read<CustomerEditBloc>().storeArea,
                      '',
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: MyDecorations.mainButtom,
                      child: Text(
                        "ذخیره تغییرات",
                        style: MyTextStyle.bottomstyle,
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

  Widget myTextField(
    String labelText,
    TextEditingController controller,
    String title, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$labelText:"),
            const SizedBox(width: 5),
            Text(title, style: MyTextStyle.textSmall12),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatter,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: MyTextStyle.textBlak12,
            border: const OutlineInputBorder(),
            focusColor: SolidColors.listCustomerColor,
          ),
          style: MyTextStyle.textBlak12,
          maxLines: 1,
        ),
      ],
    );
  }
}
