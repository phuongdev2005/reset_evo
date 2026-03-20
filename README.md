# 🔄 Evoto Multi-Account Tool Suite

Dùng **nhiều account Evoto** trên cùng 1 máy, không cần cài đi cài lại.

---

## 🚀 Cách sử dụng

### Lần đầu (chạy 1 lần):

```bash
# Xóa sạch Evoto cũ + Cài mới + Chụp snapshot (tất cả trong 1 lệnh)
setup.bat
```

> Script sẽ tự mở Evoto → bạn chờ load xong → **KHÔNG đăng nhập** → đóng Evoto → bấm phím tiếp tục.

### Sử dụng hàng ngày:

```bash
# Đăng nhập account → dùng xong → đổi account:
reset.bat
```

> ⚡ Reset ~1 giây + tự đổi MachineGuid → Evoto nghĩ máy mới!

---

## 📁 File

| File | Chức năng | Khi nào |
|---|---|---|
| `setup.bat` | Xóa cũ + Cài + Snapshot | 1 lần |
| `reset.bat` | Reset + đổi GUID + mở Evoto | Mỗi khi đổi account |

---

## 🔄 Cập nhật phiên bản mới

```bash
# Thay file EvotoInstaller_xxx.exe mới, xóa cũ, chạy lại:
setup.bat
```
