import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/RouteScannerController/customer_edit_controller.dart';
import 'package:ocean_sys/controller/RouteScannerController/customer_info_controller.dart';
import 'package:ocean_sys/controller/location_sync_controller.dart';
import 'package:ocean_sys/gen/assets.gen.dart';
import 'package:ocean_sys/route_manager/names.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );

  CustomerEditController customerEditController = Get.put(
    CustomerEditController(),
  );

  LocationSyncController controller_loc = Get.find<LocationSyncController>();

  @override
  Widget build(BuildContext context) {
    final int index = Get.arguments ?? 0;
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
                var result = await customerEditController.taskComplete(
                  customerInfoController.custmerinfolist[index].customerCode
                      .toString(),
                );
              },
              child: Icon(Icons.check),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                var result = controller_loc.changeLoction(
                  customerInfoController.custmerinfolist[index].customerCode
                      .toString(),
                );
              },
              child: Icon(Icons.location_on_sharp),
            ),
          ],
        ),
      ),
      body: Padding(
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
                  SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نام مشتری : ${customerInfoController.custmerinfolist[index].customerBoard} ',
                        style: MyTextStyle.textBlack16,
                      ),
                      SizedBox(height: 4),
                      Text(
                        ' نام مالک : ${customerInfoController.custmerinfolist[index].customerName}',
                        style: MyTextStyle.textSmall12,
                      ),
                      Text(
                        'وضعیت  : ${customerInfoController.custmerinfolist[index].status}',
                        style: MyTextStyle.textSmall12,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'شماره همراه : ${customerInfoController.custmerinfolist[index].mobile}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    'شماره همراه : ${customerInfoController.custmerinfolist[index].phone}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    ' محدوده  : ${customerInfoController.custmerinfolist[index].area}',
                    style: MyTextStyle.textSmall12,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'آدرس  : ${customerInfoController.custmerinfolist[index].address}',
                style: MyTextStyle.textSmall12,
                maxLines: 2,
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' کد ملی : ${customerInfoController.custmerinfolist[index].nationalCode}',
                    style: MyTextStyle.textSmall12,
                  ),
                  Text(
                    ' کد پستی : ${customerInfoController.custmerinfolist[index].postalCode}',
                    style: MyTextStyle.textSmall12,
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
              Divider(thickness: 1, color: Colors.black),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,
                      onPressed: () {
                        sendDisActive(index);
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
                        Get.toNamed(
                          NamedRoute.customerPageIdit,
                          arguments: index,
                        );
                      },
                      child: Text(
                        "اصلاح اطلاعات",
                        style: MyTextStyle.bottomstyle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,
                      onPressed: () {
                        crmDialogDescription(index);
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
                        detectProductCategoryIntent(index);
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
      ),
    );
  }

  // غیر فعال سازی مشتری
  void sendDisActive(index) {
    String? selectedReason;
    List<String> reasons = [
      'عدم همکاری مشتری',
      'تغییر مالکیت',
      'تغییر آدرس',
      'سایر',
      'مشتری فعال',
    ];
    Get.defaultDialog(
      title: "دلیل غیر فعال سازی",
      titleStyle: MyTextStyle.textBlack16,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedReason,
            hint: Text("یک دلیل را انتخاب کنید", style: MyTextStyle.textBlak12),
            items: reasons.map((reason) {
              return DropdownMenuItem(
                value: reason,
                child: Text(reason, style: TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (value) {
              selectedReason = value;
              customerEditController.selectedDisActive.value = value ?? '';
            },
          ),
          SizedBox(height: 10),
          TextField(
            controller: customerEditController.disActiveDescription,
            decoration: InputDecoration(
              labelText: "توضیحات بیشتر",
              labelStyle: MyTextStyle.textBlak12,
              border: OutlineInputBorder(),
              focusColor: SolidColors.listCustomerColor,
            ),
            style: MyTextStyle.textBlak12,
            maxLines: 4,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (customerEditController.selectedDisActive.value.isEmpty) {
            Get.snackbar("لطفا یک دلیل انتخاب کنید", "خطا");
            return;
          }
          await customerEditController.sendDisActiveDescription(
            customerInfoController.custmerinfolist[index].customerCode,
          );
        },
        style: MyDecorations.mainButtom,
        child: Text("تایید", style: MyTextStyle.bottomstyle),
      ),
    );
  }

  // غیر فعال سازی مشتری
  void detectProductCategoryIntent(index) {
    customerEditController.selectedProducts.clear();
    List<String> products = [
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
    Get.defaultDialog(
      title: "خرید مشتری",
      titleStyle: MyTextStyle.textBlack16,
      content: SizedBox(
        width: Get.width * 0.8,
        height: Get.height * 0.4,
        child: Column(
          children: [
            Text(
              'محصولاتی که مشتری میخرد را انتخاب کنید',
              style: MyTextStyle.textBlak12,
            ),
            SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                customerEditController.selectedProducts.length;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isSelected = customerEditController.selectedProducts
                        .contains(product);
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          customerEditController.selectedProducts.remove(
                            product,
                          );
                        } else {
                          customerEditController.selectedProducts.add(product);
                        }
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
              }),
            ),
          ],
        ),
      ),
      confirm: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              Get.back();
              if (customerEditController.selectedProducts.isNotEmpty) {
                await customerEditController.sendProductCategoryCustomer(
                  customerInfoController.custmerinfolist[index].customerCode,
                );
              } else {
                Get.snackbar(
                  "هیچ محصولی انتخاب نشده",
                  "لطفا حداقل یک محصول انتخاب کنید",
                );
              }
            },
            style: MyDecorations.mainButtom,
            child: Text("ارسال اطلاعات", style: MyTextStyle.bottomstyle),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  void crmDialogDescription(index) {
    Get.defaultDialog(
      title: "توضیحات مشتری",
      titleStyle: MyTextStyle.textBlack16,
      content: SizedBox(
        height: Get.height * 0.35,
        width: Get.width * 0.6,
        child: Column(
          children: [
            TextField(
              controller: customerEditController.crmCustomerDescription,
              maxLines: 6,
              style: MyTextStyle.textBlak12,
              decoration: InputDecoration(
                labelText: "توضیحات",
                labelStyle: MyTextStyle.textBlak12,
                border: OutlineInputBorder(),
                focusColor: SolidColors.listCustomerColor,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(
                          "آیا به مشتری  سر زده میشود ",
                          style: MyTextStyle.checkboxFont,
                          maxLines: 2,
                        ),
                        value: customerEditController.isCustomerVisit.value,
                        onChanged: (val) =>
                            customerEditController.isCustomerVisit.value =
                                val ?? false,
                      ),
                      CheckboxListTile(
                        title: Text(
                          "آیا صاحب مغازه در مغازه هست؟",
                          style: MyTextStyle.checkboxFont,
                          maxLines: 2,
                        ),
                        value: customerEditController.isOwnerInShop.value,
                        onChanged: (val) =>
                            customerEditController.isOwnerInShop.value =
                                val ?? false,
                      ),
                      CheckboxListTile(
                        title: Text(
                          "آیا مشتری همکاری میکند ؟",
                          style: MyTextStyle.checkboxFont,
                          maxLines: 2,
                        ),
                        value: customerEditController.isCooperation.value,
                        onChanged: (val) =>
                            customerEditController.isCooperation.value =
                                val ?? false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();

          await customerEditController.sendCRMCustomerDescription(
            customerInfoController.custmerinfolist[index].customerCode,
          );
        },
        style: MyDecorations.mainButtom,
        child: Text("ذخیره", style: MyTextStyle.bottomstyle),
      ),
    );
  }
}
