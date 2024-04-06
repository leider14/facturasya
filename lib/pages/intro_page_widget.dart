import 'package:facturasya/pages/Login_page.dart';
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
                    'Planifica tu facturación',
                    'Al planificar la facturación electrónica, es importante considerar varios factores clave: proveedor, presupuesto, frecuencia y características específicas.',
                    'assets/images/Facturacion_01.png',
                  ),
                  _buildPage(
                    'Comienza la gestión',
                    'El inicio de la gestión de facturación electrónica marca el comienzo de una nueva era en la organización y eficiencia de tus procesos financieros.',
                    'assets/images/Facturacion_02.png',
                  ),
                  _buildPage(
                    'Disfruta de tus registros',
                    'La facturación electrónica simplifica tus registros financieros y te permite disfrutar de una mayor precisión y rapidez en tus transacciones comerciales.',
                    'assets/images/Facturacion_03.png',
                  ),
                ],
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: nextPage,
                    child: Text('Siguiente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Saltar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 250),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
