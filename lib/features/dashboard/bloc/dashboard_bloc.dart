import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/dasboard_repository.dart';
import '../data/models/customer_dto.dart';
import 'dasboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  List<CustomerDTO>? _cachedCustomers;


  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadPendingOrders>((event, emit) async {
      emit(DashboardLoading());

      try {
        final orders = await repository.getPendingOrders(event.tenantId);
        final stats = await repository.getTodayStats(event.tenantId);

        emit(
          DashboardLoaded(
            orders: orders,
            bottlesDelivered: stats.bottlesDelivered,
            ordersCompleted: stats.ordersCompleted,
          ),
        );
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    on<CompleteOrderEvent>((event, emit) async {
      try {
        await repository.completeOrder(
          event.tenantId,
          event.orderId,
        );

        final orders = await repository.getPendingOrders(event.tenantId);
        final stats = await repository.getTodayStats(event.tenantId);

        emit(
          DashboardLoaded(
            orders: orders,
            bottlesDelivered: stats.bottlesDelivered,
            ordersCompleted: stats.ordersCompleted,
          ),
        );
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    on<AddCustomerEvent>((event, emit) async {
      try {
        await repository.createCustomer(event.customer);

        final customers = await repository.getCustomers(event.customer.tenantId);

        _cachedCustomers = customers;

        emit(DashboardCustomersLoaded(customers: customers));
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    on<LoadCustomers>((event, emit) async {

      if (_cachedCustomers != null) {
        emit(DashboardCustomersLoaded(customers: _cachedCustomers!));
        return;
      }

      emit(DashboardLoading());

      try {
        final customers = await repository.getCustomers(event.tenantId);

        _cachedCustomers = customers;

        emit(DashboardCustomersLoaded(customers: customers));
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    on<RefreshCustomersRequested>((event, emit) {
      _cachedCustomers = null;

      add(LoadCustomers(event.tenantId));
    });

    on<ClearDashboard>((event, emit) {
      emit(DashboardInitial());
    });
  }
}