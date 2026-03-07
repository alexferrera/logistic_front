import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/dasboard_repository.dart';
import 'dasboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

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
      emit(DashboardLoading());
      try {
        await repository.createCustomer(event.customer);

        emit(DashboardInitial());
      } on DioException catch (e) {
        final msg = e.response?.data?["message"]?.toString() ?? e.toString();

        if (msg.contains("unique")) {
          emit(DashboardError(message: "El teléfono ya está registrado"));
        } else {
          emit(DashboardError(message: msg));
        }
      }
    });

    on<LoadCustomers>((event, emit) async {
      emit(DashboardLoading());

      try {
        final customers = await repository.getCustomers(event.tenantId);

        emit(DashboardCustomersLoaded(customers: customers));
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });

    on<ClearDashboard>((event, emit) {
      emit(DashboardInitial());
    });
  }
}