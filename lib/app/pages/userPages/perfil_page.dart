import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nome = 'Deyde Lado';
  String email = 'exemplo@example.com';
  String phone = '(99) 9 9999-9999';
  String peso = '90 Kg';
  String altura = '176 Cm';

  void abrirEdicao() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EditarPerfilPage(
          nome: nome, email: email, phone: phone, peso: peso, altura: altura,
        ),
      ),
    );
    if (res != null) {
      setState(() {
        nome = res['nome'];
        email = res['email'];
        phone = res['phone'];
        peso = res['peso'];
        altura = res['altura'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Perfil'), automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(height: 16),

            CircleAvatar(
              radius: 55,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 60, color: colorScheme.onPrimaryContainer),
            ),

            Container(height: 33),

            _Campo(label: 'Name:', valor: nome),
            _Campo(label: 'Email:', valor: email),
            _Campo(label: 'Phone:', valor: phone),
            _Campo(label: 'Peso:', valor: peso),
            _Campo(label: 'Altura:', valor: altura),

            SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: abrirEdicao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF90A4AE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Editar', style: TextStyle(fontSize: 16)),
              ),
            ),

            Container(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () { // TODO: fazer o logout para trabalho 2 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Sair da conta', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarPerfilPage extends StatefulWidget {
  final String nome, email, phone, peso, altura;

  _EditarPerfilPage({required this.nome, required this.email, required this.phone, required this.peso, required this.altura});

  @override
  State<_EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<_EditarPerfilPage> {
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController peso_ctrl = TextEditingController();
  TextEditingController altura_ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtNome.text = widget.nome;
    txtEmail.text = widget.email;
    phoneController.text = widget.phone;
    peso_ctrl.text = widget.peso;
    altura_ctrl.text = widget.altura;
  }

  void salvar() {
    Navigator.pop(context, {
      'nome': txtNome.text,
      'email': txtEmail.text,
      'phone': phoneController.text,
      'peso': peso_ctrl.text,
      'altura': altura_ctrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _CampoEdicao(controller: txtNome, label: 'Nome'),
            _CampoEdicao(controller: txtEmail, label: 'Email'),
            _CampoEdicao(controller: phoneController, label: 'Phone'),
            _CampoEdicao(controller: peso_ctrl, label: 'Peso'),
            _CampoEdicao(controller: altura_ctrl, label: 'Altura'),

            Container(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF90A4AE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoEdicao extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  _CampoEdicao({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String label;
  final String valor;

  _Campo({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 15)),
          ),
          Text(valor, style: TextStyle(color: colorScheme.onSurface, fontSize: 15)),
        ],
      ),
    );
  }
}