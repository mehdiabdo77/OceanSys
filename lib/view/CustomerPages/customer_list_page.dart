import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/controller/customer_info_controller.dart';
import 'package:ocean_sys/controller/location_sync_controller.dart';
import 'package:ocean_sys/main.dart';

class CustomerListPage extends StatelessWidget {
  CustomerListPage({super.key});

  CustomerInfoController customerInfoController = Get.put(
    CustomerInfoController(),
  );

  LocationSyncController controllerLoc = Get.find<LocationSyncController>();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SolidColors.homepage,
      body: Obx(
        () => SizedBox(
          child: ListView.builder(
            itemCount: customerInfoController.custmerinfolist.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(NamedRoute.customerPage, arguments: index);
                  },
                  child: Container(
                    height: 80,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: SolidColors.listCustomerColor,
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.fromLTRB(
                        right: BorderSide(
                          style: BorderStyle.solid,
                          width: 5,
                          color:
                              customerInfoController
                                      .custmerinfolist[index]
                                      .visited ==
                                  1
                              ? SolidColors.pointVisitColor
                              : customerInfoController
                                        .custmerinfolist[index]
                                        .visited ==
                                    2
                              ? SolidColors.pointNoSendEndJab
                              : SolidColors.pointNoVisitColor,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87, // رنگ سایه
                          spreadRadius: 1, // پخش‌شدگی
                          blurRadius: 6, // محوی
                          offset: const Offset(2, 3), // جابجایی سایه (x,y)
                        ), // جابجایی سایه (x,y)
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customerInfoController
                                      .custmerinfolist[index]
                                      .customerBoard
                                      .toString(),
                                  style: textTheme.bodyLarge,
                                ),
                                Text(
                                  customerInfoController
                                      .custmerinfolist[index]
                                      .customerCode
                                      .toString(),
                                  style: textTheme.bodyLarge,
                                ),
                                Text(
                                  customerInfoController
                                      .custmerinfolist[index]
                                      .address
                                      .toString(),
                                  style: textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            controllerLoc.getDistanceInKm(
                              customerInfoController
                                  .custmerinfolist[index]
                                  .latitude,
                              customerInfoController
                                  .custmerinfolist[index]
                                  .longitude,
                            ),
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
