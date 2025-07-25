import 'package:curso_avancado/data/data.dart';
import 'package:curso_avancado/domain/entities/entities.dart';

class RemoteModelAccount {
  final String accessToken;
  RemoteModelAccount({
    required this.accessToken,
  });

  factory RemoteModelAccount.fromMap(Map map) {
    if (!map.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteModelAccount(
      accessToken: map['accessToken'],
    );
  }

  AccountEntity toEntity() => AccountEntity(token: accessToken);
}
