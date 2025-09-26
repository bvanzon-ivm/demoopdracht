import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/api_config.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/services/auth_service.dart';
import 'features/workspaces/repositories/workspace_repository.dart';
import 'features/workspaces/services/workspace_service.dart';
import 'features/workspaces/bloc/workspace_list_bloc.dart';
import 'features/tasks/repositories/task_repository.dart';
import 'features/tasks/services/task_service.dart';
import 'features/attachments/repositories/attachment_repository.dart';
import 'features/attachments/services/attachment_service.dart';

import 'generated/app_localizations.dart';
import 'screens/home_screen.dart';


void main() {
  ApiConfig.token = null;

  // services
  final authService = AuthService();
  final workspaceService = WorkspaceService();
  final taskService = TaskService();
  final attachmentService = AttachmentService();


  // repositories
  final authRepository = AuthRepository(authService);
  final workspaceRepository = WorkspaceRepository(workspaceService);
  final taskRepository = TaskRepository(taskService);
  final attachmentRepository = AttachmentRepository(attachmentService);

  runApp(MyApp(
    authRepository: authRepository,
    workspaceRepository: workspaceRepository,
    taskRepository: taskRepository,
    attachmentRepository: attachmentRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final WorkspaceRepository workspaceRepository;
  final TaskRepository taskRepository;
  final AttachmentRepository attachmentRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.workspaceRepository,
    required this.taskRepository,
    required this.attachmentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: workspaceRepository),
        RepositoryProvider.value(value: taskRepository),
        RepositoryProvider.value(value: attachmentRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository),
          ),
              BlocProvider(
      create: (context) => WorkspaceListBloc(workspaceRepository),
      
    ),
    
    
    // Als je detail schermen ook een global bloc willen:
    // BlocProvider(
    //   create: (context) => WorkspaceDetailBloc(workspaceRepository),
    // ),
        ],
        child: MaterialApp(
          title: 'Anchiano',
          theme: ThemeData(primarySwatch: Colors.blue),
          supportedLocales: const [
            Locale('en'),
            Locale('nl'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
