import 'package:flutter/material.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';

class PriorityDialog extends StatelessWidget {
  final int initialPriority;
  final Function(int) onPrioritySelected;

  const PriorityDialog({
    super.key,
    required this.initialPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    int tempPriority = initialPriority;

    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Task Priority",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(10, (index) {
                    int priorityLevel = index + 1;
                    bool isSelected = tempPriority == priorityLevel;

                    return InkWell(
                      onTap: () {
                        setStateDialog(() {
                          tempPriority = priorityLevel;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected ? ColorsManager.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? ColorsManager.primaryColor : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsManager.flag,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$priorityLevel",
                              style: TextStyle(
                                color: isSelected ? Colors.white : ColorsManager.textLargeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onPrioritySelected(tempPriority);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}