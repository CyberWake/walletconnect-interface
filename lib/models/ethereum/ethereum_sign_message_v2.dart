import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message.dart';
import 'package:walletconnect_interface/utils/enums.dart';

class EthereumSignMessageV2 extends EthereumSignMessage {
  EthereumSignMessageV2({
    required this.data,
    required this.address,
    required this.type,
  });

  final String data;
  final String address;
  final SignType type;
}
