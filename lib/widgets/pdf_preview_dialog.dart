import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/evaluation_guru_provider.dart';

class PdfPreviewDialog extends StatefulWidget {
  final Uint8List pdfData;
  final String title;
  final Function(Uint8List)? onDownload;
  final int? evaluationId;
  final int? internshipId;

  const PdfPreviewDialog({
    super.key,
    required this.pdfData,
    this.title = 'PDF Preview',
    this.onDownload,
    this.evaluationId,
    this.internshipId,
  });

  @override
  State<PdfPreviewDialog> createState() => _PdfPreviewDialogState();
}

class _PdfPreviewDialogState extends State<PdfPreviewDialog> {
  Uint8List? _pdfData;

  @override
  void initState() {
    super.initState();
    // Store the PDF data in state to prevent it from being lost on rebuilds
    _pdfData = widget.pdfData;
    debugPrint(
        'PdfPreviewDialog initialized with data length: ${_pdfData?.length ?? 0}');
    debugPrint(
        'PdfPreviewDialog data first 20 bytes: ${_pdfData?.take(20) ?? []}');
    debugPrint('PdfPreviewDialog data isEmpty: ${_pdfData?.isEmpty ?? true}');
  }

  @override
  void didUpdateWidget(PdfPreviewDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the widget is updated with new data, update our stored data
    if (widget.pdfData != oldWidget.pdfData) {
      _pdfData = widget.pdfData;
      debugPrint(
          'PdfPreviewDialog updated with new data length: ${_pdfData?.length ?? 0}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),

            // PDF Preview
            Expanded(
              child: PdfPreview(
                build: (format) => _pdfData!,
                onShared: (context) {
                  if (widget.onDownload != null && _pdfData != null) {
                    widget.onDownload!(_pdfData!);
                  }
                },
                allowPrinting: false,
                allowSharing: false,
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                initialPageFormat: pw.PdfPageFormat.a4,
                pdfFileName: 'evaluation.pdf',
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Print the PDF
                    await Printing.layoutPdf(
                      onLayout: (format) => _pdfData!,
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Cetak'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    debugPrint('Download button pressed');
                    debugPrint('_pdfData.length: ${_pdfData?.length ?? 0}');
                    debugPrint(
                        '_pdfData.isEmpty: ${_pdfData?.isEmpty ?? true}');
                    debugPrint(
                        '_pdfData.isNotEmpty: ${_pdfData?.isNotEmpty ?? false}');
                    try {
                      // If we have any data at all, try to download it
                      // The preview is working, so the data must be somewhat valid
                      if (_pdfData != null && _pdfData!.isNotEmpty) {
                        debugPrint(
                            'Attempting to download PDF data (${_pdfData!.length} bytes)');

                        if (kIsWeb) {
                          // For web, use HTML5 download
                          final blob = html.Blob([_pdfData!]);
                          final url = html.Url.createObjectUrlFromBlob(blob);
                          html.AnchorElement(href: url)
                            ..target = 'blank'
                            ..download = 'evaluation.pdf'
                            ..click();
                          html.Url.revokeObjectUrl(url);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'PDF berhasil didownload dari preview'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } else {
                          // For mobile, use Printing.sharePdf
                          await Printing.sharePdf(
                            bytes: _pdfData!,
                            filename: 'evaluation.pdf',
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('PDF berhasil dibagikan dari preview'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } else {
                        // Data is missing, try to re-fetch it
                        debugPrint(
                            'PDF data is missing from dialog state, attempting to re-fetch...');
                        debugPrint(
                            'evaluationId: ${widget.evaluationId}, internshipId: ${widget.internshipId}');

                        if (widget.evaluationId != null ||
                            widget.internshipId != null) {
                          try {
                            final evaluationProvider =
                                Provider.of<EvaluationGuruProvider>(context,
                                    listen: false);
                            Uint8List? refetchedData;

                            // Try internship ID first, then evaluation ID
                            if (widget.internshipId != null) {
                              refetchedData = await evaluationProvider
                                  .getPrintEvaluation(widget.internshipId!);
                            }
                            if (refetchedData == null &&
                                widget.evaluationId != null) {
                              refetchedData = await evaluationProvider
                                  .getPrintEvaluation(widget.evaluationId!);
                            }

                            if (refetchedData != null &&
                                refetchedData.isNotEmpty) {
                              debugPrint(
                                  'Successfully re-fetched PDF data: ${refetchedData.length} bytes');

                              // Use the re-fetched data directly for download
                              if (kIsWeb) {
                                final blob = html.Blob([refetchedData]);
                                final url =
                                    html.Url.createObjectUrlFromBlob(blob);
                                html.AnchorElement(href: url)
                                  ..target = 'blank'
                                  ..download = 'evaluation.pdf'
                                  ..click();
                                html.Url.revokeObjectUrl(url);

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('PDF berhasil didownload'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              } else {
                                await Printing.sharePdf(
                                  bytes: refetchedData,
                                  filename: 'evaluation.pdf',
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('PDF berhasil dibagikan'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Gagal memuat ulang data PDF'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('Failed to re-fetch PDF data: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal memuat ulang PDF: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Data PDF hilang dan tidak dapat dimuat ulang'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal mendownload PDF: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
