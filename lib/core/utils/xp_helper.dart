import 'dart:math';

class XpHelper {
  static int getXpForLevel(int level) {
    return 200 * (level * level);
  }

  static int getLevelForXp(int xp) {
    return (sqrt(xp / 200)).ceil();
  }

  static int getNextLevelXp(int level) {
    return getXpForLevel(level + 1);
  }

  static int getProgress(int xp, int level) {
    return xp - getXpForLevel(level - 1);
  }
}
