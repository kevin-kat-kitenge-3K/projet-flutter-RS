import 'package:flutter/material.dart';
import 'package:picha/custom_widget/my_gradient.dart';
import 'package:picha/model/alert_helper.dart';
import 'package:picha/model/color_theme.dart';
import 'package:picha/model/my_painter.dart';
import 'package:picha/util/firebase_handler.dart';
import '../custom_widget/my_textField.dart';
import '../custom_widget/padding_with.dart';
import '../util/images.dart';


class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => AuthState();
}

class AuthState extends State<AuthController> {

  late PageController _pageController;
  late TextEditingController _mail;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _surname;

  @override
  void initState() {
      // TODO: implement initState

      _pageController = PageController();
      _mail = TextEditingController();
      _password = TextEditingController();
      _name = TextEditingController();
      _surname = TextEditingController();
      super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mail.dispose();
    _password.dispose();
    _name.dispose();
    _surname.dispose();
    super.dispose();
  }


  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: InkWell(
              onTap: () {
                 hideKeyboard();
              },
              child: Container(
                decoration: MyGradient(startColor: ColorTheme().base(), endColor: ColorTheme().pointer()),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height > 700) ? MediaQuery.of(context).size.height : 700,

                child:
                SafeArea(
                  child: Column(
                    children: [
                      PaddingWith(child:
                      Image.asset(logoImage, height: MediaQuery.of(context).size.height /5,),
                      ),
                      logOrCreateButtons(),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          children: [
                            logCard(true),
                            logCard(false)
                          ],
                        ),
                        flex: 2,
                      ),
                      PaddingWith(
                        child: TextButton(
                          onPressed: () {
                            authToFirebase();
                          },
                            //bouton connecter
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: MyGradient(
                              horizontal: true,
                              radius: 25,
                              startColor: ColorTheme().accent(),
                               endColor: ColorTheme().pointer()
                            ),
                            child: Center(child: Text("C'est parti")),
                          )

                        ),

                      )
                    ],
                  ),
                ),

              )

          ),
        ),
      )

    );
  }


  Widget logOrCreateButtons() {
    return Container(
      decoration: MyGradient(
          horizontal: true,
          startColor: ColorTheme().base(), endColor: ColorTheme().pointer(),
        radius: 25
      ),
      width: 300,
     
      child: CustomPaint(
        painter: MyPainter(pageController: _pageController),
        child: Row(
          children: [
           btn("Se connecter"),
           btn("Creer un compte"),
         ],
        ),
      ),
    );
  }

  Expanded btn (String name) {
    return Expanded(
      child: TextButton(
        child: Text(name),
        onPressed: () {
          int page = (_pageController.page == 0.0) ? 1:0;
          _pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        }

      ),
    );
  }


  Widget logCard(bool userExists) {
    List<Widget> list = [];
    if (!userExists) {
      list.add(MyTextField(controller: _surname, hint: "Entrez votre prenom",));
      list.add(MyTextField(controller: _name, hint: "Entrez votre nom",));
    }
    list.add(MyTextField(controller: _mail, hint: "Entrez l'adresse mail",type: TextInputType.emailAddress ));
    list.add(MyTextField(controller: _password, hint: "Entrez votre mot de paase", obscure: true));

    return PaddingWith(
        child: Center(
          child: Card(
            elevation: 7.5,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: list,
            ),
          ),
        )
    );

  }

  authToFirebase() {
    hideKeyboard();
    bool signIn = (_pageController.page == 0);
    String name = _name.text;
    String surname = _surname.text;
    String mail = _mail.text;
    String pwd = _password.text;

    bool validText(String string) {
      return (string != null && string != "");
    }

    if ((validText(mail)) && (validText(pwd))) {
      if (signIn) {
        // Methode vers Firebase
        FirebaseHandler().signIn(mail, pwd);
      } else {
        if ((validText(name)) && (validText(surname))) {
          // Methode vers Firebase
          FirebaseHandler().createUser(mail, pwd, name, surname);
        } else {
          //Alerte nom et prenom
          AlertHelper().error(context, "Nom ou prenom inexistant");
        }
      }
    } else {
      //Alerte utilisateur pas de mail ou mot de passe
      AlertHelper().error(context, "Mot de passe ou mail inexistant");
    }
  }

}