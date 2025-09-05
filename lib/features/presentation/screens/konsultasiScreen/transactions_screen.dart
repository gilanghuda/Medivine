import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_doctor.dart';
import '../../../../../features/data/datasources/doctor_service.dart';
import '../../../../../features/data/repositories/doctor_repository_impl.dart';
import '../../provider/auth_provider.dart';

class TransactionDoctorScreen extends StatefulWidget {
  final String doctorId;
  final bool isAnonymous;
  const TransactionDoctorScreen({
    Key? key,
    required this.doctorId,
    this.isAnonymous = false,
  }) : super(key: key);

  @override
  State<TransactionDoctorScreen> createState() =>
      _TransactionDoctorScreenState();
}

class _TransactionDoctorScreenState extends State<TransactionDoctorScreen> {
  String? selectedPaymentMethod;
  late Future<Doctor?> doctorFuture;

  @override
  void initState() {
    super.initState();
    doctorFuture = _fetchDoctor(widget.doctorId);
  }

  Future<Doctor?> _fetchDoctor(String doctorId) async {
    final getDoctorUsecase = GetDoctor(DoctorRepositoryImpl(DoctorService()));
    final List<Doctor> doctors = await getDoctorUsecase();
    try {
      // Cari berdasarkan id, bukan name
      return doctors.firstWhere((d) => d.id == doctorId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser?.role == 'doctor') {
      Future.microtask(() => context.go('/list-chat'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Transaksi Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<Doctor?>(
            future: doctorFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final doctor = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Card
                  doctor == null
                      ? Text('Dokter tidak ditemukan')
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A95),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFFFF8A95),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    doctor.specialty,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Pembayaran',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biaya Konsultasi',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '50.000',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biaya Platform',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '5.000',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(color: Color(0xFFFF8A95), thickness: 1),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '55.000',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF4757),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Methods
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // E-Wallet Section
                  const Text(
                    'E-Wallet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    'GoPay',
                    'gopay',
                    'Instant Payment',
                    Icons.circle,
                    const Color(0xFF00D4AA),
                  ),

                  const SizedBox(height: 8),

                  _buildPaymentOption(
                    'Ovo',
                    'ovo',
                    'Instant Payment',
                    Icons.circle,
                    const Color(0xFF5D4FB3),
                  ),

                  const SizedBox(height: 16),

                  // Bank Transfer Section
                  const Text(
                    'Transfer Bank',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    'Bank BCA',
                    'bca',
                    'Virtual Account',
                    Icons.account_balance,
                    const Color(0xFF0066CC),
                  ),

                  const SizedBox(height: 8),

                  _buildPaymentOption(
                    'Bank Mandiri',
                    'mandiri',
                    'Virtual Account',
                    Icons.account_balance,
                    const Color(0xFFFFB81C),
                  ),

                  const SizedBox(height: 8),

                  _buildPaymentOption(
                    'Bank BNI',
                    'bni',
                    'Virtual Account',
                    Icons.account_balance,
                    const Color(0xFFFF7A00),
                  ),

                  const SizedBox(height: 16),

                  // Credit/Debit Card Section
                  const Text(
                    'Kartu Kredit/Debit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    'Kartu Kredit/Debit',
                    'card',
                    'Visa, Mastercard',
                    Icons.credit_card,
                    const Color(0xFF1A1F71),
                  ),

                  // SPACER DIHAPUS DAN DIGANTI DENGAN SIZEDBOX
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            if (doctor != null) {
                              context.push(
                                '/chat-screen/${doctor.id}',
                                extra: {'isAnonymous': widget.isAnonymous},
                              );
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: selectedPaymentMethod != null
                                  ? const Color(0xFFFF4757)
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Lanjut Konsultasi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    bool isSelected = selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF00D4AA) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00D4AA)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Color(0xFF00D4AA),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
