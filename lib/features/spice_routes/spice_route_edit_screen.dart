import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../models/spice_route.dart';
import '../../shared/widgets.dart';
import '../../state/providers.dart';
import '../../state/spice_routes.dart';

class SpiceRouteEditScreen extends ConsumerStatefulWidget {
  const SpiceRouteEditScreen({super.key, this.spiceRouteId});

  final String? spiceRouteId;
  bool get isNew => spiceRouteId == null;

  @override
  ConsumerState<SpiceRouteEditScreen> createState() =>
      _SpiceRouteEditScreenState();
}

class _EditableIngredient {
  _EditableIngredient({this.quantity = '', this.unit = '', this.name = ''});
  String quantity;
  String unit;
  String name;
}

class _SpiceRouteEditScreenState extends ConsumerState<SpiceRouteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _prep = TextEditingController(text: '0');
  final _cook = TextEditingController(text: '0');
  final _servings = TextEditingController(text: '1');
  final _tags = TextEditingController();
  bool _isPublic = false;
  final List<_EditableIngredient> _ingredients = [_EditableIngredient()];
  final List<TextEditingController> _steps = [TextEditingController()];

  bool _loading = false;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) _load();
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _prep.dispose();
    _cook.dispose();
    _servings.dispose();
    _tags.dispose();
    for (final s in _steps) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ref
          .read(apiClientProvider)
          .getSpiceRoute(widget.spiceRouteId!);
      _title.text = r.title;
      _desc.text = r.description ?? '';
      _prep.text = r.prepMinutes.toString();
      _cook.text = r.cookMinutes.toString();
      _servings.text = r.servings.toString();
      _tags.text = r.tags.map((t) => t.name).join(', ');
      _isPublic = r.isPublic;
      _ingredients
        ..clear()
        ..addAll(r.ingredients.map((i) => _EditableIngredient(
              quantity: i.quantity?.toString() ?? '',
              unit: i.unit ?? '',
              name: i.name,
            )));
      if (_ingredients.isEmpty) _ingredients.add(_EditableIngredient());

      for (final s in _steps) {
        s.dispose();
      }
      _steps
        ..clear()
        ..addAll(r.steps.map((s) => TextEditingController(text: s.body)));
      if (_steps.isEmpty) _steps.add(TextEditingController());
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _loadError = apiErrorMessage(e);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ingredientPayload = <Map<String, dynamic>>[];
    for (final ing in _ingredients) {
      if (ing.name.trim().isEmpty) continue;
      ingredientPayload.add({
        if (ing.quantity.trim().isNotEmpty)
          'quantity': double.tryParse(ing.quantity.trim()),
        if (ing.unit.trim().isNotEmpty) 'unit': ing.unit.trim(),
        'name': ing.name.trim(),
      });
    }
    final stepPayload = <Map<String, dynamic>>[];
    for (final s in _steps) {
      final text = s.text.trim();
      if (text.isNotEmpty) stepPayload.add({'body': text});
    }
    final body = {
      'title': _title.text.trim(),
      'description': _desc.text.trim().isEmpty ? null : _desc.text.trim(),
      'prep_minutes': int.tryParse(_prep.text.trim()) ?? 0,
      'cook_minutes': int.tryParse(_cook.text.trim()) ?? 0,
      'servings': int.tryParse(_servings.text.trim()) ?? 1,
      'is_public': _isPublic,
      'ingredients': ingredientPayload,
      'steps': stepPayload,
      'tags': _tags.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    };

    setState(() => _saving = true);
    try {
      final SpiceRouteDetail saved;
      if (widget.isNew) {
        saved = await ref.read(apiClientProvider).createSpiceRoute(body);
      } else {
        saved = await ref
            .read(apiClientProvider)
            .updateSpiceRoute(widget.spiceRouteId!, body);
      }
      ref.invalidate(tagsProvider);
      ref.read(spiceRouteListControllerProvider.notifier).refresh();
      if (!widget.isNew) {
        ref.invalidate(spiceRouteDetailProvider(widget.spiceRouteId!));
      }
      if (mounted) context.go('/spice_routes/${saved.id}');
    } catch (e) {
      if (mounted) showErrorSnack(context, apiErrorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(),
        body: CenterMessage(
          icon: Icons.error_outline,
          title: 'Could not load SpiceRoute',
          subtitle: _loadError,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'New SpiceRoute' : 'Edit SpiceRoute'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prep,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Prep min'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cook,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Cook min'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _servings,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Servings'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'thai, weeknight, gluten-free',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: _isPublic,
              onChanged: (v) => setState(() => _isPublic = v),
              title: const Text('Public'),
              subtitle: const Text('Visible to other users'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            _SectionHeader(
              title: 'Ingredients',
              onAdd: () =>
                  setState(() => _ingredients.add(_EditableIngredient())),
            ),
            for (var i = 0; i < _ingredients.length; i++)
              _IngredientRow(
                key: ValueKey('ing_$i'),
                model: _ingredients[i],
                onRemove: _ingredients.length > 1
                    ? () => setState(() => _ingredients.removeAt(i))
                    : null,
              ),
            const SizedBox(height: 16),
            _SectionHeader(
              title: 'Steps',
              onAdd: () =>
                  setState(() => _steps.add(TextEditingController())),
            ),
            for (var i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: CircleAvatar(
                        radius: 14,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _steps[i],
                        decoration: InputDecoration(
                          hintText: 'Step ${i + 1}',
                        ),
                        maxLines: null,
                      ),
                    ),
                    if (_steps.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() {
                          _steps[i].dispose();
                          _steps.removeAt(i);
                        }),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});
  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({super.key, required this.model, this.onRemove});
  final _EditableIngredient model;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: TextFormField(
              initialValue: model.quantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'qty'),
              onChanged: (v) => model.quantity = v,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: model.unit,
              decoration: const InputDecoration(hintText: 'unit'),
              onChanged: (v) => model.unit = v,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: model.name,
              decoration: const InputDecoration(hintText: 'ingredient'),
              onChanged: (v) => model.name = v,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
