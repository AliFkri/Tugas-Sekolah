import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormProdukPage extends StatefulWidget {
  const FormProdukPage({super.key});

  @override
  State<FormProdukPage> createState() => _FormProdukPageState();
}

class _FormProdukPageState extends State<FormProdukPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final _namaProdukController = TextEditingController();
  final _hargaController = TextEditingController();
  
  // Selected category
  String? _kategoriTerpilih;
  
  // Available categories
  final List<String> _kategoriList = ['Makanan', 'Minuman', 'Snack', 'Lainnya'];

  // Method to format currency
  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return 'Rp ${number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Method to handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Create product data object
      final productData = {
        'nama': _namaProdukController.text,
        'harga': _hargaController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        'kategori': _kategoriTerpilih,
      };
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _clearForm();
    }
  }

  // Method to clear form
  void _clearForm() {
    setState(() {
      _namaProdukController.clear();
      _hargaController.clear();
      _kategoriTerpilih = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              // Handle profile action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputSection('Nama Produk', 
                TextFormField(
                  controller: _namaProdukController,
                  decoration: _buildInputDecoration('Masukkan nama produk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    if (value.length < 3) {
                      return 'Nama produk minimal 3 karakter';
                    }
                    return null;
                  },
                ),
              ),
              
              _buildInputSection('Harga',
                TextFormField(
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _buildInputDecoration('Masukkan harga')
                    .copyWith(prefixText: 'Rp '),
                  onChanged: (value) {
                    final formattedValue = _formatCurrency(value);
                    _hargaController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(offset: formattedValue.length),
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    final price = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                    if (price <= 0) {
                      return 'Harga harus lebih dari 0';
                    }
                    return null;
                  },
                ),
              ),
              
              _buildInputSection('Kategori Produk',
                DropdownButtonFormField<String>(
                  value: _kategoriTerpilih,
                  hint: const Text('Pilih kategori'),
                  decoration: _buildInputDecoration(''),
                  items: _kategoriList.map((String kategori) {
                    return DropdownMenuItem(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _kategoriTerpilih = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih kategori terlebih dahulu';
                    }
                    return null;
                  },
                ),
              ),
              
              _buildInputSection('Gambar Produk',
                GestureDetector(
                  onTap: () {
                    // Implement image picker
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/upload.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Choose file',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B56D2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan Produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}