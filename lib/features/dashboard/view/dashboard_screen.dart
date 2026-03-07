import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistiQ/features/auth/bloc/auth_event.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/view/login_screen.dart';
import '../bloc/dasboard_event.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../data/models/customer_dto.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _loadOrders();

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _loadOrders();
      } else {
        _loadCustomers();
      }
    });
  }

  void _loadOrders() {
    final authState = context.read<AuthBloc>().state;
    if (authState is LoginSuccess) {
      context.read<DashboardBloc>().add(
        LoadPendingOrders(authState.user.tenantId),
      );
    }
  }

  void _loadCustomers() {
    final authState = context.read<AuthBloc>().state;

    if (authState is LoginSuccess) {
      context.read<DashboardBloc>().add(
        LoadCustomers(authState.user.tenantId),
      );
    }
  }

  void _reloadCurrentTab() {
    if (_tabController.index == 0) {
      _loadOrders();
    } else {
      _loadCustomers();
    }
  }

  Color getOrderColor(DateTime createdAt) {
    final minutes = DateTime.now().difference(createdAt).inMinutes;
    if (minutes < 15) {
      return Colors.green.shade200;
    } else if (minutes < 20) {
      return Colors.yellow.shade200;
    } else if (minutes < 30) {
      return Colors.orange.shade200;
    } else {
      return Colors.red.shade300;
    }
  }

  String formatElapsedTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) {
      return "Hace ${diff.inSeconds} seg";
    } else if (diff.inMinutes < 60) {
      return "Hace ${diff.inMinutes} min";
    } else if (diff.inHours < 24) {
      return "Hace ${diff.inHours} h";
    } else {
      return "Hace ${diff.inDays} d";
    }
  }

  void _showAddCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nuevo Cliente"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Dirección"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is LoginSuccess) {
                  final customer = CustomerDTO(
                    name: nameController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                    tenantId: authState.user.tenantId,
                  );
                  context.read<DashboardBloc>().add(
                    AddCustomerEvent(customer: customer),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _completeOrder(int orderId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is LoginSuccess) {
      context.read<DashboardBloc>().add(
        CompleteOrderEvent(tenantId: authState.user.tenantId, orderId: orderId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<DashboardBloc>().add(ClearDashboard());
              context.read<AuthBloc>().add(LogoutRequested());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          title: const Text("Panel Administrador"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Pedidos", icon: Icon(Icons.local_drink)),
              Tab(text: "Clientes", icon: Icon(Icons.person)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reloadCurrentTab,
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // TAB PEDIDOS
            Column(
              children: [
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoaded) {
                      return _buildTodayStats(
                        state.bottlesDelivered,
                        state.ordersCompleted,
                      );
                    }
                    return _buildTodayStats(0, 0);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pedidos Pendientes",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state is DashboardLoaded &&
                              state.orders.isNotEmpty) {
                            final totalBotellones = state.orders.fold<int>(
                              0,
                              (sum, order) => sum + order.quantity,
                            );
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Tienes $totalBotellones botellones pendientes en ${state.orders.length} pedidos",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is DashboardError) {
                        return Center(child: Text("Error: ${state.message}"));
                      }
                      if (state is DashboardLoaded) {
                        final orders = state.orders;
                        if (orders.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.inbox, size: 80, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  "No hay pedidos pendientes",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            final elapsed = formatElapsedTime(order.createdAt);
                            return _buildOrderCard(order, elapsed);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),

            // TAB CLIENTES
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddCustomerDialog(context),
                      icon: const Icon(Icons.person_add),
                      label: const Text("Agregar Nuevo Cliente"),
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {

                      if (state is DashboardLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is DashboardCustomersLoaded) {

                        if (state.customers.isEmpty) {
                          return const Center(
                            child: Text("No hay clientes registrados"),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.customers.length,
                          itemBuilder: (context, index) {

                            final customer = state.customers[index];

                            return _buildCustomerCard(
                              name: customer.name,
                              phone: customer.phone,
                              address: customer.address,
                            );
                          },
                        );
                      }

                      return const Center(child: Text("Cargando clientes..."));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(order, String elapsed) {
    return Card(
      color: getOrderColor(order.createdAt),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                      ),
                      child: const Icon(
                        Icons.local_drink,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${order.quantity} botellones",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade50,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.address,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.phone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      elapsed,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _completeOrder(order.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text(
                    "Entregado",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTodayStats(int bottles, int orders) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_drink, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Entregado hoy",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "$bottles botellones • $orders pedidos",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCustomerCard({
  required String name,
  required String phone,
  required String address,
}) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER CLIENTE
          Row(
            children: [
              /// AVATAR
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// NOMBRE + TELEFONO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    GestureDetector(
                      onTap: () => _callCustomer(phone),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// DIRECCION
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
                color: Colors.red,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACCIONES
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              /// BOTON LLAMAR
              ElevatedButton.icon(
                onPressed: () => _callCustomer(phone),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text("Llamar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// EDITAR
              IconButton(
                onPressed: () {
                  // editar cliente
                },
                icon: const Icon(Icons.edit),
                tooltip: "Editar cliente",
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Future<void> _callCustomer(String phone) async {
  final Uri url = Uri(scheme: 'tel', path: phone);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}