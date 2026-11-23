import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _experienceName = "";
  String _description = "";
  String _category = "Internship"; // default
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt;
  final _startedAtController = TextEditingController();
  final _endedAtController = TextEditingController();

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
  ];

  String? _validateOptionalUrl(String? value) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(url);
    if (url.length > 200 ||
        uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Masukkan URL HTTP atau HTTPS yang valid.';
    }
    return null;
  }

  void _saveExperience() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_startedAt == null) {
      final startedAt = DateTime.now();
      setState(() {
        _startedAt = startedAt;
        _startedAtController.text = MaterialLocalizations.of(context)
            .formatMediumDate(startedAt);
      });
    }
    form.save();

    final startedAt = MaterialLocalizations.of(context)
        .formatMediumDate(_startedAt!);
    final endedAt = _endedAt == null
        ? 'Sedang berlangsung'
        : MaterialLocalizations.of(context).formatMediumDate(_endedAt!);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengalaman berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nama Pengalaman: $_experienceName'),
              Text('Deskripsi: $_description'),
              Text('Kategori: $_category'),
              Text(
                'Thumbnail: ${_thumbnail.isEmpty ? "Tidak diisi" : _thumbnail}',
              ),
              Text('Tanggal Dimulai: $startedAt'),
              Text('Tanggal Selesai: $endedAt'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartedAt() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startedAt ?? _endedAt ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: _endedAt ?? DateTime(2100),
    );

    if (!mounted || selectedDate == null) {
      return;
    }
    setState(() {
      _startedAt = selectedDate;
      _startedAtController.text = MaterialLocalizations.of(context)
          .formatMediumDate(selectedDate);
    });
  }

  Future<void> _selectEndedAt() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? _startedAt ?? DateTime.now(),
      firstDate: _startedAt ?? DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (!mounted || selectedDate == null) {
      return;
    }
    setState(() {
      _endedAt = selectedDate;
      _endedAtController.text = MaterialLocalizations.of(context)
          .formatMediumDate(selectedDate);
    });
  }

  @override
  void dispose() {
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Experience Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Pengalaman",
                    labelText: "Nama Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLength: 255,
                  onSaved: (value) {
                    _experienceName = value?.trim() ?? '';
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama pengalaman tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Nama pengalaman maksimal 255 karakter.";
                    }
                    return null;
                  },
                ),
              ),
              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Pengalaman",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (value) {
                    _description = value?.trim() ?? '';
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi pengalaman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _category = newValue);
                    }
                  },
                ),
              ),

              // === Thumbnail ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: https://drive.google.com/",
                    labelText: "Gambar Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _thumbnail = value?.trim() ?? '',
                  validator: _validateOptionalUrl,
                ),
              ),

              // === Started At ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedAtController,
                  readOnly: true,
                  onTap: _selectStartedAt,
                  decoration: InputDecoration(
                    hintText: "Tanggal mulai pengalaman",
                    labelText: "Started At (optional)",
                    suffixIcon: _startedAt == null
                        ? const Icon(Icons.calendar_today)
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _startedAt = null;
                                _startedAtController.clear();
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              // === Ended At ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  onTap: _selectEndedAt,
                  decoration: InputDecoration(
                    hintText: "Tanggal selesai pengalaman",
                    labelText: "Ended At (optional)",
                    suffixIcon: _endedAt == null
                        ? const Icon(Icons.calendar_today)
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _endedAt = null;
                                _endedAtController.clear();
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    final startedAt = _startedAt ?? DateTime.now();
                    if (_endedAt != null &&
                        DateUtils.dateOnly(_endedAt!)
                            .isBefore(DateUtils.dateOnly(startedAt))) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                ),
              ),
              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _saveExperience,
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
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
}
