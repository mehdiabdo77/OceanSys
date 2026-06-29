import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';

AppBar customAppBar(BuildContext context, int? index) {
  return AppBar(
    elevation: 0,
    backgroundColor: SolidColors.appBorColor,
    actions: [
      IconButton(
        onPressed: () async {
          final customerInfoBloc = context.read<CustomerInfoBloc>();
          final customerEditBloc = context.read<CustomerEditBloc>();
          if (customerInfoBloc.state is CustomerInfoLoaded &&
              index != null &&
              index <
                  (customerInfoBloc.state as CustomerInfoLoaded)
                      .customers
                      .length) {
            final customer =
                (customerInfoBloc.state as CustomerInfoLoaded).customers[index];
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
              index != null &&
              index <
                  (customerInfoBloc.state as CustomerInfoLoaded)
                      .customers
                      .length) {
            final customer =
                (customerInfoBloc.state as CustomerInfoLoaded).customers[index];
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
  );
}
