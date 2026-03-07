// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../auth/bloc/auth_bloc.dart';
// import '../../auth/bloc/auth_state.dart';
// import '../bloc/dasboard_event.dart';
// import '../bloc/dashboard_bloc.dart';
// import 'get_order_color.dart';
//
// Widget _buildOrderCard(order, String elapsed) {
//   return Card(
//     color: getOrderColor(order.createdAt),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     elevation: 4,
//     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 order.customerName,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.blue.shade50,
//                     ),
//                     child: const Icon(
//                       Icons.local_drink,
//                       color: Colors.blue,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     "${order.quantity} botellones",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                       height: 1,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.red.shade50,
//                     ),
//                     child: const Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       order.address,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                         height: 1,
//                         letterSpacing: 0.2,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.green.shade50,
//                     ),
//                     child: const Icon(
//                       Icons.phone,
//                       color: Colors.green,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     order.phone,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                       height: 1,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.blue.shade50.withOpacity(0.2),
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(16),
//               bottomRight: Radius.circular(16),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, color: Colors.blue, size: 18),
//                   const SizedBox(width: 4),
//                   Text(
//                     elapsed,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () => _completeOrder(order.id),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   textStyle: const TextStyle(fontSize: 14),
//                 ),
//                 child: const Text(
//                   "Entregado",
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// void _completeOrder(int orderId) {
//   final authState = context.read<AuthBloc>().state;
//   if (authState is LoginSuccess) {
//     context.read<DashboardBloc>().add(
//       CompleteOrderEvent(tenantId: authState.user.tenantId, orderId: orderId),
//     );
//   }
// }
