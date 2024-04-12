import 'package:facturasya/services/functions/funtions.dart';
import 'package:facturasya/services/sala.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ParticipantesSala extends StatefulWidget {
  final String codigoSala;

  const ParticipantesSala(
    {Key? key,
    required this.codigoSala
  })
      : super(key: key);

  @override
  _ParticipantesSalaState createState() => _ParticipantesSalaState();
}

class _ParticipantesSalaState extends State<ParticipantesSala> {
  List<dynamic> participantes = [];
  List<Map<String, dynamic>> userDataList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Map> getDataUsers() async{
    Map mapUnido = {};
    List participantes = await SalaService().obtenerParticipantesSala(widget.codigoSala);
    for (var participante in participantes) {
      Map dataCompletaUsuario = {};
      Map dataUsuario = await getUserFromFirebase(participante['uid']);
      dataCompletaUsuario.addAll(dataUsuario);
      dataCompletaUsuario.addAll(participante);
      mapUnido.addAll({
        dataCompletaUsuario['uid']: dataCompletaUsuario
      });
    }
    setState(() {});
    return mapUnido;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),
      appBar: AppBar(
        title: const Text('Ver Participantes'),
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
              Container(
                margin: EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImageView(
                      size: 120,
                      data: widget.codigoSala
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Pin de juego:",
                          textScaler: TextScaler.linear(1.3),
                          style: TextStyle(
                            height: 0,
                            fontWeight: FontWeight.bold,
                            color:  Color.fromARGB(255, 35, 35, 35),
                          ),
                        ),
                        Text(
                          widget.codigoSala.toString(),
                          textScaler: const TextScaler.linear(4),
                          
                          style:const  TextStyle(
                            height: 0,
                            fontWeight: FontWeight.bold,
                            color:  Color.fromARGB(255, 35, 35, 35),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: getDataUsers(),
                builder:(context, snapshot) {
                  if(!snapshot.hasData){
                    return Text(snapshot.data.toString());
                  }else{
                    Map data = snapshot.data!;
                    return  myWdgListParticipantes(data);
                  }
                },
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  Widget myWdgListParticipantes(Map data){
    List<Widget> participantes = [];
    data.forEach((key, value) {
      participantes.add(Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Colors.purple,
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color:Colors.purple.withAlpha(150),
                    offset:const Offset(0, 5)
                  )
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child:Image.network(value["photoURL"]) ,
              ),
            ),
            
            const SizedBox(width: 10,),
            Column(
              children: [
                Text(
                  value["username"],
                  textScaler: const TextScaler.linear(1.2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 35, 35, 35),
                  ),
                ),
                Text(
                  value["username"],
                  textScaler: const TextScaler.linear(1.2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 35, 35, 35),
                  ),
                ),
                
              ],
            )
            
          ],
        ),
      ));
    });


    return Column(
      children: participantes,
    );

  }

}
