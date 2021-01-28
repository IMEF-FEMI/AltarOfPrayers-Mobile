import 'package:altar_of_prayers/database/prayer_dao.dart';
import 'package:altar_of_prayers/models/prayer.dart';

class PrayerRepository {
  PrayerDao _prayerDao = PrayerDao();

  Future<Map<String, dynamic>> getPrayer({int id}) async {
    return await _prayerDao.getPrayer(id: id);
  }

  Future<List<Map<String, dynamic>>> getPrayers() async {
    List<Map<String, dynamic>> prayers = await _prayerDao.getPrayers();
    if (prayers != null) return prayers;
    return [];
  }

  Future<int> savePrayer({Prayer prayer}) async {
    return _prayerDao.savePrayer(prayer: prayer);
  }

  Future deletePrayer({int id}) async {
    return _prayerDao.deletePrayer(id: id);
  }
}
