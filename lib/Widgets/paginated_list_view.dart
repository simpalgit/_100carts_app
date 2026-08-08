import 'package:flutter/material.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  const PaginatedListView(
      {super.key,
      required this.scrollController,
      required this.enabledPagination,
      required this.itemView,
      required this.offset,
      required this.onPaginate,
      required this.reverse,
      required this.totalSize});

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
              widget.scrollController.position.maxScrollExtent &&
          widget.totalSize != null &&
          !_isLoading &&
          widget.enabledPagination) {
        if (mounted) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / 20).ceil();
    if (_offset! < pageSize && !_offsetList.contains(_offset! + 20)) {
      setState(() {
        _offset = _offset! + 20;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for (int index = 1; index <= widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    return Column(children: [
      widget.reverse ? const SizedBox() : widget.itemView,
      ((widget.totalSize == null ||
              _offset! >= (widget.totalSize! / 20).ceil() ||
              _offsetList.contains(_offset! + 20)))
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      // : InkWell(
                      //     onTap: _paginate,
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(
                      //           vertical: 10, horizontal: 20),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: blackColor,
                      //       ),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: const [
                      //           Text('View More',
                      //               style: TextStyle(
                      //                   fontSize: 12,
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold)),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Icon(
                      //             Icons.arrow_downward_rounded,
                      //             color: whiteColor,
                      //             size: 15,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   )
                      : const SizedBox()),
            ),
      widget.reverse ? widget.itemView : const SizedBox(),
    ]);
  }
}
