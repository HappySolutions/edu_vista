// ignore_for_file: use_build_context_synchronously

import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:edu_vista/widgets/general/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String id = 'resetPassword';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController emailController;
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextFormField(
                  hintText: 'Happy@gmail.com',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        await context.read<AuthCubit>().resetPassword(
                            context: context, emailController: emailController);
                        Navigator.popAndPushNamed(context, 'LoginPage');
                      },
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
