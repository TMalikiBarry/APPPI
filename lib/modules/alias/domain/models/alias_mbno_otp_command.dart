/// Alias MBO OTP Code Input Command
class AliasMbnoOtpCommand {
  //
  AliasMbnoOtpCommand(this.value);

  static const int otpSize = 4;
  List<int> value;

  bool isValid() {
    return value.length == otpSize;
  }
}
