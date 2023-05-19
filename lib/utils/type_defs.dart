import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message_v1.dart';
import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message_v2.dart';
import 'package:walletconnect_interface/models/ethereum/wc_ethereum_transaction.dart';
import 'package:wc_dart_v1/wc_dart_v1.dart' as v1;
import 'package:wc_dart_v2/wallet_connect_dart_v2.dart' as v2;

typedef V1SessionRequest = void Function(
  int id,
  int chainId,
  v1.WCPeerMeta peerMeta,
  v1.WCClient client,
);

typedef V1Sign = void Function(
  int id,
  v1.WCSessionStore session,
  EthereumSignMessageV1 ethereumSignMessage,
  v1.WCClient client,
);

typedef V1EthTransaction = void Function(
  int id,
  v1.WCSessionStore session,
  EthereumTransaction transaction,
  v1.WCClient connectClient,
);

typedef V2SessionRequest = void Function(
  v2.SignClientEventParams<v2.RequestSessionPropose>,
  v2.SignClient client,
);

typedef V2Sign = void Function(
  v2.SignClientEventParams<v2.RequestSessionRequest> eventData,
  v2.SessionStruct session,
  EthereumSignMessageV2 message,
  v2.SignClient client,
);

typedef V2EthTransaction = void Function(
  v2.SignClientEventParams<v2.RequestSessionRequest> eventData,
  v2.SessionStruct session,
  EthereumTransaction transaction,
  v2.SignClient client,
);

typedef V1SwitchNetwork = void Function(
  int id,
  v1.WCSessionStore session,
  int chainId,
  v1.WCClient client,
);
