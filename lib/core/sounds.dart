import 'package:audioplayers/audioplayers.dart';

class SoundItem {
  final String name;
  final String path;

  const SoundItem({required this.name, required this.path});
}

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static final List<SoundItem> liste = const [
    SoundItem(name: "Aurora", path: "sounds/aurora.mp3"),
    SoundItem(name: "Bamboo", path: "sounds/bamboo.mp3"),
    SoundItem(name: "Chord", path: "sounds/chord.mp3"),
    SoundItem(name: "Circles", path: "sounds/circles.mp3"),
    SoundItem(name: "Complete", path: "sounds/complete.mp3"),
    SoundItem(name: "Hello", path: "sounds/hello.mp3"),
    SoundItem(name: "Keys", path: "sounds/keys.mp3"),
    SoundItem(name: "Note", path: "sounds/note.mp3"),
    SoundItem(name: "Popcorn", path: "sounds/popcorn.mp3"),
  ];

  static String nameFromPath(String path) {
    return liste.firstWhere((element) => element.path == path).name;
  }

  static Future<void> playSound(String soundPath) async {
    await _audioPlayer.setSource(AssetSource(soundPath));
    await _audioPlayer.resume();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
