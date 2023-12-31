import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../providers/jwt_provider.dart';
import '../../providers/data_provider.dart';
import '../../services/api.dart';
import 'components/welcome_text.dart';
import 'components/badger_image.dart';
import 'components/text_field.dart';
import 'components/login_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lnurlController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _lnurlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.blue[900]!, Colors.blue[800]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const WelcomeText(title: "You are new", subtitle: "We will need some information to startup"),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const BadgerImage(),
                        InputTextField(
                          controller: _usernameController,
                          hintText: "What username would you like?",
                        ),
                        const SizedBox(height: 10),
                        PasswordTextField(
                          controller: _passwordController,
                          hintText: "What password would you like?",
                        ),
                        const SizedBox(height: 10),
                        InputTextField(
                          controller: _lnurlController,
                          hintText: "Enter your lnurl to get your sats",
                        ),
                        const SizedBox(height: 10),
                        LoginButton(
                          onPressed: () {
                            _submitForm(context);
                          },
                          title: "Sign Up",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      String lnurl = _lnurlController.text;
      String? baseUrl = dotenv.env['BASE_URL'];

      if (baseUrl != null) {
        ApiService apiService = ApiService(baseUrl);
        try {
          ApiResult result = await apiService.sendAccountRequest(
            username: username,
            password: password,
            path: 'users',
            method: 'POST',
            lnurl: lnurl);

          if (result.success) {
            final token = result.data['token'];
            final jwtProvider = Provider.of<JwtProvider>(context, listen: false);
            final dataProvider = Provider.of<DataProvider>(context, listen: false);
            dataProvider.setUsername(username);
            dataProvider.setUserBalance(double.parse(result.data['user']['balance']));
            dataProvider.setLnurl(lnurl);
            jwtProvider.saveJwtToStorage(token);
            Navigator.pushNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${result.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
