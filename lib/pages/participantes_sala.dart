import 'package:facturasya/pages/page_capitan_select.dart';
import 'package:facturasya/services/functions/funtions.dart';
import 'package:facturasya/services/sala.dart';
import 'package:facturasya/shimmers/myshplayerroom.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgbuttonicon.dart';
import 'package:facturasya/widgets/mywdgdialogconfirm.dart';
import 'package:facturasya/widgets/mywdgdialogloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ParticipantesSala extends StatefulWidget {
  final String codigoSala;
  const ParticipantesSala({super.key, required this.codigoSala});

  @override
  State<ParticipantesSala> createState() => _ParticipantesSalaState();
}

class _ParticipantesSalaState extends State<ParticipantesSala>  with TickerProviderStateMixin {
   String usuarioIniciado = "";
  List<dynamic> participantes = [];
  int nParticipantes = 0;
  List<Map<String, dynamic>> userDataList = [];
  String idHost = "";
  late AnimationController animationController;
  bool showButtonNext = false;

  @override
  void initState() {
    getHostId();
    super.initState();
  }
  
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  Future<void> getHostId() async {
    idHost = await SalaService().getHostId(widget.codigoSala);
    usuarioIniciado =  FirebaseAuth.instance.currentUser!.uid;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );
  }

  Future<Map> getDataUsers() async {
    Map mapUnido = {};
    List participantes =
        await SalaService().obtenerParticipantesSala(widget.codigoSala);
    for (var participante in participantes) {
      Map dataCompletaUsuario = {};
      Map dataUsuario = await getUserFromFirebase(participante['uid']);
      dataCompletaUsuario.addAll(dataUsuario);
      dataCompletaUsuario.addAll(participante);
      mapUnido.addAll({dataCompletaUsuario['uid']: dataCompletaUsuario});
    }
    nParticipantes = participantes.length;
    if (!mapUnido.containsKey(usuarioIniciado)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El administrador, te ha sacado")));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    showButtonNext = (idHost.isNotEmpty && nParticipantes > 2 && idHost == usuarioIniciado ); 
    setState(() {});

    return mapUnido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),
      appBar: AppBar(
        title: const Text(
          'Ver Participantes',
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
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImageView(size: 120, data: widget.codigoSala),
                    const SizedBox(
                      width: 20,
                    ),
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
                            color: Color.fromARGB(255, 35, 35, 35),
                          ),
                        ),
                        Text(
                          widget.codigoSala.toString(),
                          textScaler: const TextScaler.linear(4),
                          style: const TextStyle(
                            height: 0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 35, 35, 35),
                          ),
                        ),
                        Text(
                          "Participantes: $nParticipantes",
                          textScaler: const TextScaler.linear(1.3),
                          style: const TextStyle(
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
                    return const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          MyShPlayerRoom(),
                          MyShPlayerRoom(),
                          MyShPlayerRoom(),
                          MyShPlayerRoom()
                        ],
                      ),
                    );
                  }else{
                    Map data = snapshot.data!;
                    animationController.forward();
                    return  myWdgListParticipantes(data);
                  }
                },
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            bottom: showButtonNext ? 1 : -200,
            child:  Container(
              padding:const EdgeInsets.all(10),
              height: 80,
              width: MediaQuery.of(context).size.width,
              child:  MyWdgButton(
                text: "Iniciar el juego",
                color: Colors.green,
                onPressed: () async {
                  Map datos = await getDataUsers().whenComplete(() { });
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return MyPageSelectCapitan(
                          participantes: datos,
                        );
                      },)
                    );
                  
                },
              ),
                
              
            ),
            
          )
        ],
      ),
    );
  }

  Widget myWdgListParticipantes(Map data) {
    List<Widget> participantes = [];
    data.forEach((key, value) {
      participantes.add(
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
          ),
          child: Container(
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
                    onConfirmPressed: () async {
                      myWdgDialogLoading(context: context);
                      await SalaService().removeFromRoom(widget.codigoSala, key).whenComplete(() {
                         Navigator.of(context).pop();
                         Navigator.of(context).pop();
                      });
                     
                    },
                  );
                },
              )
              
            ],
          ),
          ),
        ));
    });

    return Expanded(
      child: SingleChildScrollView(
        padding:const EdgeInsets.only(
          top: 5,
          bottom: 150
        ),
        child: Column(
          children: participantes,
        ),
      ),
    );
  }
}
