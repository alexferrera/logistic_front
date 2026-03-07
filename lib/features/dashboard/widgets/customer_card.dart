
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildCustomerCard({
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