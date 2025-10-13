import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_button_lg.dart';
import 'package:hocado/presentation/widgets/hocado_text_field.dart';
import 'package:hocado/presentation/widgets/logo_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInViewModelProvider);
    final viewModel = ref.read(signInViewModelProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
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
                        controller: emailController,
                        text: "Email",
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      SizedBox(height: Sizes.spaceBtwInputFields),

                      HocadoTextField(
                        controller: passwordController,
                        text: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: true,
                      ),
                      SizedBox(
                        height: Sizes.spaceBtwInputFields / 2,
                      ),

                      Row(
                        children: [
                          Text(
                            "Quên mật khẩu?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),

                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Đặt lại",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Sizes.spaceBtwSections),

                      // Sign in button
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        HocadoButtonLg(
                          text: "Đăng nhập",
                          onPressed: () async {
                            await viewModel.signIn(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (state.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage!)),
                              );
                            }
                          },
                        ),
                      //
                    ],
                  ),
                ),
                SizedBox(height: Sizes.spaceBtwInputFields),

                // Sign in with Google & Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                        thickness: 0.5,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      "or Sign in With",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Flexible(
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
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
                      onPressed: () {},
                    ),
                    SizedBox(width: Sizes.spaceBtwItems),
                    LogoButton(
                      iconName: Images.facebookLogo,
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
                      "Bạn chưa có tài khoản?",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    TextButton(
                      onPressed: () => context.goNamed(AppRoutes.signUp.name),
                      child: Text(
                        "Tạo tài khoản",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
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
