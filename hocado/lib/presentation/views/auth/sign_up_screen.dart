import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_button_lg.dart';
import 'package:hocado/presentation/widgets/hocado_text_field.dart';
import 'package:hocado/presentation/widgets/logo_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final fullnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    fullnameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);
    final viewModel = ref.read(signUpViewModelProvider.notifier);

    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Color(0xFFcae642);
    final onPrimaryColor = Color(0xFF1A1A1C);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizes.appBarHeight,
          left: Sizes.defaultSpace,
          bottom: Sizes.defaultSpace,
          right: Sizes.defaultSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Logo, Title & Sub-Title
                Image(
                  height: 150,
                  image: AssetImage(Images.appLogo),
                ),
                SizedBox(height: Sizes.spaceBtwSections),

                // Form
                Form(
                  child: Column(
                    children: [
                      HocadoTextField(
                        controller: fullnameController,
                        text: "Full name",
                        prefixIcon: Icon(Icons.person_outline),
                        color: onPrimaryColor,
                      ),
                      SizedBox(height: Sizes.spaceBtwInputFields),

                      HocadoTextField(
                        controller: emailController,
                        text: "Email",
                        prefixIcon: Icon(Icons.mail_outline),
                        color: onPrimaryColor,
                      ),
                      SizedBox(height: Sizes.spaceBtwInputFields),

                      HocadoTextField(
                        controller: phoneController,
                        text: "Phone number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        color: onPrimaryColor,
                      ),
                      SizedBox(height: Sizes.spaceBtwInputFields),

                      HocadoTextField(
                        controller: passwordController,
                        text: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: true,
                        color: onPrimaryColor,
                      ),
                      SizedBox(height: Sizes.spaceBtwSections),

                      // Sign in button
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        HocadoButtonLg(
                          text: "Tạo tài khoản",
                          onPressed: () async {
                            await viewModel.signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              fullName: fullnameController.text.trim(),
                              phone: phoneController.text.trim(),
                            );

                            if (state.errorMessage != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage!)),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(height: Sizes.spaceBtwInputFields),

                // Sign up with Google & Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: onPrimaryColor,
                        thickness: 0.5,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      "or Sign up With",
                      style: textTheme.bodyLarge?.copyWith(
                        color: onPrimaryColor,
                      ),
                    ),
                    Flexible(
                      child: Divider(
                        color: onPrimaryColor,
                        thickness: 0.5,
                        indent: 5,
                        endIndent: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.spaceBtwInputFields),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoButton(
                      iconName: Images.googleLogo,
                      color: onPrimaryColor,
                      onPressed: () {},
                    ),
                    SizedBox(width: Sizes.spaceBtwItems),
                    LogoButton(
                      iconName: Images.facebookLogo,
                      color: onPrimaryColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),

            // Create account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Bạn đã có tài khoản?",
                      style: textTheme.bodyLarge?.copyWith(
                        color: onPrimaryColor,
                      ),
                    ),

                    TextButton(
                      onPressed: () => context.goNamed(AppRoutes.signIn.name),
                      child: Text(
                        "Đăng nhập",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: onPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
