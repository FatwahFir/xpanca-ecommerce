import 'package:xpanca_ecommerce/core/shared/extensions/snack_extensions.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/gradient_button.dart';
import 'package:xpanca_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (c, s) {
          if (s.authenticated) {
            context.go('/');
          }
          if (s.error != null && s.error!.trim().isNotEmpty) {
            context.showSnack(s.error!);
          }
        },
        builder: (c, s) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // logo / ilustrasi kecil (opsional)
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),

                        // Username
                        TextFormField(
                          style: const TextStyle(fontSize: 14),
                          controller: _username,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(fontSize: 14),
                            hintText: 'Username or email',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Iconsax.user,
                              size: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: green,
                                width: 0.5,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            if (v.trim().length < 3) {
                              return 'Minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Password
                        TextFormField(
                          style: const TextStyle(fontSize: 14),
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Iconsax.lock,
                              size: 16,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure ? Iconsax.eye_slash : Iconsax.eye,
                                size: 18,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: green,
                                width: 0.5,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (v.length < 6) {
                              return 'Minimal 6 karakter';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(s),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: 8),

                        SizedBox(
                          height: 40,
                          child: s.loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                )
                              : GradientButton(
                                  onTap: () => _submit(s),
                                  text: "Login",
                                  icon: Iconsax.login,
                                ),
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don’t have an account?',
                                style: TextStyle(color: Colors.grey[700])),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Sign up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(AuthState s) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      context.showSnack('Periksa kembali input kamu');
      return;
    }
    context
        .read<AuthBloc>()
        .add(AuthLoginRequested(_username.text.trim(), _password.text));
  }
}
