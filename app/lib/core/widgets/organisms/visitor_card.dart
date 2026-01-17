import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/visitor.dart';

class VisitorCard extends StatelessWidget {
  final Visitor visitor;

  const VisitorCard({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.accentMint,
          child: Icon(Icons.directions_car, color: Colors.black),
        ),
        title: Text(visitor.carNumber, style: const TextStyle(fontFamily: 'Paperlogy', fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${visitor.visitorName ?? "방문객"} | ${visitor.visitDate}',
          style: const TextStyle(fontFamily: 'Paperlogy', color: Colors.white70),
        ),
        trailing: Chip(
          label: Text(visitor.status, style: const TextStyle(fontFamily: 'Paperlogy', fontSize: 12)),
          backgroundColor: visitor.status == 'APPROVED' 
              ? Colors.green.withOpacity(0.2) 
              : Colors.orange.withOpacity(0.2),
          labelStyle: TextStyle(fontFamily: 'Paperlogy', 
            color: visitor.status == 'APPROVED' ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
  }
}
