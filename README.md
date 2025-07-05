# 🛡️ Windows Update Controller

This PowerShell script allows you to **disable** or **re-enable** Windows Update quickly and effectively by controlling services, editing the registry, and applying firewall rules. Ideal for users who want to stop automatic updates on Windows 10/11.

## 📋 Features

- ✅ Disable the Windows Update service
- 🔒 Block access to Windows Update servers via firewall
- 🛑 Turn off automatic updates via registry settings
- 🔁 Re-enable all settings with one click
- 🖥️ Interactive command-line menu

## 🧰 How to Use

1. **Open PowerShell** as Administrator
2. **Run the script**:
   ```powershell
   .\MyFirewall.ps1
   ```


3. **Select an option from the menu:**

   ```
   1. Disable Windows Update
   2. Enable Windows Update
   0. Exit
   ```

## ⚠️ Notes

* The script **must be run with Administrator privileges**
* Some changes may require a **system restart**
* Make sure no conflicting Group Policy settings are applied

## 🧾 Script Structure

* `Disable-WindowsUpdate` – Stops services & blocks update access
* `Enable-WindowsUpdate` – Restores update functionality
* `Show-Menu` – Interactive CLI interface for selecting actions

## 🛠️ Sample Output

```
========== Windows Update Controller ==========
1. Disable Windows Update
2. Enable Windows Update
0. Exit
===============================================
Enter your choice:
```

## 📄 License

This project is licensed under the MIT License – feel free to use and modify it as needed.


