# Webgains - GTM Web Tag Template

Google Tag Manager web tag template for [Webgains](https://www.webgains.com) affiliate tracking. Supports click detection on all pages and conversion tracking on the order confirmation page.

## Features

- **Click tracking** - Captures affiliate clicks on every page using the Webgains `ITCLKQ` command queue
- **Conversion tracking** - Reports completed orders with full item-level detail using the `ITCVRQ` command queue
- Optional debug logging to the browser console

## Installation

### From the Community Template Gallery

1. In your GTM container, go to **Templates** > **Tag Templates** > **Search Gallery**
2. Search for **Webgains** and click **Add to workspace**

### Manual install

1. Download `template.tpl` from this repository
2. In GTM, go to **Templates** > **Tag Templates** > **New**
3. Click the three-dot menu > **Import**
4. Select the downloaded file

## Setup

You need two tags: one for click tracking on all pages and one for conversion tracking on the order confirmation page.

### Tag 1 - Click tracking (all pages)

| Setting | Value |
|---------|-------|
| Action type | Click tracking (all pages) |
| Program ID | Your Webgains program ID |
| Trigger | All Pages |

### Tag 2 - Conversion tracking (order confirmation)

| Setting | Value |
|---------|-------|
| Action type | Conversion tracking |
| Program ID | Your Webgains program ID |
| Order Reference | `{{Order ID}}` variable |
| Order Value | `{{Order Value}}` variable (ex-VAT) |
| Currency | `EUR` (or your store currency) |
| Event ID | Commission event ID from your Webgains program |
| Items (optional) | A variable returning an array of item objects |
| Trigger | Order confirmation page |

### Items array format

If you provide an items variable, each object in the array should have:

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Product name |
| `price` | string | Product price |
| `code` | string | Product ID / SKU |
| `voucher` | string | (optional) Item-level voucher code |
| `event` | string | (optional) Item-level event ID |

## Field reference

| Field | Required | Description |
|-------|----------|-------------|
| Action type | Yes | Click tracking or Conversion tracking |
| Program ID | Yes | Webgains program ID |
| Order Reference | Yes (conversion) | Unique order number |
| Order Value | Yes (conversion) | Total order value |
| Currency | No | ISO currency code (default: EUR) |
| Event ID | No | Commission type / event ID |
| Voucher Code | No | Coupon or voucher code |
| Items | No | Array of product item objects |
| Language | No | Language code |
| Debug | No | Log debug messages to console |

## Permissions

This template requires the following permissions:

- **Inject script** - Loads the Webgains analytics script from `https://analytics.webgains.io/*`
- **Access globals** - Reads and writes the `ITCLKQ` and `ITCVRQ` command queues
- **Logging** - Debug-level console logging (when enabled)
- **Get URL** - Reads the current page URL for the conversion `location` field

## Resources

- [Webgains default tracking guide](https://knowledgehub.webgains.com/home/webgains-default-tracking-guide)
- [Webgains website](https://www.webgains.com)

## Author

Built by [New North Digital](https://newnorth.digital?utm_source=github&utm_medium=gtm-template&utm_campaign=webgains-web-tag).

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.
