import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'register_screen.dart';
import 'workspace_list_screen.dart';
import '../features/workspaces/bloc/workspace_list_bloc.dart';
import '../features/workspaces/repositories/workspace_repository.dart';

class LoginScreen extends StatefulWidget {
  final String? error;
  const LoginScreen({super.key, this.error});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) =>
                      WorkspaceListBloc(context.read<WorkspaceRepository>())
                        ..add(LoadWorkspaces()), // 🚀 direct laden
                  child: WorkspaceListScreen(user: state.user),
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (widget.error != null)
                  Text(
                    widget.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val != null && val.contains('@')
                      ? null
                      : "Enter a valid email",
                  onSaved: (val) => _email = val ?? "",
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (val) => val != null && val.length >= 6
                      ? null
                      : "Password too short",
                  onSaved: (val) => _password = val ?? "",
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<AuthBloc>().add(
                        LoginRequested(_email, _password),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("No account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
