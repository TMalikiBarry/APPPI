/// Pin Input Command
class PinCommand {
  //
  PinCommand(this.value);

  static const int pinSize = 4;
  List<int> value;

  bool isValid() {
    return value.length == pinSize;
  }
}
