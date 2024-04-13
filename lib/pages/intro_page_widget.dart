import 'package:facturasya/pages/Login_page.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgtextbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPageWidget extends StatefulWidget {
  const IntroPageWidget({Key? key}) : super(key: key);

  @override
  State<IntroPageWidget> createState() => _IntroPageWidgetState();
}

class _IntroPageWidgetState extends State<IntroPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Future.delayed(const Duration(milliseconds: 1000), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            // Pages
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.0,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  _buildPage(
                    'Organiza tus Equipos',
                    'Asigna jugadores a equipos de forma aleatoria y equitativa para prepararte para emocionantes partidos con tus amigos.',
                    'assets/images/welcome_splash_1.jpg',
                  ),
                  _buildPage(
                    'Consultar Estadísticas',
                    'Accede a estadísticas detalladas de tus partidos, incluyendo goles, asistencias y más, para analizar el desempeño de tu equipo y mejorar tu estrategia.',
                    'assets/images/welcome_splash_2.jpg',
                  ),
                  _buildPage(
                    'Jugar Partidos Aleatorios',
                    'Genera encuentros emocionantes de manera aleatoria y disfruta de una experiencia de juego impredecible y divertida con tus amigos.',
                    'assets/images/welcome_splash_3.jpg',
                  ),
                ],
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyWdgButton(
                    color: Colors.blue,
                    text: "Siguiente",
                    onPressed: () {
                      nextPage();
                    },
                  ),
                  const SizedBox(height: 20,),
                  MyWdgTextButton(
                    text: 'Saltar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Page Indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  axisDirection: Axis.horizontal,
                  effect: const ExpandingDotsEffect(
                    expansionFactor: 3.0,
                    spacing: 8.0,
                    radius: 16.0,
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    dotColor: Color.fromARGB(226, 207, 202, 202),
                    activeDotColor: Colors.blue,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
