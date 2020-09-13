import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:login_page_t1/utils/database.dart';
import 'package:login_page_t1/model/user.dart';
import 'package:path/path.dart';

void main()=> runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  )
);
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var email;
  var pass;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        width: double.infinity,

        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.red[600],
                  Colors.red[400],
                  Colors.pink[400],
                  Colors.pink[200],
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  FadeAnimation(1,Text("Login" ,style: TextStyle(color: Colors.black, fontSize: 40),)),
                  FadeAnimation(1.3,Text("Welcome back!" ,style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child:Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                ),
                child:Padding(
                  padding: EdgeInsets.all(20),
                  child:Form(
                    key: _formKey,
                    child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      FadeAnimation(1.5,Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Color.fromRGBO(240, 0, 0, 0.3),
                              blurRadius:20,
                              offset: Offset(0,10),
                            )]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.red[100]))
                              ),
                              child: TextFormField(

                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please enter email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //hintText: "Email or phone Number",
                                 // hintStyle: TextStyle(color: Colors.pink[300]),
                                  labelStyle: TextStyle(color: Colors.pink[300]),
                                  labelText: "Email/phone",
                                  border: InputBorder.none,
                                ),
                                onSaved: (String value){
                                  email=value;
                                },
                              ),
                            ),
                            Container(
                              padding:EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color:Colors.red[100]))
                              ),
                              child: TextFormField(
                                obscureText: true,
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Password is empty';
                                  }
                                  return null;
                                },
                                onSaved: (String value){
                                  pass=value;
                                },
                                decoration: InputDecoration(

                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.pink[300]),

                                  border: InputBorder.none,
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),),
                      SizedBox(height: 40,),
                      FadeAnimation(0.8,Text('Forgot Password?',style: TextStyle(color: Colors.grey[600]),)),
                      SizedBox(height:20,),
                      FadeAnimation(1.3,InkWell(
                        onTap:()async { print("tap login");
                          if(!_formKey.currentState.validate())
                            return;
                          _formKey.currentState.save();
                          print(email);
                          print(pass);
                          User current = User(username:email,password: pass);
                          print(current.toString());
                          DBProvider.db.existUser(current);
                        },

                        child:Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 120),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red[800]
                          ),
                          child: Center(
                            child: Text("Login" , style: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,),
                            ),
                          ),
                        ),
                      ),),
                      SizedBox(height: 20,),
                      FadeAnimation(0.8,Text('New user?',style: TextStyle(color: Colors.grey[600]),)),
                      SizedBox(height:20,),
                      FadeAnimation(1.5,InkWell(
                          onTap:()async {
                            print("tap Signup");
                            if (!_formKey.currentState.validate())
                              return;
                            _formKey.currentState.save();
                            print(email);
                            print(pass);
                            User current = User(
                                username: email, password: pass);
                            print(current.toString());
                            DBProvider.db.newUser(current);
                            DBProvider.db.allUsers();
                          },
                        child:Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 90),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red[800]),
                          child:Center(
                          child: Text("Sign Up!" , style: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,),
                          ),
                        ),)
                      ),),
                    ],
                  ),
                  ),
                ) ,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Fade animation class

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]),
            child: child
        ),
      ),
    );
  }
}
