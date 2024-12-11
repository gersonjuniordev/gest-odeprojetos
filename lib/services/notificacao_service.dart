import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacaoService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> inicializar() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    
    if (token != null) {
      await _salvarToken(token);
    }

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _salvarToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .update({'fcmToken': token});
    }
  }

  void _handleMessage(RemoteMessage message) {
    // Implementar lógica de exibição de notificação
    print('Mensagem recebida: ${message.notification?.title}');
  }

  Future<void> enviarNotificacao({
    required String usuarioId,
    required String titulo,
    required String corpo,
  }) async {
    final usuario = await _firestore
        .collection('usuarios')
        .doc(usuarioId)
        .get();
    
    final token = usuario.data()?['fcmToken'];
    if (token == null) return;

    // Enviar notificação usando Cloud Functions ou serviço de notificação
    await _firestore.collection('notificacoes').add({
      'para': usuarioId,
      'titulo': titulo,
      'corpo': corpo,
      'token': token,
      'lida': false,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }
} 