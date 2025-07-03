import 'dart:io';
import 'dart:math';

// 공통 추상 클래스
abstract class Unit {
  String name;
  int health;
  int attack;
  int defense;

  Unit(this.name, this.health, this.attack, this.defense);

  void showStatus();
}

// 캐릭터 클래스
class Character extends Unit {
  bool itemUsed = false;

  Character(String name, int health, int attack, int defense)
    : super(name, health, attack, defense);

  void attackMonster(Monster monster, {bool usingItem = false}) {
    int damage = usingItem ? attack * 2 : attack;
    int actualDamage = max(damage - monster.defense, 0);
    monster.health -= actualDamage;
    print('$name이(가) ${monster.name}에게 $actualDamage의 피해를 입혔습니다.');
  }

  void defend(int damage) {
    health += damage;
    print('$name이(가) 방어하여 체력이 $damage 만큼 회복되었습니다.');
  }

  void showStatus() {
    print('👤 $name | 체력: $health | 공격력: $attack | 방어력: $defense');
  }
}

// 몬스터 클래스
class Monster extends Unit {
  static final _random = Random();
  int turnCounter = 0;

  Monster(String name, int health, int maxAttack) : super(name, health, 0, 0) {
    attack = max(_random.nextInt(maxAttack) + 1, 1);
  }

  void attackCharacter(Character character) {
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage의 피해를 입혔습니다.');
  }

  void increaseDefenseIfNeeded() {
    turnCounter++;
    if (turnCounter % 3 == 0) {
      defense += 2;
      print('🛡️ $name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }

  void showStatus() {
    print('👹 $name | 체력: $health | 공격력: $attack | 방어력: $defense');
  }
}

// 게임 클래스
class Game {
  late Character character;
  List<Monster> monsters = [];
  int defeatedCount = 0;
  final _random = Random();

  void startGame() {
    loadCharacter();
    applyBonusHealth();
    loadMonsters();

    print('🎮 게임을 시작합니다!');
    while (character.health > 0 && monsters.isNotEmpty) {
      Monster monster = getRandomMonster();
      battle(monster);

      if (character.health <= 0) {
        print('\n💀 당신은 사망했습니다. 게임 오버!');
        saveResult('패배');
        return;
      }

      defeatedCount++;
      if (monsters.isEmpty) {
        print('\n🏆 모든 몬스터를 물리쳤습니다! 게임 승리!');
        saveResult('승리');
        return;
      }

      stdout.write('\n다음 몬스터와 대결하시겠습니까? (y/n): ');
      String? input = stdin.readLineSync();
      if (input?.toLowerCase() != 'y') {
        print('👋 게임을 종료합니다.');
        saveResult('중도 종료');
        return;
      }
    }
  }

  void battle(Monster monster) {
    print('\n🧟 전투 시작! 상대는 ${monster.name}입니다!');
    while (character.health > 0 && monster.health > 0) {
      character.showStatus();
      monster.showStatus();

      stdout.write('\n행동 선택 - 1: 공격, 2: 방어, 3: 아이템 사용 ▶ ');
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          character.attackMonster(monster);
          break;
        case '2':
          monster.attackCharacter(character);
          character.defend(monster.attack);
          continue; // 턴 소비 안 함
        case '3':
          if (!character.itemUsed) {
            character.itemUsed = true;
            print('💥 아이템 사용! 이번 공격은 2배 데미지입니다.');
            character.attackMonster(monster, usingItem: true);
          } else {
            print('⚠️ 이미 아이템을 사용했습니다.');
            continue;
          }
          break;
        default:
          print('⚠️ 잘못된 입력입니다.');
          continue;
      }

      if (monster.health > 0) {
        monster.increaseDefenseIfNeeded();
        monster.attackCharacter(character);
      }
    }

    if (monster.health <= 0) {
      print('🎉 ${monster.name}을(를) 물리쳤습니다!');
      monsters.remove(monster);
    }
  }

  Monster getRandomMonster() {
    return monsters[_random.nextInt(monsters.length)];
  }

  void loadCharacter() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid format');
      stdout.write('캐릭터 이름을 입력하세요: ');
      String? name = stdin.readLineSync();

      while (name == null ||
          name.isEmpty ||
          !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
        stdout.write('❌ 올바른 이름을 다시 입력하세요: ');
        name = stdin.readLineSync();
      }

      int hp = int.parse(stats[0]);
      int atk = int.parse(stats[1]);
      int def = int.parse(stats[2]);

      character = Character(name, hp, atk, def);
    } catch (e) {
      print('⚠️ 캐릭터 로딩 실패: $e');
      exit(1);
    }
  }

  void loadMonsters() {
    try {
      final file = File('monsters.txt');
      final lines = file.readAsLinesSync();
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length != 3) continue;
        monsters.add(
          Monster(parts[0], int.parse(parts[1]), int.parse(parts[2])),
        );
      }
    } catch (e) {
      print('⚠️ 몬스터 로딩 실패: $e');
      exit(1);
    }
  }

  void applyBonusHealth() {
    if (_random.nextInt(100) < 30) {
      character.health += 10;
      print('💖 보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  void saveResult(String result) {
    stdout.write('\n결과를 저장하시겠습니까? (y/n): ');
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'y') {
      final resultFile = File('result.txt');
      final content =
          '이름: ${character.name}, 남은 체력: ${character.health}, 결과: $result\n';
      resultFile.writeAsStringSync(content, mode: FileMode.append);
      print('📄 결과가 저장되었습니다.');
    }
  }
}

void main() {
  Game game = Game();
  game.startGame();
}
