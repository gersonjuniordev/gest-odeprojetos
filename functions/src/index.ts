import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const enviarNotificacao = functions.firestore
  .document('notificacoes/{notificacaoId}')
  .onCreate(async (snap, context) => {
    const notificacao = snap.data();
    const { token, titulo, corpo } = notificacao;

    const message = {
      notification: {
        title: titulo,
        body: corpo,
      },
      token: token,
    };

    try {
      await admin.messaging().send(message);
      await snap.ref.update({ enviada: true });
    } catch (error) {
      console.error('Erro ao enviar notificação:', error);
      await snap.ref.update({ erro: error.message });
    }
  }); 