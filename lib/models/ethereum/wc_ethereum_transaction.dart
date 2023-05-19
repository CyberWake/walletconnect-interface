import 'package:equatable/equatable.dart';

class EthereumTransaction extends Equatable {
  const EthereumTransaction({
    required this.from,
    this.to,
    this.nonce,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.gasLimit,
    this.value,
    this.data,
  });

  factory EthereumTransaction.fromJson(Map<String, dynamic> json) =>
      EthereumTransaction(
        from: json['from'] as String,
        to: json['to'] as String?,
        nonce: json['nonce'] as String?,
        gasPrice: json['gasPrice'] as String?,
        maxFeePerGas: json['maxFeePerGas'] as String?,
        maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
        gas: json['gas'] as String?,
        gasLimit: json['gasLimit'] as String?,
        value: json['value'] as String?,
        data: json['data'] as String?,
      );
  final String from;
  final String? to;
  final String? nonce;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String? gas;
  final String? gasLimit;
  final String? value;
  final String? data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': from,
        'to': to,
        'nonce': nonce,
        'gasPrice': gasPrice,
        'maxFeePerGas': maxFeePerGas,
        'maxPriorityFeePerGas': maxPriorityFeePerGas,
        'gas': gas,
        'gasLimit': gasLimit,
        'value': value,
        'data': data,
      };

  @override
  List<Object?> get props => [
        from,
        to,
        nonce,
        gasPrice,
        maxFeePerGas,
        maxPriorityFeePerGas,
        gas,
        gasLimit,
        value,
        data
      ];
}
