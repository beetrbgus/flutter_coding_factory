import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<StatefulWidget> createState() => _TestState();
}

class _TestState extends State<Test> {
  static const List<String> _dropdownList = ['1', '2', '3', '4'];
  bool isOpened = false;
  String? _dropdownValue;

  // 드롭 박스
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _width = 200;
  static const double _height = 48;

  void _createOverlay() {
    setState(() {
      isOpened = true;
    });
    if (_overlayEntry == null) {
      _overlayEntry = _customDropdown();
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  // 드롭다운 해제.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isOpened = false;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _removeOverlay();
      },
      child: Scaffold(
        body: Center(
          child: InkWell(
            onTap: () {
              if (!isOpened) {
                _createOverlay();
              } else {
                _removeOverlay();
              }
            },
            child: CompositedTransformTarget(
              link: _layerLink,
              child: Container(
                width: _width,
                height: _height,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isOpened ? Colors.orange : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 선택값 또는 힌트 텍스트
                    Text(
                      _dropdownValue ?? '지급 방식', // 선택된 값이 없으면 힌트 텍스트를 표시
                      style: TextStyle(
                        fontSize: 16,
                        height: 22 / 16,
                        color: _dropdownValue == null
                            ? Colors.grey
                            : Colors.black, // 힌트 텍스트 스타일 적용
                      ),
                    ),

                    // 아이콘.
                    isOpened
                        ? const Icon(
                            Icons.arrow_upward,
                            size: 16,
                          )
                        : const Icon(
                            Icons.arrow_downward,
                            size: 16,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 드롭다운.
  OverlayEntry _customDropdown() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: _width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, _height),
          child: Material(
            color: Colors.white,
            child: Container(
              height: (22.0 * _dropdownList.length) +
                  (21 * (_dropdownList.length - 1)) +
                  20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _dropdownList.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      setState(() {
                        _dropdownValue = _dropdownList.elementAt(index);
                      });
                      _removeOverlay();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _dropdownList.elementAt(index),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 22 / 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
