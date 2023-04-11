// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uni_talk/providers/user_provider.dart';
// import 'package:uni_talk/screens/main_screen.dart';

// class VerifyCodeScreen extends StatefulWidget {
//   final String? verificationId;

//   const VerifyCodeScreen({super.key, required this.verificationId});

//   @override
//   State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
// }

// class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
//   final TextEditingController _verifactionCodeController =
//       TextEditingController();

//   final bool _isValidCode = false;

//   Future<void> _handleVerifyPhoneNumber(BuildContext context) async {
//     // Get the UserProvider instance
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     // Get the smsCode from the text controller
//     String code = _verifactionCodeController.text;

//     // Create a PhoneAuthCredential using the verificationId and smsCode
//     final phoneAuthCredential = PhoneAuthProvider.credential(
//       verificationId: widget.verificationId!,
//       smsCode: code,
//     );

//     try {
//       // Sign in with the PhoneAuthCredential
//       final User? user =
//           await userProvider.signInWithCredential(phoneAuthCredential);

//       if (user != null) {
//         // The user was successfully authenticated
//         // You can navigate to the main screen or other screens in your app
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const MainScreen(),
//           ),
//         );
//       } else {
//         // Show an error message
//         // ...
//       }
//     } catch (e) {
//       // Handle any errors, such as invalid code or expired verificationId
//       // ...
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 16,
//             ),
//             Text('인증 코드를 입력해주세요.', style: theme.textTheme.headlineMedium),
//             const SizedBox(
//               height: 40,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                   border: Border.all(color: theme.primaryColor, width: 2),
//                   borderRadius: BorderRadius.circular(10.0)),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _verifactionCodeController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 3,
//                       decoration: const InputDecoration(
//                         counterText: '',
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       onChanged: (value) {},
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       )),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 65),
//         child: ElevatedButton(
//           onPressed: _isValidCode
//               ? () {
//                   _handleVerifyPhoneNumber(context);
//                 }
//               : null,
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(120, 50),
//             backgroundColor:
//                 _isValidCode ? Theme.of(context).primaryColor : Colors.grey,
//           ),
//           child: const Text('다음'),
//         ),
//       ),
//     );
//   }
// }
