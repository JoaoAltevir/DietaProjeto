import 'package:flutter/material.dart';
import 'package:mydiet/app/controllers/sessao_controller.dart';
import 'package:mydiet/app/pages/main_homepage.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  bool _isLoginMode = false; 

  @override
  void dispose() {
    _nomeController.dispose();
    _nomeUsuarioController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, SessionController sessionController) {
    final nome = _nomeController.text.trim();
    final pin = int.tryParse(_pinController.text) ?? 0;

    if (nome.isEmpty || _pinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    sessionController.login(nome, pin).then((success) {
      if (success) {
        // Navegar para home após sucesso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainHome()),
        );
      } else {
        // Mostrar erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sessionController.errorMessage ?? 'Erro ao fazer login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _handleRegister(BuildContext context, SessionController sessionController) {
    final nome = _nomeController.text.trim();
    final nomeUsuario = _nomeUsuarioController.text.trim();
    final pin = int.tryParse(_pinController.text) ?? 0;

    if (nome.isEmpty || nomeUsuario.isEmpty || _pinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    if (_pinController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN deve ter no mínimo 4 dígitos')),
      );
      return;
    }

    sessionController.registrar(nome, nomeUsuario, pin).then((success) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainHome()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sessionController.errorMessage ?? 'Erro ao registrar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionController, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isLoginMode ? 'Login' : 'Registrar'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: ColorScheme.fromSeed(seedColor: Theme.of(context).primaryColor)
                            .primary
                            .withValues(alpha: 0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nomeController,
                        enabled: !sessionController.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      if (!_isLoginMode) ...[
                        TextField(
                          controller: _nomeUsuarioController,
                          enabled: !sessionController.isLoading,
                          decoration: InputDecoration(
                            labelText: 'Nome de Usuário',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      TextField(
                        controller: _pinController,
                        enabled: !sessionController.isLoading,
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: sessionController.isLoading
                              ? null
                              : () {
                                  if (_isLoginMode) {
                                    _handleLogin(context, sessionController);
                                  } else {
                                    _handleRegister(context, sessionController);
                                  }
                                },
                          child: sessionController.isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_isLoginMode ? 'Entrar' : 'Registrar'),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: sessionController.isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isLoginMode = !_isLoginMode;
                                  _nomeController.clear();
                                  _nomeUsuarioController.clear();
                                  _pinController.clear();
                                });
                              },
                        child: Text(
                          _isLoginMode
                              ? 'Não tem conta? Registre-se'
                              : 'Já tem conta? Faça login',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}