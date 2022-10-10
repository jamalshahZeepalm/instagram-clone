import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Providers/user_provider.dart';
import 'package:instagram_clone/test.dart';
import 'package:instagram_clone/utils/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBv9J7mEeVjDNxHFtwC75SkZw6zhxiczH4",
        projectId: "instagram-clone-80820",
        storageBucket: "instagram-clone-80820.appspot.com",
        messagingSenderId: "403424457450",
        appId: "1:403424457450:web:823db15764f342132cdd93",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserProvider())
          ],
          child: GetMaterialApp(
            title: 'Istagram Clone',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.darkTheme,
            // home: StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.active) {
            //       if (snapshot.hasData) {
            //         return const ResponsiveLayout(
            //           mobileScreenLayout: MobileScreenLayout(),
            //           webScreenLayout: WebScreenLayout(),
            //         );
            //       } else if (snapshot.hasError) {
            //         return Center(
            //           child: Text(snapshot.error.toString()),
            //         );
            //       }
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           color: CustomColors.primaryColor,
            //         ),
            //       );
            //     }
            //     return const LoginScreen();
            //   },
            // ),
            home: TestPage(),
          ),
        );
      },
    );
  }
}
