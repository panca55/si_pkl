import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker_web/image_picker_web.dart';

Future<void> showAttendancePopup({
  required BuildContext context,
  required Function(String, Uint8List?, String?) onSubmit,
}) async {
  CameraController? cameraController;
  if (!kIsWeb || kIsWeb) {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.medium);
    await cameraController.initialize();
  }

  String? selectedStatus;
  Uint8List? capturedImageBytes;
  String? filePath;

  showDialog(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Form Absensi"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Pilih Keterangan"),
                  items: ["HADIR", "IZIN", "SAKIT", "ALPHA"]
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  value: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedStatus != null) ...[
                  if (!kIsWeb || kIsWeb)
                    ElevatedButton(
                      onPressed: () async {
                        // capturedImageBytes =
                            // await ImagePickerWeb.getImageAsBytes();
                        // setState(() {});
                      },
                      child: const Text("Ambil Foto (Web)"),
                    ),
                  if(!kIsWeb || kIsWeb)
                    SizedBox(
                      height: 200,
                      child: CameraPreview(cameraController!),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final XFile image =
                            await cameraController!.takePicture();
                        filePath = image.path;
                        capturedImageBytes = await image.readAsBytes();
                        setState(() {});
                      },
                      child: const Text("Ambil Foto (Mobile)"),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (capturedImageBytes != null)
                    Image.memory(
                      capturedImageBytes!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text("Foto belum diambil."),
                ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: selectedStatus != null && capturedImageBytes != null
                    ? () {
                        onSubmit(selectedStatus!, capturedImageBytes, filePath);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      );
    },
  ).then((_) {
    if (!kIsWeb || kIsWeb) {
      cameraController?.dispose();
    }
  });
}
