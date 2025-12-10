# Bỏ qua các cảnh báo thiếu class JP2 (nguyên nhân chính gây lỗi)
-dontwarn com.gemalto.jp2.**

# Giữ lại các class của PdfBox để tránh bị xóa nhầm
-keep class com.tom_roush.pdfbox.** { *; }
-dontwarn com.tom_roush.pdfbox.**