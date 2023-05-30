import 'package:flutter/material.dart';

class FilterDocs extends StatelessWidget {
  final List<String> categoryList;
  final String selectedCategory;
  final String selectedSort;
  final Function(String) onCategoryChange, onSortChange, onTitleChange;
  final Function(bool forward) onPageChange;
  final double currentPage, maxPage;

  const FilterDocs({
    Key? key,
    required this.categoryList,
    required this.selectedCategory,
    required this.onCategoryChange,
    required this.selectedSort,
    required this.onSortChange,
    required this.onTitleChange,
    required this.onPageChange,
    required this.currentPage,
    required this.maxPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: [
          TextFormField(
            cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
            maxLength: 15,
            onChanged: onTitleChange,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: const Icon(Icons.search),
              ),
              labelText: 'Search title',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              labelStyle: const TextStyle(
                color: Color(0xFF6750A4),
              ),
              // enabledBorder: const OutlineInputBorder(
              //   borderSide:
              //       BorderSide(color: Color.fromARGB(149, 102, 80, 164)),
              // ),
              // focusedBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(color: Color(0xFF6750A4)),
              // ),
              // errorBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red),
              // ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Category:",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  DropdownButton(
                    value: selectedCategory == "" ? "None" : selectedCategory,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      if (value == "None") {
                        value = "";
                      }
                      onCategoryChange(value ?? "");
                      // This is called when the user selects an item.
                      // setState(() {
                      //   dropdownValue = value!;
                      // });
                    },
                    items: ["None", ...categoryList].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Text(
                    "Sort by:",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  DropdownButton(
                    value: selectedSort,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      onSortChange(value ?? "Title");
                    },
                    items: ["Title", "Date"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.arrow_back),
                        onTap: () => onPageChange(false),
                      ),
                      const SizedBox(width: 4),
                      Text(
                          "${currentPage.round().toString()}/${maxPage.ceil().toString()}"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        child: const Icon(Icons.arrow_forward),
                        onTap: () => onPageChange(true),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
