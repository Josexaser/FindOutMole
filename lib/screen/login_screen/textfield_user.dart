import 'package:flutter/material.dart';

class TexfieldUsuarioPassw extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;

  const TexfieldUsuarioPassw({
    this.hintText = '',
    this.icon = Icons.person,
    this.obscureText = false,
    required this.controller,
    super.key,
  });

  @override
  State<TexfieldUsuarioPassw> createState() => _TexfieldUsuarioPasswState();
}

class _TexfieldUsuarioPasswState extends State<TexfieldUsuarioPassw> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        obscureText: _isObscured,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.white),
          hintText: widget.hintText,
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.4),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
