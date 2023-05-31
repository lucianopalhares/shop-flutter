class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Email ja cadastrado', 
    'OPERATION_NOT_ALLOWED': 'Operação nao permitida', 
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Acesso bloqueado temporariamente. Tente mais tarde', 
    'EMAIL_NOT_FOUND': 'Email nao encontrado', 
    'INVALID_PASSWORD': 'Senha informada nao confere', 
    'USER_DISABLED': 'A conta do usuario foi desabilitada'
  };

  final String key; 

  AuthException(this.key);

  @override
  String toString() {
    // TODO: implement toString
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação';
  }
}