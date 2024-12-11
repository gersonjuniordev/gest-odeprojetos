import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

class SyncService {
  final Box offlineBox;
  
  SyncService(this.offlineBox);

  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> salvarOffline(String key, Map<String, dynamic> data) async {
    await offlineBox.put(key, data);
  }

  Future<void> sincronizarDados() async {
    if (await isOnline()) {
      // Sincronizar dados offline com Firebase
      final dados = offlineBox.values.toList();
      for (var dado in dados) {
        // Implementar lógica de sincronização com Firebase
      }
      await offlineBox.clear();
    }
  }
} 