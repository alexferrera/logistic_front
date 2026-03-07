import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistiQ/features/auth/data/datasources/remote_datasource.dart';
import 'package:logistiQ/features/auth/data/datasources/login_repository_imp.dart';
import 'package:logistiQ/features/auth/data/session_storage.dart';
import 'package:logistiQ/features/auth/view/login_screen.dart';
import 'package:logistiQ/features/dashboard/view/dashboard_screen.dart';
import 'package:logistiQ/features/order/bloc/order_bloc.dart';
import 'package:logistiQ/features/order/data/datasources/order_repository_imp.dart';
import 'package:logistiQ/features/order/data/datasources/remote.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/data/datasources/dasboard_repository.dart';
import 'features/dashboard/data/datasources/dashboard_remote.dart';
import 'features/order/view/customer_screen.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://logistiq-nxyd.onrender.com',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );

  final remote = RemoteDatasource(dio: dio);
  final orderRemote = RemoteOrderDataSource(dio: dio);
  final dashboardRemote = DashboardRemoteDatasource(dio: dio);

  final authRepo = LoginRepositoryImp(datasource: remote);
  final customerRepo = OrderRepositoryImpl(orderRemote);
  final dashboardRepo = DashboardRepository(remote: dashboardRemote);

  final sessionStorage = SessionStorage();

  final authBloc = AuthBloc(repository: authRepo, sessionStorage: sessionStorage);

  authBloc.add(RestoreSession());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider(create: (_) => OrderBloc(repository: customerRepo)),
        BlocProvider(create: (_) => DashboardBloc(repository: dashboardRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitialLoading) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        Widget homeScreen;
        if (state is LoginSuccess) {
          homeScreen = state.user.role == 'owner'
              ? const DashboardScreen()
              : const CustomerScreen();
        } else {
          homeScreen = const LoginScreen();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LogistiQ',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: homeScreen,
          routes: {
            "/login": (context) => const LoginScreen(),
            "/dashboard": (context) => const DashboardScreen(),
            "/customerScreen": (context) => const CustomerScreen(),
          },
        );
      },
    );
  }
}