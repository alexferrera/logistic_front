import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistiQ/features/auth/bloc/auth_event.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isEmailLogin = _emailController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (state.user.role == "customer") {
              Navigator.pushReplacementNamed(context, "/customerScreen");
            } else {
              Navigator.pushReplacementNamed(context, "/dashboard");
            }
          }

          if (state is LoginFailure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF11162A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF5C8CFF).withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        color: Color(0xFF5C8CFF),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF5C8CFF),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          _isLoading = state is LoginLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF11162A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30, width: 0.4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A7DFF).withOpacity(0.40),
                              blurRadius: 18,
                              spreadRadius: 3,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_drink,
                          color: Color(0xFF4A7DFF),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "LogistiQ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Introduce tu número de teléfono si eres cliente, introduce tu correo y contraseña si eres administrador",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 15),
                      ),
                      const SizedBox(height: 32),

                      _buildInputField(
                        controller: _emailController,
                        label: "Correo electrónico",
                        icon: Icons.person,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      if (!isEmailLogin)
                        _buildInputField(
                          controller: _phoneController,
                          label: "Teléfono",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),

                      if (isEmailLogin)
                        _buildInputField(
                          controller: _passwordController,
                          label: "Contraseña",
                          icon: Icons.lock,
                          obscureText: _hidePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                        ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  final bloc = context.read<AuthBloc>();
                                  if (isEmailLogin) {
                                    bloc.add(
                                      LoginSubmitted(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        phone: '',
                                      ),
                                    );
                                  } else {
                                    bloc.add(
                                      LoginSubmitted(
                                        phone: _phoneController.text,
                                        email: '',
                                        password: '',
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C8CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5C8CFF)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF11162A),
            prefixIcon: Icon(icon, color: Colors.white54),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
