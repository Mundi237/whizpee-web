// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:s_translation/generated/l10n.dart';
// import 'package:super_up/app/core/api_service/auth/auth_api.dart';
// import 'package:super_up_core/super_up_core.dart';
//
// import '../../../../core/api_service/auth/auth_api_service.dart';
// import '../../../../core/api_service/profile/profile_api_service.dart';
// import '../../../../core/app_nav/app_navigation.dart';
//  import '../../../../core/widgets/animated_typing_text_with_fade.dart';
// import '../../../../core/widgets/app_logo.dart';
// import '../../../../core/widgets/reusable_text_field.dart';
// import '../../../../core/widgets/s_app_button.dart';
// import '../../phone_login/phone_authentication.dart';
// import '../controllers/register_controller.dart';
//
// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});
//
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<RegisterView> {
//   late final RegisterController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = RegisterController(
//       GetIt.I.get<AuthApiService>(),
//       GetIt.I.get<ProfileApiService>(),
//     );
//     controller.onInit();
//   }
//
//   @override
//   void dispose() {
//     controller.onClose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.of(context);
//     return Scaffold(
//       backgroundColor: theme.background,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: Center(
//           child: ValueListenableBuilder(
//             valueListenable: controller,
//             builder: (context, value, child) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Logo
//                       AppLogo(),
//                       const SizedBox(height: 20),
//                       AnimatedTypingTextWithFade(
//                         texts: const [
//                           //todo trans
//                           'Welcome to Super Up!',
//                           'Your favorite chat app...',
//                           'Connect with friends...',
//                           'Share your moments...',
//                         ],
//                         textStyle: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: theme.isDark
//                               ? AppTheme.primaryGreen
//                               : Colors.green[700],
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       AppTextField(
//                         controller: controller.nameController,
//                         requestFocus: true,
//                         hintText: S.of(context).fullName,
//                         prefixIcon: Icons.edit,
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.next,
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Email TextField
//                       AppTextField(
//                         controller: controller.emailController,
//                         hintText: S.of(context).email,
//                         prefixIcon: Icons.email_outlined,
//                         keyboardType: TextInputType.emailAddress,
//                         textInputAction: TextInputAction.next,
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Password TextField
//                       AppTextField(
//                         controller: controller.passwordController,
//                         hintText: S.of(context).password,
//                         prefixIcon: Icons.lock_outline,
//                         suffixIcon: Icons.visibility_outlined,
//                         textInputAction: TextInputAction.next,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 16),
//                       AppTextField(
//                         controller: controller.confirmController,
//                         hintText: S.of(context).confirmPassword,
//                         prefixIcon: Icons.lock_outline,
//                         suffixIcon: Icons.visibility_outlined,
//                         textInputAction: TextInputAction.next,
//                         obscureText: true,
//                       ),
//
//                       const SizedBox(height: 24),
//                       AppButton(
//                         isLoading: controller.isRegistering,
//                         disabled: controller.isRegistering,
//                         text: S.of(context).register,
//                         onPressed: () => controller.register(context),
//                       ),
//                       // Login Button
//
//                       const SizedBox(height: 16),
//                       AppButton(
//                         //todo trans
//                         text: 'Login with Phone',
//                         isLoading: false,
//                         disabled: controller.isRegistering,
//                         icon: Icons.phone,
//                         type: AppButtonType.outlined,
//                         onPressed:  (){
//                           AppNavigation.toPage(context, PhoneAuthentication());
//                         },
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // Register Link
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             S.of(context).alreadyHaveAnAccount,
//                             style: TextStyle(color: theme.textSecondary),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               context.pop();
//                             },
//                             child: Text(
//                               S.of(context).login,
//                               style: TextStyle(
//                                 color: AppTheme.primaryOrange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
