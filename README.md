# Shell Scripting: Solutions & Patterns

This repository contains a collection of over 40 scripts developed as part of the Operating Systems course. The solutions cover a wide range of tasks – from basic automation to complex system information processing.

## 🚀 Key Task Categories
The solutions are organized around the following core areas:
* **File Administration:** Recursive search, directory synchronization, management of permissions and metadata.
* **Text Processing:** Parsing logs, CSV files, and configurations using regular expressions.
* **System Information:** Process monitoring, extracting data about hardware components, and user sessions.
* **Automation:** Bulk file system modifications and report generation.

## 🛠️ Technology Stack
Standard UNIX tools and utilities were used throughout the development:
* **Search:** `find` with complex filters (`-path`, `-type`, `-mmin`).
* **Processing:** `sed`, `awk`, `grep`, `tr`, `cut`.
* **Mathematics:** Bash arithmetic `$((...))` and `bc` for high-precision calculations.
* **Data Structures:** Arrays, loops (`while`, `for`), and conditional constructs.

## 💡 Best Practices & Lessons Learned
Through these 40 tasks, the following principles for writing reliable code were established:
1. **Data Safety:** Utilizing temporary files (`mktemp`) and verifying successful execution before modifying original data.
2. **Scannability & Safety:** Always quoting variables (`"$VAR"`) to prevent errors caused by whitespaces or special characters (`*`, `?`).
3. **Efficiency:** Filtering redundant data (such as editor swap files or hidden system objects) at the search stage.
4. **Silent Execution:** Using flags like `grep -q` for conditional checks to avoid polluting the standard output.

## 📂 How to Use the Scripts
Each script is standalone. Before running, ensure you have the necessary execution permissions:
```bash
chmod +x <script_name>.sh
./<script_name>.sh [arguments]
