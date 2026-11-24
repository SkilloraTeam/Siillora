# Siillora — Student Freelance & Service Marketplace

![Flutter](https://shields.io)
![Supabase](https://shields.io)
![Dart](https://shields.io)
![License](https://shields.io)

**Siillora** is a mobile-based service marketplace designed specifically for university students. It connects students who need academic, technical, or creative assistance with skilled student freelancers—featuring end-to-end order tracking, direct QRIS payment proof verification, built-in real-time chat, and structured revision workflows.

---

## Key Features

### 1. Client Mode (User Role)
* **Service Catalog & Search:** Browse and search student services complete with ratings, descriptions, and pricing.
* **Detailed Service View & Portfolio:** Inspect freelancer portfolios (PDF documents or external website links) before placing an order.
* **Custom Order Submission:** Define project requirements, set target deadlines, and upload supporting task materials.
* **Direct QRIS Payment & Receipt Upload:** Pay directly via the freelancer's QRIS and upload transfer proof (`png`/`jpg`) once an order is accepted.
* **Real-Time Order Tracking & Revision System:** Track order progress (`Ditinjau` ➔ `Dikerjakan` ➔ `Revisi` ➔ `Selesai`), download deliverables, submit reviews, or request revisions via user-to-user chat.

### 2. Freelancer Mode (Service Provider Role)
* **Dual-Role Switching:** Seamlessly switch between Client Mode and Service Provider Mode within a single student account.
* **Seller Performance Dashboard:** Monitor monthly earnings (auto-calculated from completed orders), active orders, and average store ratings.
* **Service & Portfolio Management:** Publish, edit, and manage offered services with custom pricing, banners, and portfolio attachments.
* **Order & Payment Verification Management:** Review incoming requests (`Perlu Ditinjau`), verify uploaded QRIS payment receipts (`Pembayaran Perlu Dicek`), manage active/revision tasks, and deliver final files.
* **Earnings & Transaction History:** Track accumulated revenue from completed orders and manage receiving QRIS/account details.

---

## Repository Structure & Documentation

```text
Siillora/
├── documents/                        # Product & Engineering Documentation
│   ├── PRD.md                        # Product Requirement Document & SRS
│   ├── panduan-git-skillora.md       # Git & Pull Request Workflow Guide
│   └── Technical-Execution-Plan.md   # Sprint Backlog & Task Allocation
└── skillora/                         # Flutter Mobile Application Source Code
```

* [`documents/panduan-git-skillora.md`](documents/panduan-git-skillora.md) — Standar alur kerja Git, penamaan branch, dan pengajuan Pull Request tim.

---

## Getting Started (For Developers)

1. **Clone the organization repository:**
   ```bash
   git clone https://github.com/Siillora.git
   cd Siillora/skillora
   ```

2. **Switch to the `dev` branch before creating a feature branch:**
   ```bash
   git checkout dev
   git pull origin dev
   ```

3. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

4. **Environment Setup:**
   * Create a `.env` file inside the `skillora/` directory.
   * Add your Supabase project credentials (`SUPABASE_URL` and `SUPABASE_ANON_KEY`). *(Note: Never commit the `.env` file to version control).*

5. **Run the application:**
   ```bash
   flutter run
   ```

---

## Workflow & Contribution Guidelines
* **Branch Hierarchy:**
  * `main` — Protected production branch (requires Product Lead/QC approval).
  * `dev` — Integration and staging branch for combining completed features.
  * `fitur-<nama-fitur>` — Individual feature branches created from `dev` (e.g., `fitur-katalog-jasa`, `fitur-pesanan-masuk`).
* **Pull Request Rules:**
  * Direct pushes to `main` are blocked.
  * Submit all Pull Requests targeting **`dev`** (`base: dev` ➔ `compare: fitur-<nama-fitur>`) for code review and functional QA testing by `@nazrilka`.
