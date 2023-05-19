/// Interface.
library walletconnect_interface;

import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message_v1.dart';
import 'package:walletconnect_interface/models/ethereum/ethereum_sign_message_v2.dart';
import 'package:walletconnect_interface/models/ethereum/wc_ethereum_transaction.dart';
import 'package:walletconnect_interface/models/wallet_meta_data.dart';
import 'package:walletconnect_interface/utils/enums.dart';
import 'package:walletconnect_interface/utils/type_defs.dart';
import 'package:wc_dart_v1/wc_dart_v1.dart' as v1;
import 'package:wc_dart_v2/wallet_connect_dart_v2.dart' as v2;
import 'package:wc_dart_v2/wc_utils/jsonrpc/utils/extensions.dart';
import 'package:wc_dart_v2/wc_utils/misc/logger/logger.dart';

class WCInterface {
  WCInterface._({
    required ApplicationMeta applicationMeta,
    required String projectId,
    required v2.SignClient v2Client,
    required V1SessionRequest onV1sessionRequest,
    required V2SessionRequest onV2sessionRequest,
    required V1Sign onV1PersonalSign,
    required V2Sign onV2PersonalSign,
    required V1Sign onV1EthSign,
    required V2Sign onV2EthSign,
    required V1Sign onV1EthSignTypedData,
    required V2Sign onV2EthSignTypedData,
    required V2Sign onV2EthSignTypedDataV3,
    required V2Sign onV2EthSignTypedDataV4,
    required V1EthTransaction onV1EthSignTransaction,
    required V2EthTransaction onV2EthSignTransaction,
    required V1EthTransaction onV1EthSendTransaction,
    required V2EthTransaction onV2EthSendTransaction,
    required V1SwitchNetwork onV1SwitchNetwork,
  }) {
    _applicationMeta = applicationMeta;
    _projectId = projectId;
    _v2Client = v2Client;
    _v1Client = v1.WalletConnectV1(
      peerMeta: v1.WCPeerMeta.fromJson(applicationMeta.toJson()),
      onSessionClosed:
          (int? code, String? reason, String? key, v1.WalletClientInfo info) {},
      onSessionError: (dynamic message) {},
      onSessionRequest: onV1sessionRequest,
      onSignRequest: (id, wcSession, wcEthereumSignMessage, wcClient) {
        final message = EthereumSignMessageV1(
          raw: wcEthereumSignMessage.raw,
          type: SignType.values[wcEthereumSignMessage.type.index],
        );
        switch (message.type) {
          case SignType.message:
            onV1EthSign.call(id, wcSession, message, wcClient);
            break;
          case SignType.personalMessage:
            onV1PersonalSign.call(id, wcSession, message, wcClient);
            break;
          case SignType.typedMessage:
            onV1EthSignTypedData.call(id, wcSession, message, wcClient);
            break;
          case SignType.typedMessageV1:
            throw UnimplementedError();
          case SignType.typedMessageV3:
            throw UnimplementedError();
          case SignType.typedMessageV4:
            throw UnimplementedError();
        }
      },
      onSendTransaction: (id, wcSession, wcTransaction, wcClient) {
        final transaction =
            EthereumTransaction.fromJson(wcTransaction.toJson());
        onV1EthSendTransaction.call(id, wcSession, transaction, wcClient);
      },
      onSignTransaction: (id, wcSession, wcTransaction, wcClient) {
        final transaction =
            EthereumTransaction.fromJson(wcTransaction.toJson());
        onV1EthSignTransaction.call(id, wcSession, transaction, wcClient);
      },
      onSwitchNetwork: onV1SwitchNetwork,
    );
    _v2Client
      ..on(v2.SignClientEvent.SESSION_PROPOSAL.value, (data) {
        if (data != null) {
          final eventData =
              data as v2.SignClientEventParams<v2.RequestSessionPropose>;
          onV2sessionRequest(eventData, _v2Client);
        }
      })
      ..on(v2.SignClientEvent.SESSION_REQUEST.value, (data) {
        if (data != null) {
          final eventData =
              data as v2.SignClientEventParams<v2.RequestSessionRequest>;
          final session = _v2Client.session.get(eventData.topic!);
          switch (eventData.params!.request.method.toEip155Method()) {
            case v2.Eip155Methods.personalSign:
              final requestParams =
                  (eventData.params!.request.params as List).cast<String>();
              final dataToSign = requestParams[1];
              final address = requestParams[0];
              final message = EthereumSignMessageV2(
                data: dataToSign,
                address: address,
                type: SignType.personalMessage,
              );
              onV2PersonalSign.call(eventData, session, message, _v2Client);
              break;
            case v2.Eip155Methods.ethSign:
              final requestParams =
                  (eventData.params!.request.params as List).cast<String>();
              final dataToSign = requestParams[1];
              final address = requestParams[0];
              final message = EthereumSignMessageV2(
                data: dataToSign,
                address: address,
                type: SignType.message,
              );
              onV2EthSign.call(eventData, session, message, _v2Client);
              break;
            case v2.Eip155Methods.ethSignTypedData:
              final requestParams =
                  (eventData.params!.request.params as List).cast<String>();
              final dataToSign = requestParams[1];
              final address = requestParams[0];
              final message = EthereumSignMessageV2(
                data: dataToSign,
                address: address,
                type: SignType.typedMessageV1,
              );
              onV2EthSignTypedData.call(eventData, session, message, _v2Client);
              break;
            case v2.Eip155Methods.ethSignTypedDataV3:
              final requestParams =
                  (eventData.params!.request.params as List).cast<String>();
              final dataToSign = requestParams[1];
              final address = requestParams[0];
              final message = EthereumSignMessageV2(
                data: dataToSign,
                address: address,
                type: SignType.typedMessageV3,
              );
              onV2EthSignTypedDataV3.call(
                eventData,
                session,
                message,
                _v2Client,
              );
              break;
            case v2.Eip155Methods.ethSignTypedDataV4:
              final requestParams =
                  (eventData.params!.request.params as List).cast<String>();
              final dataToSign = requestParams[1];
              final address = requestParams[0];
              final message = EthereumSignMessageV2(
                data: dataToSign,
                address: address,
                type: SignType.typedMessageV4,
              );
              onV2EthSignTypedDataV4.call(
                eventData,
                session,
                message,
                _v2Client,
              );
              break;
            case v2.Eip155Methods.ethSignTransaction:
              final tx = EthereumTransaction.fromJson(
                (eventData.params!.request.params as List).first
                    as Map<String, dynamic>,
              );
              onV2EthSignTransaction.call(eventData, session, tx, _v2Client);
              break;
            case v2.Eip155Methods.ethSendRawTransaction:
              throw UnimplementedError();
            case v2.Eip155Methods.ethSendTransaction:
              final tx = EthereumTransaction.fromJson(
                (eventData.params!.request.params as List).first
                    as Map<String, dynamic>,
              );
              return onV2EthSendTransaction.call(
                eventData,
                session,
                tx,
                _v2Client,
              );
            case v2.Eip155Methods.walletSwitchEthereumChain:
              throw UnimplementedError();
            case null:
              throw UnimplementedError();
          }
        }
      });
  }

