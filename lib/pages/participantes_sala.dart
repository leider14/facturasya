import 'package:facturasya/services/functions/funtions.dart';
import 'package:facturasya/services/sala.dart';
import 'package:facturasya/widgets/mywdgbuttonicon.dart';
import 'package:facturasya/widgets/mywdgdialogconfirm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late String usuarioIniciado;
  List<dynamic> participantes = [];
  int nParticipantes = 0;
  List<Map<String, dynamic>> userDataList = [];
  late String idHost;

  @override
  void initState() {
    getHostId();
    super.initState();
  }

  Future<void> getHostId() async {
    idHost = await SalaService().getHostId(widget.codigoSala);
    usuarioIniciado =  FirebaseAuth.instance.currentUser!.uid;
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
    nParticipantes = participantes.length;
    if(!mapUnido.containsKey(usuarioIniciado)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El administrador, te ha sacado")));
      Navigator.of(context).pop();
      
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
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15
                ),
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
                        ),
                        Text(
                          "Participantes: $nParticipantes"
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
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5
        ),
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
                child:Image.network(
                  value["photoURL"],
                  fit: BoxFit.cover,
                ) ,
              ),
            ),
            
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value["username"],
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 35, 35, 35),
                    ),
                  ),
                  if(idHost == key)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber
                    ),
                    child: const Text(
                    "Creador de la sala",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 35, 35, 35),
                    ),
                  ),
                  )
                ],
              ),
            ),
            if(key == usuarioIniciado)
            MyWdgButtonIcon(
              iconData: FontAwesomeIcons.pencil,
              colorButton: Colors.blue,
              onPressed: () {
                //TODO agregar la funcion para cambiar imagen
              },
            ),
            if(idHost == usuarioIniciado)
            const SizedBox(width: 5,),
            if(idHost == usuarioIniciado)
            MyWdgButtonIcon(
              iconData: FontAwesomeIcons.xmark,
              colorButton: const Color.fromARGB(255, 211, 72, 72),
              onPressed: () {
                myWdgDialogConfirm(
                  context: context,
                  title: "Eliminar Usuario",
                  content: "¿Está seguro de eliminar a ${value['username']} de la sala?",
                  onConfirmPressed: () {
                    SalaService().removeFromRoom(widget.codigoSala, key);
                  },
                );
              },
            )
            
          ],
        ),
      ));
    });
    participantes = participantes;


    return Expanded(
      child: SingleChildScrollView(
        padding:const EdgeInsets.only(top: 5),
        child: Column(
          children: participantes,
        ),
      ),
    );

  }

}
