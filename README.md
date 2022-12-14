# kain
Kain is a metadata parser for eml files. The utility allows quick querying of SPF, DMARC, DKIM, source IP and addresses for forensic analysis. Note that the syntax of eml files depends on the email service they were exported from. Kain currently supports Outlook, Gmail, Zimbra and Proton syntax and may have issues with files from other sources. Also, this is an early version and may have errors.

Usage:`./kain.sh [service] [file.eml] `

So far you can use the following services: `outlook` | `gmail` | `zimbra*` | `proton`\`

*\* partial.*

**TO DO:** Identify and export attachments; include support for other email services;
