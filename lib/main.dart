import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GitHubLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GitHubLogin extends StatelessWidget {
  const GitHubLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              try {
                // Show loading indicator or disable the button here.

                UserCredential userCredential = await signInWithGithub();
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Welcome(
                        displayName: userCredential.user!.displayName!,
                        photoURL: userCredential.user!.photoURL ?? "",
                        email: userCredential.user!.email!,
                      ),
                    ),
                  );
                }
              } catch (e) {
                // Handle the error and hide the loading indicator or enable the button.
                // callCustomStatusAlert(context, e.toString(), false);
                print("This is error=================================================$e");
              }
            },
            child: const Text("Github")),
      ),
    );
  }

  Future<UserCredential> signInWithGithub() async {
    try {
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      return await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
    } catch (e) {
      rethrow
      ;
    }
  }
}

class Welcome extends StatefulWidget {
  final String photoURL;
  final String displayName;
  final String email;

  const Welcome(
      {required this.photoURL,
      required this.displayName,
      required this.email,
      super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (widget.photoURL.isEmpty)
              ? const SizedBox(
                  width: 100,
                  child: Placeholder(
                    fallbackHeight: 100,
                  ),
                )
              : ClipRRect(
                  child: Image.network(widget.photoURL),
                ),
          Text(
            widget.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.email,
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          )
        ],
      )),
    );
  }
}

//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider(
//         create: (context) => AuthProvider(),
//         child: HomePage(),
//       ),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GitHub Auth Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//
//             try{
//               final authProvider = Provider.of<AuthProvider>(context, listen: false);
//               await authProvider.signInWithGitHub();
//             }catch(e){
//               print("----------------error $e");
//             }
//           },
//           child: Text('Sign In with GitHub'),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
// class AuthProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   User? get user => _auth.currentUser;
//
//   Future<UserCredential?> signInWithGitHub() async {
//     try {
//
//     } catch (e) {
//       print("==============================================$e");
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//     notifyListeners();
//   }
// }
