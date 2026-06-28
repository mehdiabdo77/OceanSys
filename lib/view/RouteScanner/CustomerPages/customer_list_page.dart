import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerInfoBloc>().add(CustomerInfoFetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      body: RefreshIndicator(
        color: SolidColors.primaryColor,
        onRefresh: () async {
          context.read<CustomerInfoBloc>().add(CustomerInfoFetchData());
        },
        child: BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
          builder: (context, state) {
            if (state is CustomerInfoLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: SolidColors.primaryColor,
                ),
              );
            } else if (state is CustomerInfoError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(state.message, style: MyTextStyle.textBlak12),
                ),
              );
            } else if (state is CustomerInfoLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.customers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = state.customers[index];
                  final statusColor = customer.visited == 1
                      ? SolidColors.pointVisitColor
                      : customer.visited == 2
                      ? SolidColors.pointNoSendEndJab
                      : SolidColors.pointNoVisitColor;
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerPage(index: index),
                        ),
                      );
                      if (context.mounted) {
                        context.read<CustomerInfoBloc>().add(
                          CustomerInfoFetchData(),
                        );
                      }
                    },
                    child: Container(
                      decoration: MyDecorations.cardDecoration,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.storefront_outlined,
                              color: statusColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.customerBoard.toString(),
                                  style: MyTextStyle.headlineMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  customer.customerName ?? '',
                                  style: MyTextStyle.textSmall12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        customer.address.toString(),
                                        style: MyTextStyle.caption,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<LocationSyncBloc, LocationSyncState>(
                            builder: (context, locState) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: SolidColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  context
                                      .read<LocationSyncBloc>()
                                      .getDistanceInKm(
                                        customer.latitude,
                                        customer.longitude,
                                      ),
                                  style: TextStyle(
                                    color: SolidColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
