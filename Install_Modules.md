# Installing Custom vtiger Modules (Fresh Install)

This guide explains how to install custom modules on a **fresh vtiger installation**
so that modules, menus, fields, and UI appear correctly.

> ⚠️ Important  
> Database schema alone is **NOT enough**.  
> vtiger requires **module registration via vtlib**.

---

## Prerequisites

- Fresh vtiger installed and working
- Custom module **code present** in the filesystem
- PHP CLI access
- Database credentials configured in `.env`

---

## 1. Install Bank Account module
- Visit site_url/BankAccount.php 

## 2. Install Company module
- Visit site_url/GPMCompany.php 

## 3. Install HoldingCertificate module
- Visit site_url/HoldingCertificate.php 

## 4. Install MetalPrice module
- Visit site_url/MetalPrice.php 

## 5. Install Intent module
- Visit site_url/Install_GPMIntent.php 

## 6. Install dashboard widgets
- Visit site_url/install_widgets.php
- Safe to run more than once — already-installed widgets are detected and skipped

---

## Installer script conventions

Every PHP installer in this project (e.g. `Install_GPMIntent.php`, `install_widgets.php`) **must** start with:

```php
$Vtiger_Utils_Log = true;
require_once __DIR__ . '/vendor/autoload.php';
```

`vendor/autoload.php` loads Composer dependencies (including `.env` support) and must be the **first** `require_once` before `config.inc.php` or vtiger includes.

Installers should also be **idempotent**: check whether the module, field, or widget already exists before creating it, and print a clear skip message on subsequent runs.



