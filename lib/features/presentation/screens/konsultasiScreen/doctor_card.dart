import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool showPilihButton;
  final VoidCallback? onSelect;

  const DoctorCard({
    Key? key,
    required this.doctor,
    this.showPilihButton = true,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(width: 12),
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      doctor.experience,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_up, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      doctor.rating,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp50.000',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (showPilihButton)
                      ElevatedButton(
                        onPressed: onSelect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEC4899),
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Pilih',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
