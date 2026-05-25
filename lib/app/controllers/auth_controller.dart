/// Centraliza todas as validações de formulários de autenticação.
/// Retorna `null` se válido, ou uma mensagem de erro descritiva.
class AuthValidators {
  AuthValidators._();
 
  static String? validateNome(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nome completo é obrigatório';
    if (v.length < 3) return 'Nome deve ter no mínimo 3 caracteres';
    return null;
  }
 
  static String? validateNomeUsuario(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nome de usuário é obrigatório';
    if (v.length < 3) return 'Nome de usuário deve ter no mínimo 3 caracteres';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
      return 'Apenas letras, números e underline (_)';
    }
    return null;
  }
 
  static String? validatePin(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'PIN é obrigatório';
    if (v.length < 4) return 'PIN deve ter no mínimo 4 dígitos';
    if (int.tryParse(v) == null) return 'PIN deve conter apenas números';
    return null;
  }
}