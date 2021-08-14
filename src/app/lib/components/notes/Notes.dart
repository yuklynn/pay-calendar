import 'package:flutter/material.dart';

import '../../models/notes/NotesModel.dart';
import '../../types/NoteType.dart';
import '../../util/theme.dart';
import '../common/CommonAppBar.dart';
import '../common/DisableScrollGlow.dart';
import '../common/ListBottomIndicator.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotesModel.provider(
      (
        loading,
        notes,
        createNote,
        updatePin,
        toDetail,
      ) =>
          _Notes(
        loading: loading,
        notes: notes,
        createNote: createNote,
        updatePin: updatePin,
        toDetail: toDetail,
      ),
    );
  }
}

class _Notes extends StatelessWidget {
  final bool loading;
  final List<NoteType> notes;
  final VoidCallback createNote;
  final void Function(NoteType) updatePin;
  final void Function(NoteType) toDetail;

  _Notes({
    required this.loading,
    required this.notes,
    required this.createNote,
    required this.updatePin,
    required this.toDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  AppBar _buildAppBar() {
    return CommonAppBar(
      title: const Text('Notes'),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: !loading ? 0.0 : null,
          backgroundColor: !loading ? Colors.transparent : null,
        ),
        Expanded(
          child: _buildList(),
        ),
      ],
    );
  }

  Widget _buildList() {
    return DisableScrollGlow(
      child: ListView.separated(
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index == notes.length) return const ListBottomIndicator();

          return _buildListTile(notes[index], context);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Widget _buildListTile(NoteType note, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.sticky_note_2),
        backgroundColor: Color(note.color),
        foregroundColor: Colors.white,
      ),
      title: Text(
        note.title,
        style: TextStyle(
          color: note.id == null ? Theme.of(context).highlightColor : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.push_pin),
        color: note.pin ? MainTheme.primaryColor : null,
        onPressed: () => updatePin(note),
      ),
      onTap: () => toDetail(note),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: createNote,
      child: const Icon(Icons.note_add),
    );
  }
}
