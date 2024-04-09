import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SalaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<void> crearSala(String codigo) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    // Crear un documento para la sala
    await _firestore.collection('salas').doc(codigo).set({
      'codigo': codigo,
      'Host': user!.displayName,
      
      'participantes': {{'uid': uid, 'nombreUsuario': user.displayName,'equipo':'no tiene','rol':'jugador'}},
    });
  }

  Future<void> unirseASala(String codigoSala,) async {
    // Obtener el UID del usuario actual
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    // Si el usuario está autenticado
    if (uid != null) {
      // Agregar el usuario a la lista de participantes
      final salaDoc = _firestore.collection('salas').doc(codigoSala);
      await salaDoc.update({
        'participantes': FieldValue.arrayUnion([{'uid': uid, 'nombreUsuario': user!.displayName,'equipo':'no tiene'}])
      });
    }
  }

  Future<List<dynamic>> obtenerParticipantesSala(String codigoSala) async {
    // Obtener el documento de la sala
    final salaDoc = _firestore.collection('salas').doc(codigoSala);
    final snapshot = await salaDoc.get();

    // Si la sala existe
    if (snapshot.exists) {
      
      final participantesData = snapshot.data()?['participantes'] ?? [];
      final nombresUsuario = participantesData.map((participante) => participante['nombreUsuario']).toList();
      return nombresUsuario;
    } else {
      return [];
    }
  }
}
