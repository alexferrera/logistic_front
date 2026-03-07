import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/view/login_screen.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  Timer? _pollingTimer;

  int quantity = 1;
  int? currentOrderId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is LoginSuccess) _refreshOrder();
  }

  void _submitOrder(int tenantId, int userId) {
    context.read<OrderBloc>().add(
      CreateOrderEvent(tenantId: tenantId, userId: userId, amount: quantity),
    );
  }

  void increase() => setState(() => quantity++);
  void decrease() {
    if (quantity > 1) setState(() => quantity--);
  }

  void _refreshOrder() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! LoginSuccess) return;
    final user = authState.user;
    context.read<OrderBloc>().add(
      RefreshOrderEvent(tenantId: user.tenantId, customerId: user.customerId),
    );
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) => _refreshOrder());
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! LoginSuccess) {
      return const Scaffold(body: Center(child: Text("Usuario no autenticado")));
    }
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¡Bienvenid@,  ${user.role == 'customer' ? user.name : user.role}!"),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.blue,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is OrderLoaded) {
            if (state.order?.status == "pending") {
              currentOrderId = state.order!.orderId;
              _startPolling();
            } else {
              currentOrderId = null;
              _stopPolling();
              setState(() => quantity = 1);
              if (state.order?.status == "delivered") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Pedido entregado"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          }
        },
        builder: (context, state) {
          bool orderPlaced = false;
          int pendingQuantity = quantity;
          if (state is OrderLoaded && state.order?.status == "pending") {
            orderPlaced = true;
            pendingQuantity = state.order?.quantity ?? quantity;
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshOrder(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Estado del pedido
                  if (orderPlaced)
                    Card(
                      color: Colors.orange.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            const Icon(Icons.hourglass_top, color: Colors.orange, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Pedido pendiente: $pendingQuantity botellones",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Icono principal
                  const Icon(Icons.water_drop, size: 120, color: Colors.blue),
                  const SizedBox(height: 24),

                  // Pregunta o estado
                  Text(
                    orderPlaced
                        ? "Tu pedido está pendiente de entrega"
                        : "¿Cuántos botellones necesitas?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Selector de cantidad
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            iconSize: 40,
                            onPressed: orderPlaced ? null : decrease,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            iconSize: 40,
                            color: Colors.blue,
                            onPressed: orderPlaced ? null : increase,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Selecciona la cantidad que necesitas",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: orderPlaced ? null : () => _submitOrder(user.tenantId, user.userId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orderPlaced ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state is OrderLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                          : Text(
                        orderPlaced ? "Pedido pendiente..." : "Ordenar",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}