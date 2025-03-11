import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/app_user.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_event.dart';
import 'package:leeds_library/presentation/block/user_register/register_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';


class RegisterScreen extends StatelessWidget {
  final AppUser user;

  RegisterScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: user.name ?? '');
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');
    final phoneAltController = TextEditingController(text: user.phoneNumberAlt ?? '');

    return BlocProvider(
      create: (context) => sl<GoogleAuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Register User")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone Number"),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: phoneAltController,
                    decoration: InputDecoration(labelText: "Alternate Phone (Optional)"),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  BlocConsumer<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                      if (state is RegisterSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration successful!")),
                        );
                        //context.pop(); // GoRouter повертається назад
                        context.pushReplacement(AppRoutes.welcome);
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final updatedUser = user.copyWith(
                              name: nameController.text.trim(),
                              phoneNumber: phoneController.text.trim(),
                              phoneNumberAlt: phoneAltController.text.trim().isNotEmpty
                                  ? phoneAltController.text.trim()
                                  : null,
                            );

                            context.read<RegisterBloc>().add(FetchRegister(user: updatedUser));
                          },
                          child: Text("Register"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

