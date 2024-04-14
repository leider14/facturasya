
import 'dart:math';
import 'package:facturasya/widgets/mywdgbuttonicon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roulette/roulette.dart';

class MyPageSelectCapitan extends StatefulWidget {
  final Map participantes;
  const MyPageSelectCapitan({
    super.key,
    required this.participantes
  });

  @override
  State<MyPageSelectCapitan> createState() => _MyPageSelectCapitanState();
}

class _MyPageSelectCapitanState extends State<MyPageSelectCapitan> with TickerProviderStateMixin {

  List<RouletteUnit> ruletaElementos = [];
  late RouletteController rouletteController;

  @override
  void initState() {
    rouletteController = RouletteController(
      group: RouletteGroup(ruletaElementos),
      vsync: this,
    );
    getData();
    super.initState();
  }

  List<Color> colores = [
    Colors.blue,
    Colors.amber,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.deepOrange
  ];

  void getData(){
    int nColor = 0;
    widget.participantes.forEach((key, participante) {
      ruletaElementos.add(
        RouletteUnit(
          color: colores[nColor],
          weight: 20,
          text: participante["username"],
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          )
        ),
      );
      
      if(nColor >= colores.length){
        nColor = 0;
      }else{
        nColor++;
      }
    });
    setState(() {});
  }


  int getNumberRoulete(){
    int random =  Random().nextInt(ruletaElementos.length);
    print(random);
    return random;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),
      appBar: AppBar(
        title: const Text(
          'Seleccionar Capitan',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Text("Capitan Equipo 1 vs Capitan Equipo 2"),
              Container(
                width: MediaQuery.of(context).size.width,
                height:  MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Roulette(
                        // Provide controller to update its state
                      controller: rouletteController,
                      // Configure roulette's appearance
                      style: const RouletteStyle(
                        dividerThickness: 7,
                        dividerColor: Colors.white,
                        centerStickSizePercent: 0.15,
                        centerStickerColor: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[ Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 89, 89, 89),
                              offset: Offset(0, 5),
                              blurStyle: BlurStyle.solid
                            )
                          ]
                        ),
                      )]
                    ),
                    Center(
                      child: MyWdgButtonIcon(
                        iconData: FontAwesomeIcons.rotateRight,
                        colorButton: Colors.black,
                        size: 50,
                        onPressed: () {
                          rouletteController.rollTo(
                            getNumberRoulete(),
                            clockwise: false,
                            offset: 0.5
                          ).whenComplete(() {
                
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            
          
            ],
          ),
          
        ]
      )
    );
  }
}
