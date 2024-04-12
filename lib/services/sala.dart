import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SalaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> crearSala(String codigo) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    await _firestore.collection('salas').doc(codigo).set({
      'codigo': codigo,
      'Host': user!.displayName,
      'participantes': {
        {'uid': uid, 'equipo': 'no tiene', 'rol': 'jugador'}
      },
    });
  }

  Future<void> unirseASala(
    String codigoSala,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final salaDoc = _firestore.collection('salas').doc(codigoSala);
      await salaDoc.update({
        'participantes': FieldValue.arrayUnion([
          {'uid': uid, 'equipo': 'no tiene'}
        ])
      });
    }
  }

  Future<List<Map<String, dynamic>>> obtenerParticipantesSala(
      String codigoSala) async {
    final salaDoc = _firestore.collection('salas').doc(codigoSala);
    final snapshot = await salaDoc.get();

    if (snapshot.exists) {
      final participantesData = snapshot.data()?['participantes'] ?? [];

      final participantes =
          participantesData.map<Map<String, dynamic>>((participante) {
        return {
          'nombreUsuario': participante['nombreUsuario'],
          'uid': participante['uid']
        };
      }).toList();

      return Future.value(participantes);
    } else {
      return Future.value([]);
    }
  }
}