  late final ApplicationMeta _applicationMeta;
  late final v1.WalletConnectV1 _v1Client;
  late final v2.SignClient _v2Client;
  late final String _projectId;

  ApplicationMeta get applicationMeta => _applicationMeta;
  v1.WalletConnectV1 get v1Client => _v1Client;
  v2.SignClient get v2Client => _v2Client;
  String get projectId => _projectId;

  static Future<WCInterface> init({
    required ApplicationMeta applicationMeta,
    required String projectId,
    required V1SessionRequest onV1sessionRequest,
    required V2SessionRequest onV2sessionRequest,
    required V1Sign onV1PersonalSign,
    required V2Sign onV2PersonalSign,
    required V1Sign onV1EthSign,
    required V2Sign onV2EthSign,
    required V1Sign onV1EthSignTypedData,
    required V2Sign onV2EthSignTypedData,
    required V2Sign onV2EthSignTypedDataV3,
    required V2Sign onV2EthSignTypedDataV4,
    required V1EthTransaction onV1EthSignTransaction,
    required V2EthTransaction onV2EthSignTransaction,
    required V1EthTransaction onV1EthSendTransaction,
    required V2EthTransaction onV2EthSendTransaction,
    required V1SwitchNetwork onV1SwitchNetwork,
    String? relayUrl,
    String? database,
    Logger? logger,
  }) async {
    return WCInterface._(
      applicationMeta: applicationMeta,
      projectId: projectId,
      onV1sessionRequest: onV1sessionRequest,
      onV1EthSign: onV1EthSign,
      onV1PersonalSign: onV1PersonalSign,
      onV1EthSignTransaction: onV1EthSignTransaction,
      onV1EthSendTransaction: onV1EthSendTransaction,
      onV1EthSignTypedData: onV1EthSignTypedData,
      onV2sessionRequest: onV2sessionRequest,
      onV2EthSign: onV2EthSign,
      onV2PersonalSign: onV2PersonalSign,
      onV2EthSignTransaction: onV2EthSignTransaction,
      onV2EthSendTransaction: onV2EthSendTransaction,
      onV2EthSignTypedData: onV2EthSignTypedData,
      onV2EthSignTypedDataV3: onV2EthSignTypedDataV3,
      onV2EthSignTypedDataV4: onV2EthSignTypedDataV4,
      onV1SwitchNetwork: onV1SwitchNetwork,
      v2Client: await v2.SignClient.init(
        projectId: projectId,
        relayUrl: relayUrl,
        metadata: v2.AppMetadata(
          name: applicationMeta.name,
          description: applicationMeta.description,
          url: applicationMeta.url,
          icons: applicationMeta.icons,
        ),
        database: database,
        logger: logger,
      ),
    );
  }

  Future<bool> connectWithUri(String uriString) async {
    try {
      final uri = Uri.parse(uriString);
      if (uri.queryParameters.containsKey('key')) {
        await v1Client.connectWithUri(uriString);
      } else {
        await v2Client.pair(uriString);
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
