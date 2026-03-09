# Nexus - Premium Fintech Banking App 🏦

A stunning, production-ready Flutter fintech app with deep obsidian dark theme and electric lime accents.

## ✨ Features

### 🔐 Authentication
- **4-digit PIN** — Animated dot indicators, shake-on-error, attempt tracking
- **Biometric Auth** — Fingerprint / Face ID via `local_auth`
- Demo PIN: **1234**

### 💳 Cards Management
- Multiple bank card support (Visa, Mastercard)
- Card number toggle (show/hide)
- Freeze card, Change PIN, Tap to Pay, Report Lost
- Add new card flow

### 🏠 Home Dashboard
- Total balance across all cards
- Income vs Expense summary
- Quick actions (Deposit, Withdraw, Transfer, Pay Bills, QR Pay)
- Cards carousel
- Recent transactions

### 💸 Transactions
- **Deposit** — with quick amount chips
- **Withdraw** — method selection (ATM, Bank Counter, Agent)
- **Transfer** — contact picker + note + real-time balance check
- **Pay Bills** — 8 billers (KPLC, Safaricom, DSTV, Nairobi Water, KRA, Airtel, NHIF, NSSF)
- **QR Pay** — My QR Code + Scanner tab

### 📊 Analytics
- Period selector (Week / Month / Year)
- Spending vs Income line chart (fl_chart)
- Pie chart with category breakdown
- Savings Goals with progress bars

### 📋 Transaction History
- Grouped by date (Today, Yesterday, day name, full date)
- Filter: All / Income / Expenses
- Tap for detailed receipt modal

### 👤 Profile
- Verified account badge
- Stats: Transactions, Contacts, Member Since
- Settings: Account, Finance, Support sections
- Sign out → returns to PIN screen

---

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Steps
```bash
cd nexus_app
flutter pub get
flutter run
```

### Build APK
```bash
flutter build apk --release
```

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Background Primary | `#08080D` |
| Background Card | `#13131F` |
| Accent Primary (Lime) | `#CBFF47` |
| Accent Secondary (Violet) | `#7B61FF` |
| Accent Tertiary (Mint) | `#00D4AA` |
| Accent Warn (Coral) | `#FF6B35` |
| Text Primary | `#F0F0F8` |
| Text Secondary | `#8A8AA8` |

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `fl_chart` | Analytics charts |
| `flutter_animate` | Animations |
| `local_auth` | Biometrics |
| `provider` | State management |
| `google_fonts` | DM Sans typography |
| `intl` | Currency & date formatting |
| `pin_code_fields` | PIN input UI |

---

## 🗂 Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── models/
│   ├── models.dart
│   └── dummy_data.dart
├── providers/
│   ├── auth_provider.dart
│   └── app_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── pin_screen.dart
│   ├── deposit_screen.dart
│   ├── withdraw_screen.dart
│   ├── transfer_screen.dart
│   ├── pay_bills_screen.dart
│   ├── success_screen.dart
│   ├── cards_screen.dart
│   ├── analytics_screen.dart
│   ├── transactions_screen.dart
│   ├── qr_screen.dart
│   ├── profile_screen.dart
│   └── home/
│       ├── main_screen.dart
│       └── home_screen.dart
└── widgets/
    ├── bank_card_widget.dart
    └── transaction_tile.dart
```

---

Built with ❤️ using Flutter · Dark Mode · Material 3
# nexus_app
