import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
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
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SolidColors.homepage,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CustomerInfoBloc>().add(CustomerInfoFetchData());
        },
        child: BlocBuilder<CustomerInfoBloc, CustomerInfoState>(
          builder: (context, state) {
            if (state is CustomerInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerInfoError) {
              return Center(child: Text(state.message));
            } else if (state is CustomerInfoLoaded) {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.customers.length,
                itemBuilder: (context, index) {
                  final customer = state.customers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CustomerPage(index: index)),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: SolidColors.listCustomerColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            right: BorderSide(
                              style: BorderStyle.solid,
                              width: 5,
                              color: customer.visited == 1
                                  ? SolidColors.pointVisitColor
                                  : customer.visited == 2
                                      ? SolidColors.pointNoSendEndJab
                                      : SolidColors.pointNoVisitColor,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87,
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.customerBoard.toString(),
                                      style: textTheme.bodyLarge,
                                    ),
                                    Text(
                                      customer.customerCode.toString(),
                                      style: textTheme.bodyLarge,
                                    ),
                                    Text(
                                      customer.address.toString(),
                                      style: textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BlocBuilder<LocationSyncBloc, LocationSyncState>(
                              builder: (context, locState) {
                                return Text(
                                  context
                                      .read<LocationSyncBloc>()
                                      .getDistanceInKm(
                                        customer.latitude,
                                        customer.longitude,
                                      ),
                                  style: const TextStyle(color: Colors.yellow),
                                );
                              },
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
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