import 'package:flutter/material.dart';
import 'package:uni_talk/utils/type.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneNumberController1 = TextEditingController();
  final _phoneNumberController2 = TextEditingController();
  final _phoneNumberController3 = TextEditingController();
  final FocusNode _phoneNumberFocusNode1 = FocusNode();
  final FocusNode _phoneNumberFocusNode2 = FocusNode();
  final FocusNode _phoneNumberFocusNode3 = FocusNode();

  bool _isValidPhoneNumber = false;

  @override
  void dispose() {
    _phoneNumberController1.dispose();
    _phoneNumberController2.dispose();
    _phoneNumberController3.dispose();
    _phoneNumberFocusNode1.dispose();
    _phoneNumberFocusNode2.dispose();
    _phoneNumberFocusNode3.dispose();
    super.dispose();
  }

  void _onPhoneNumberChanged() {
    String value = _phoneNumberController1.text +
        _phoneNumberController2.text +
        _phoneNumberController3.text;
    setState(() {
      _isValidPhoneNumber = isValidPhoneNumber(value);
    });
  }

  void _setFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text('휴대폰 번호를 입력해주세요.', style: theme.textTheme.headlineMedium),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController1,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    focusNode: _phoneNumberFocusNode1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 3) {
                        _setFocus(context, _phoneNumberFocusNode1,
                            _phoneNumberFocusNode2);
                      }
                      _onPhoneNumberChanged();
                    },
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: const Text('-', style: TextStyle(fontSize: 30)),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController2,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    focusNode: _phoneNumberFocusNode2,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 4) {
                        _setFocus(context, _phoneNumberFocusNode2,
                            _phoneNumberFocusNode3);
                      }
                      _onPhoneNumberChanged();
                    },
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: const Text('-', style: TextStyle(fontSize: 30)),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController3,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    focusNode: _phoneNumberFocusNode3,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 4) {
                        _phoneNumberFocusNode3.unfocus();
                      }
                      _onPhoneNumberChanged();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 65),
        child: ElevatedButton(
          onPressed: _isValidPhoneNumber
              ? () {
                  // Do something with the phone number
                }
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 50),
            backgroundColor: _isValidPhoneNumber
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
          child: const Text('다음'),
        ),
      ),
    );
  }
}
