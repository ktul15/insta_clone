import 'package:client/core/network/dio_client.dart';
import 'package:client/core/network/server_constants.dart';
import 'package:client/core/router/route_paths.dart';
import 'package:client/core/router/router.dart';
import 'package:client/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:client/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:client/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:client/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:client/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRemoteDataSource>(
          create:
              (context) => AuthRemoteDataSourceImpl(
                dioClient: DioClient(baseUrl: ServerConstants.serverBaseUrl),
              ),
        ),
        RepositoryProvider<AuthLocalDataSource>(
          create: (context) => AuthLocalDataSourceImpl(sharedPreferences),
        ),
        RepositoryProvider<AuthRepository>(
          create:
              (context) => AuthRepositoryImpl(
                remoteDataSource: context.read<AuthRemoteDataSource>(),
                localDataSource: context.read<AuthLocalDataSource>(),
              ),
        ),
      ],
      child: BlocProvider(
        create:
            (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(AuthCheckRequested()),
        child: MaterialApp.router(
          title: 'Instagram Clone',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: gorouter,
        ),
      ),
    );
  }
}

// Temporary HomePage, replace with your actual home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const route = RoutePaths.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            context.goNamed(LoginPage.route);
          }
        },
        child: Center(child: Text('Welcome to Instagram Clone')),
      ),
    );
  }
}
