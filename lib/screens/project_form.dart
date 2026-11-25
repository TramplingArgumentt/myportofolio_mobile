import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/models/project_tag.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _projectName = "";
  String _description = "";
  final List<String> _selectedTagIds = [];
  List<ProjectTag> _availableTags = [];
  bool _isLoadingTags = true;
  String? _tagLoadError;
  String _projectUrl = "";
  String _projectImageUrl = "";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchProjectTags();
  }

  Future<void> _fetchProjectTags() async {
    try {
      final tags = await context.read<ApiClient>().getProjectTags();
      if (!mounted) return;
      setState(() {
        _availableTags = tags;
        _isLoadingTags = false;
        _tagLoadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingTags = false;
        _tagLoadError = error.toString();
      });
    }
  }

  void _retryFetchProjectTags() {
    setState(() {
      _isLoadingTags = true;
      _tagLoadError = null;
    });
    _fetchProjectTags();
  }

  String? _validateOptionalUrl(String? value, {required int maxLength}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(url);
    if (url.length > maxLength ||
        uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Masukkan URL HTTP/HTTPS yang valid (maksimal $maxLength karakter).';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isLoadingTags || _tagLoadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daftar tags belum tersedia. Silakan coba lagi.'),
        ),
      );
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    form.save();

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (!await ensureLoggedIn(context) || !mounted) return;

      final token = context.read<AuthState>().token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan masuk untuk menambah proyek.')),
        );
        return;
      }

      final newProject = Project(
        title: _projectName,
        description: _description,
        tags: _selectedTagIds,
        projectUrl: _projectUrl,
        projectImageUrl: _projectImageUrl,
      );
      await context.read<ApiClient>().createProject(newProject, token: token);
      if (!mounted) return;

      final selectedTagNames = _availableTags
          .where((tag) => _selectedTagIds.contains(tag.id))
          .map((tag) => tag.name)
          .toList();
      final tagSummary = selectedTagNames.isEmpty
          ? 'Tidak diisi'
          : selectedTagNames.join(', ');
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama Proyek: $_projectName'),
                Text('Deskripsi: $_description'),
                Text('Tags: $tagSummary'),
                Text(
                  'URL Proyek: ${_projectUrl.isEmpty ? "Tidak diisi" : _projectUrl}',
                ),
                Text(
                  'URL Gambar: ${_projectImageUrl.isEmpty ? "Tidak diisi" : _projectImageUrl}',
                ),
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
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (logoutError) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal keluar: $logoutError')));
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Sesi berakhir. Silakan masuk kembali.'),
            ),
          );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menambah proyek (${error.statusCode}): ${error.message}',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambah proyek: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tambah Proyek')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Project Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Proyek",
                    labelText: "Nama Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLength: 255,
                  onSaved: (value) {
                    _projectName = value?.trim() ?? '';
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama proyek tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Nama proyek maksimal 255 karakter.";
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
                    hintText: "Deskripsi Proyek",
                    labelText: "Deskripsi Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (value) => _description = value?.trim() ?? '',
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi proyek tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tags ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_isLoadingTags)
                      const Center(child: CircularProgressIndicator())
                    else if (_tagLoadError != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text('Gagal memuat tags: $_tagLoadError'),
                          ),
                          TextButton(
                            onPressed: _retryFetchProjectTags,
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      )
                    else if (_availableTags.isEmpty)
                      const Text('Belum ada tags yang tersedia.')
                    else
                      ..._availableTags.map(
                        (tag) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(tag.name),
                          value: _selectedTagIds.contains(tag.id),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected == true) {
                                _selectedTagIds.add(tag.id);
                              } else {
                                _selectedTagIds.remove(tag.id);
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // === Project URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Proyek (opsional)",
                    labelText: "URL Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _projectUrl = value?.trim() ?? '',
                  validator: (value) =>
                      _validateOptionalUrl(value, maxLength: 200),
                ),
              ),

              // === Project Image URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL gambar proyek (opsional)",
                    labelText: "URL Gambar Proyek (Opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _projectImageUrl = value?.trim() ?? '',
                  validator: (value) =>
                      _validateOptionalUrl(value, maxLength: 500),
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
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
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
