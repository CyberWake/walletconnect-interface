import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message.dart';
import 'package:walletconnect_interface/utils/enums.dart';

class EthereumSignMessageV1 extends EthereumSignMessage {
  EthereumSignMessageV1({
    required this.raw,
    required this.type,
  });
  final List<String> raw;
  final SignType type;

  String get data {
    switch (type) {
      case SignType.message:
        return raw[1];
      case SignType.typedMessage:
        return raw[1];
      case SignType.personalMessage:
        return raw[0];
      case SignType.typedMessageV1:
        throw UnimplementedError();
      case SignType.typedMessageV3:
        throw UnimplementedError();
      case SignType.typedMessageV4:
        throw UnimplementedError();
    }
  }
}
