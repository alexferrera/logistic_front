import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {

    on<CreateOrderEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        final order = await repository.placeOrder(
          tenantId: event.tenantId,
          userId: event.userId,
          amount: event.amount,
        );
        emit(OrderLoaded(order));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<GetOrderEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        final order = await repository.getPendingOrderForCustomer(tenantId: event.tenantId, customerId: event.customerId);

        emit(OrderLoaded(order!));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<RefreshOrderEvent>((event, emit) async {
      print("REFRESH CALLED");
      try {
        final order = await repository.getPendingOrderForCustomer(
          tenantId: event.tenantId,
          customerId: event.customerId,
        );
        emit(OrderLoaded(order));
      } catch (e) {
        print("REFRESH ERROR: $e");
        emit(OrderError(e.toString()));
      }
    });
  }
}