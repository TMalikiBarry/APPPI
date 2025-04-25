/// Alias MBO OTP Code Input Command
class AliasMbnoOtpCommand {
  //
  AliasMbnoOtpCommand(this.value);

  static const int otpSize = 6;
  List<int> value;

  bool isValid() {
    return value.length == otpSize;
  }
}
