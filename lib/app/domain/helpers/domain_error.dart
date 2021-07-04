enum DomainError {
  unexpected,
  invalidCredentials
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials: return 'Credenciais inválidas.';
      case DomainError.unexpected: return 'Algo errado aconteceu. Tente novamente em breve.';
      default: return '';
    }
  }
}