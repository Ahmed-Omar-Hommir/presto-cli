abstract class IExiter {
  Never exit(int code);
}

class Exiter implements IExiter {
  @override
  Never exit(int code) {
    exit(code);
  }
}
