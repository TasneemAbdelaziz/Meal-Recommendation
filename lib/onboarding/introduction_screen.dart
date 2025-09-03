import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_app_withai/features/auth/presentation/pages/sign_in_page.dart';
import 'package:recipe_app_withai/onboarding/custom_intro.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  static const String routeName='intro';
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {

  PageController controller = PageController();
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              onPageChanged: (pageNumber){
                setState(() {

                });
                lastPage = (pageNumber==3);
              },
              children: [
                IntroPage(image: "assets/images/well_done.png",
                    title: "Discover hundreds of recipes",
                    description: "Discover new tastes to prepare at add_recipe,your culinary adventure begins!",
                  pageNumber: 1,

                ),

                IntroPage(image: "assets/images/pizza.png",
                    title: "Search with name",
                    description: "from recipe name find your recipe and see its preparation steps, calories",
                  pageNumber: 2,
                ),

                IntroPage(image: "assets/images/well_done.png", title: "Register to Save own recipes", description: "when you register you can save own favorite recipe",
                  pageNumber: 3,
                ),

                IntroPage(image: "assets/images/pizza.png", title: "Register to Save own recipes", description: "when you register you can save own favorite recipe",
                pageNumber: 4,
                ),

              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: (){
                        controller.jumpToPage(3);
                      }, child:Text("Skip",style: Theme.of(context).textTheme.titleSmall,) ),
                      SmoothPageIndicator(controller: controller, count: 4,   effect:  ExpandingDotsEffect(),  // your preferred effect
                      ),

                      lastPage?
                      TextButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, SignIn.routeName);
                      }, child: Text("Done",style:Theme.of(context).textTheme.titleSmall,))
                          :TextButton(onPressed: (){
                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      }, child: Text("Next",style: Theme.of(context).textTheme.titleSmall,))

                    ],
                  )),
            )
          ],
        ),
      ),
    );

  }
}
