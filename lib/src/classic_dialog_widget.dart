import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

///Single selection callback of list dialog
typedef OnSingleSelectionCallback = void Function(int selectedIndex);

///Multiple selection callback of list dialog
typedef OnMultiSelectionCallback = void Function(List<int> selectedIndexes);

///
///created time: 2019-07-31 09:35
///author linzhiliang
///version 1.0
///since
///file name: classic_dialog_widget.dart
///description: General dialog
///
@immutable
class ClassicGeneralDialogWidget extends StatelessWidget {
  ///Title text of the dialog
  final String? titleText;

  ///Content text of the dialog
  final String? contentText;

  ///Text of negative button, the left button at the bottom of dialog
  final String? negativeText;

  ///Text of positive button, the right button at the bottom of dialog
  final String? positiveText;

  ///TextStyle of negative button, the left button at the bottom of dialog
  final TextStyle? negativeTextStyle;

  ///TextStyle of positive button, the right button at the bottom of dialog
  final TextStyle? positiveTextStyle;

  ///Click callback of negative button
  final VoidCallback? onNegativeClick;

  ///Click callback of positive button
  final VoidCallback? onPositiveClick;

  ///Actions at the bottom of dialog, when this is set, [negativeText] [positiveText] [onNegativeClick] [onPositiveClick] will not work。
  final List<Widget>? actions;

  const ClassicGeneralDialogWidget({
    super.key,
    this.titleText,
    this.contentText,
    this.actions,
    this.negativeText,
    this.positiveText,
    this.negativeTextStyle,
    this.positiveTextStyle,
    this.onNegativeClick,
    this.onPositiveClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomDialogWidget(
      title: titleText != null
          ? Text(
        titleText!,
        style: theme.dialogTheme.titleTextStyle ??
            theme.textTheme.titleLarge,
      )
          : null,
      content: contentText != null
          ? Text(
        contentText!,
        style: theme.dialogTheme.contentTextStyle ??
            theme.textTheme.bodyLarge,
      )
          : null,
      actions: actions ??
          [
            if (onNegativeClick != null)
              TextButton(
                onPressed: onNegativeClick,
                child: Text(
                  negativeText ?? 'Cancel',
                  style: negativeTextStyle ??
                      theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            if (onPositiveClick != null)
              TextButton(
                onPressed: onPositiveClick,
                child: Text(
                  positiveText ?? 'Confirm',
                  style: positiveTextStyle ??
                      theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                ),
              ),
          ],
      elevation: 0.0,
      shape: theme.dialogTheme.shape,
    );
  }
}


///List type
enum ListType {
  ///Single
  single,

  ///Single select
  singleSelect,

  ///Multiple select
  multiSelect,
}

///
///created time: 2019-08-01 08:59
///author linzhiliang
///version 1.0
///since
///file name: classic_dialog_widget.dart
///description: Classic dialog with list content
///
class ClassicListDialogWidget<T> extends StatefulWidget {
  ///Title text of the dialog
  final String? titleText;

  ///Data of the list
  final List<T>? dataList;

  ///Custom list item widget
  final Widget? listItem;

  ///Click callback of default list item
  final VoidCallback? onListItemClick;

  ///List type
  final ListType listType;

  ///Where to place control relative to the text
  final ListTileControlAffinity controlAffinity;

  ///The active color of radio or checkbox
  final Color? activeColor;

  ///Selected indexes when [listType] is [ListType.multiSelect]
  final List<int>? selectedIndexes;

  ///Selected index when [listType] is [ListType.singleSelect]
  final int? selectedIndex;

  ///Text of negative button, the left button at the bottom of dialog
  final String? negativeText;

  ///Text of positive button, the right button at the bottom of dialog
  final String? positiveText;

  ///Click callback of negative button
  final VoidCallback? onNegativeClick;

  ///Click callback of positive button
  final VoidCallback? onPositiveClick;

  ///Actions at the bottom of dialog, when this is set, [negativeText] [positiveText] [onNegativeClick] [onPositiveClick] will not work。
  final List<Widget>? actions;

  const ClassicListDialogWidget({
    super.key,
    this.titleText,
    this.dataList,
    this.listItem,
    this.onListItemClick,
    this.listType = ListType.single,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.activeColor,
    this.selectedIndexes,
    this.selectedIndex,
    this.actions,
    this.negativeText,
    this.positiveText,
    this.onNegativeClick,
    this.onPositiveClick,
  });

  @override
  State<ClassicListDialogWidget<T>> createState() => _ClassicListDialogWidgetState<T>();
}

class _ClassicListDialogWidgetState<T> extends State<ClassicListDialogWidget<T>> {
  late int selectedIndex;
  late List<bool> valueList;
  List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    valueList = List.generate(widget.dataList?.length ?? 0, (index) {
      return widget.selectedIndexes?.contains(index) ?? false;
    });
    selectedIndex = widget.selectedIndex ?? -1;
    selectedIndexes = widget.selectedIndexes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget contentWidget = ListView.builder(
      shrinkWrap: true,
      itemCount: widget.dataList?.length ?? 0,
      itemBuilder: (context, index) {
        final item = widget.dataList![index];

        if (widget.listItem != null) return widget.listItem!;

        switch (widget.listType) {
          case ListType.single:
            return ListTile(
              title: Text(
                item.toString(),
                style: theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge,
              ),
              onTap: widget.onListItemClick ?? () => Navigator.of(context).pop(index),
            );
          case ListType.singleSelect:
            return RadioListTile<int>(
              controlAffinity: widget.controlAffinity,
              title: Text(
                item.toString(),
                style: theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge,
              ),
              activeColor: widget.activeColor ?? theme.colorScheme.primary,
              value: index,
              groupValue: selectedIndex,
              onChanged: (value) => setState(() => selectedIndex = value!),
            );
          case ListType.multiSelect:
            return CheckboxListTile(
              controlAffinity: widget.controlAffinity,
              value: valueList[index],
              title: Text(
                item.toString(),
                style: theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge,
              ),
              onChanged: (value) => setState(() => valueList[index] = value!),
              activeColor: widget.activeColor ?? theme.colorScheme.primary,
            );
        }
      },
    );

    return CustomDialogWidget(
      title: widget.titleText != null
          ? Text(
        widget.titleText!,
        style: theme.dialogTheme.titleTextStyle ?? theme.textTheme.titleLarge,
      )
          : null,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(width: double.maxFinite, child: contentWidget),
      actions: widget.actions ?? [
        if (widget.onNegativeClick != null)
          TextButton(
            onPressed: widget.onNegativeClick,
            child: Text(
              widget.negativeText ?? 'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        TextButton(
          onPressed: widget.onPositiveClick ?? () {
            switch (widget.listType) {
              case ListType.single:
                Navigator.of(context).pop();
                break;
              case ListType.singleSelect:
                Navigator.of(context).pop(selectedIndex);
                break;
              case ListType.multiSelect:
                selectedIndexes = [];
                for (int i = 0; i < valueList.length; i++) {
                  if (valueList[i]) selectedIndexes.add(i);
                }
                Navigator.of(context).pop(selectedIndexes);
                break;
            }
          },
          child: Text(
            widget.positiveText ?? 'Confirm',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        )
      ],
      elevation: 0.0,
      shape: theme.dialogTheme.shape,
    );
  }
}
