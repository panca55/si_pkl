import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<void> showAttendancePopup({
  required BuildContext context,
  required Function(String, Uint8List?, String?) onSubmit,
}) async {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  // Initialize camera only for mobile platforms
  if (!kIsWeb) {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Cari camera depan (front camera)
        CameraDescription? frontCamera;
        for (var camera in cameras) {
          if (camera.lensDirection == CameraLensDirection.front) {
            frontCamera = camera;
            break;
          }
        }

        // Gunakan camera depan jika ada, jika tidak gunakan camera pertama
        final selectedCamera = frontCamera ?? cameras.first;

        cameraController = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await cameraController.initialize();
        isCameraInitialized = true;
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  String? selectedStatus;
  Uint8List? capturedImageBytes;
  String? filePath;
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1), // Indigo
                    Color(0xFF8B5CF6), // Purple
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Absensi Siswa",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Selection
                            const Text(
                              "Pilih Status Kehadiran",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFD1D5DB)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                hint: const Text(
                                  "Pilih Keterangan",
                                  style: TextStyle(color: Color(0xFF9CA3AF)),
                                ),
                                items: [
                                  {
                                    'value': 'HADIR',
                                    'label': 'Hadir',
                                    'icon': Icons.check_circle,
                                    'color': Colors.green,
                                  },
                                  {
                                    'value': 'IZIN',
                                    'label': 'Izin',
                                    'icon': Icons.info,
                                    'color': Colors.blue,
                                  },
                                  {
                                    'value': 'SAKIT',
                                    'label': 'Sakit',
                                    'icon': Icons.local_hospital,
                                    'color': Colors.orange,
                                  },
                                  {
                                    'value': 'ALPHA',
                                    'label': 'Alpha',
                                    'icon': Icons.cancel,
                                    'color': Colors.red,
                                  },
                                ]
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['value'] as String,
                                          child: Row(
                                            children: [
                                              Icon(
                                                item['icon'] as IconData,
                                                color: item['color'] as Color,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                item['label'] as String,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                value: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                    capturedImageBytes = null;
                                    filePath = null;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Document/Camera Section
                            if (selectedStatus != null) ...[
                              if (selectedStatus == "IZIN" ||
                                  selectedStatus == "SAKIT") ...[
                                const Text(
                                  "Upload Dokumen Pendukung",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFD1D5DB),
                                      style: BorderStyle.solid,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: capturedImageBytes != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            capturedImageBytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 40,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Upload surat keterangan",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() => isLoading = true);
                                            try {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await picker.pickImage(
                                                source: ImageSource.gallery,
                                              );
                                              if (image != null) {
                                                capturedImageBytes =
                                                    await image.readAsBytes();
                                                filePath = image.path;
                                              }
                                            } catch (e) {
                                              debugPrint(
                                                  "Error picking image: $e");
                                            }
                                            setState(() => isLoading = false);
                                          },
                                    icon: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.upload_file),
                                    label: Text(isLoading
                                        ? "Mengupload..."
                                        : "Pilih Dokumen"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if (selectedStatus == "HADIR") ...[
                                const Text(
                                  "Ambil Foto Untuk Absensi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Camera Preview
                                Container(
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color(0xFFD1D5DB)),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: capturedImageBytes != null
                                            ? Image.memory(
                                                capturedImageBytes!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                            : (!kIsWeb &&
                                                    isCameraInitialized &&
                                                    !isLoading &&
                                                    cameraController != null &&
                                                    cameraController!
                                                        .value.isInitialized)
                                                ? SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: SizedBox(
                                                        width: cameraController!
                                                            .value
                                                            .previewSize!
                                                            .height,
                                                        height:
                                                            cameraController!
                                                                .value
                                                                .previewSize!
                                                                .width,
                                                        child: Transform(
                                                          alignment:
                                                              Alignment.center,
                                                          transform: Matrix4
                                                              .identity()
                                                            ..scale(
                                                                cameraController
                                                                            ?.description
                                                                            .lensDirection ==
                                                                        CameraLensDirection
                                                                            .front
                                                                    ? -1.0
                                                                    : 1.0,
                                                                1.0),
                                                          child: CameraPreview(
                                                              cameraController!),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.grey[100],
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (isLoading)
                                                          const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              Color(0xFF6366F1),
                                                            ),
                                                          )
                                                        else
                                                          Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 50,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                        const SizedBox(
                                                            height: 12),
                                                        Text(
                                                          isLoading
                                                              ? "Switching camera..."
                                                              : kIsWeb
                                                                  ? "Camera tidak tersedia di web"
                                                                  : "Menginisialisasi kamera...",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                      ),
                                      // Switch Camera Button
                                      if (!kIsWeb &&
                                          isCameraInitialized &&
                                          !isLoading &&
                                          capturedImageBytes == null &&
                                          cameras != null &&
                                          cameras.length > 1)
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: IconButton(
                                              onPressed: () async {
                                                if (cameras == null ||
                                                    cameraController == null ||
                                                    isLoading ||
                                                    !cameraController!.value
                                                        .isInitialized) return;

                                                try {
                                                  setState(
                                                      () => isLoading = true);

                                                  // Find next camera first
                                                  final currentIndex = cameras
                                                      .indexOf(cameraController!
                                                          .description);
                                                  final nextIndex =
                                                      (currentIndex + 1) %
                                                          cameras.length;
                                                  final nextCamera =
                                                      cameras[nextIndex];

                                                  // Dispose current controller safely
                                                  final oldController =
                                                      cameraController;
                                                  cameraController = null;
                                                  isCameraInitialized = false;

                                                  await oldController
                                                      ?.dispose();

                                                  // Wait for cleanup
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500));

                                                  // Initialize new camera
                                                  cameraController =
                                                      CameraController(
                                                    nextCamera,
                                                    ResolutionPreset.medium,
                                                    enableAudio: false,
                                                  );

                                                  await cameraController!
                                                      .initialize();
                                                  isCameraInitialized = true;

                                                  // Small delay before updating UI
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100));

                                                  setState(
                                                      () => isLoading = false);
                                                } catch (e) {
                                                  debugPrint(
                                                      "Error switching camera: $e");
                                                  setState(
                                                      () => isLoading = false);

                                                  // Try to reinitialize with front camera
                                                  try {
                                                    CameraDescription?
                                                        frontCamera;
                                                    for (var camera
                                                        in cameras) {
                                                      if (camera
                                                              .lensDirection ==
                                                          CameraLensDirection
                                                              .front) {
                                                        frontCamera = camera;
                                                        break;
                                                      }
                                                    }

                                                    final selectedCamera =
                                                        frontCamera ??
                                                            cameras.first;
                                                    cameraController =
                                                        CameraController(
                                                      selectedCamera,
                                                      ResolutionPreset.medium,
                                                      enableAudio: false,
                                                    );
                                                    await cameraController!
                                                        .initialize();
                                                    isCameraInitialized = true;
                                                    setState(() {});
                                                  } catch (reinitError) {
                                                    debugPrint(
                                                        "Failed to reinitialize camera: $reinitError");
                                                    isCameraInitialized = false;
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.flip_camera_ios,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: (isLoading ||
                                            (!kIsWeb && !isCameraInitialized))
                                        ? null
                                        : () async {
                                            setState(() => isLoading = true);
                                            try {
                                              if (isCameraInitialized) {
                                                final XFile image =
                                                    await cameraController!
                                                        .takePicture();
                                                filePath = image.path;
                                                capturedImageBytes =
                                                    await image.readAsBytes();
                                              } else {
                                                // Fallback to image picker for camera
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.camera,
                                                );
                                                if (image != null) {
                                                  capturedImageBytes =
                                                      await image.readAsBytes();
                                                  filePath = image.path;
                                                }
                                              }
                                            } catch (e) {
                                              debugPrint(
                                                  "Error taking picture: $e");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text("Error: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                            setState(() => isLoading = false);
                                          },
                                    icon: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.camera_alt),
                                    label: Text(
                                      isLoading
                                          ? "Mengambil foto..."
                                          : capturedImageBytes != null
                                              ? "Ambil Foto Ulang"
                                              : "Ambil Foto",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // Dispose camera before closing
                                    if (!kIsWeb && cameraController != null) {
                                      await cameraController?.dispose();
                                    }
                                    Navigator.pop(context);
                                  },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                    const BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                            ),
                            child: const Text(
                              "Batal",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (selectedStatus != null &&
                                    capturedImageBytes != null &&
                                    !isLoading)
                                ? () async {
                                    // Dispose camera before closing
                                    if (!kIsWeb && cameraController != null) {
                                      await cameraController?.dispose();
                                    }
                                    onSubmit(selectedStatus!,
                                        capturedImageBytes, filePath);
                                    Navigator.pop(context, true);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Simpan Absensi",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((_) {
    // Dispose camera controller when dialog closes
    if (!kIsWeb && cameraController != null) {
      cameraController?.dispose();
    }
  });
}
