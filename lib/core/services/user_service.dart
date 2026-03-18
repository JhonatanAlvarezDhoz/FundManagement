import 'package:fund_management/core/services/local_storage_service.dart';
import 'package:fund_management/core/services/storege_keys.dart';

class UserEntity {
  final String id;
  final String name;
  final double balance;

  const UserEntity({
    required this.id,
    required this.name,
    required this.balance,
  });

  UserEntity copyWith({double? balance}) {
    return UserEntity(id: id, name: name, balance: balance ?? this.balance);
  }
}

class UserService {
  final LocalStorageService storage;

  UserService({required this.storage});

  Future<UserEntity> getOrCreateUser() async {
    final data = await storage.read(StorageKeys.user);

    if (data != null) {
      return UserEntity(
        id: data['id'],
        name: data['name'],
        balance: data['balance'],
      );
    }

    // Usuario fake inicial
    final user = UserEntity(id: '1', name: 'BTG User', balance: 500000);

    await storage.save(StorageKeys.user, {
      'id': user.id,
      'name': user.name,
      'balance': user.balance,
    });

    return user;
  }
}
