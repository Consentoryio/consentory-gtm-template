# Consentory CMP – Consent Mode v2

Loads the [Consentory](https://consentory.io) cookie banner and communicates visitor choices to Google Tag Manager using the native Consent Mode v2 APIs.

## Requirements

- A Consentory account with a published website configuration and its 24-character site token.
- The Consentory widget release supporting `window.ConsentoryGtmBridge` must be deployed before this template is used. Older widgets only emit queued gtag commands and are not supported.
- One Consentory tag and one web GTM container per page. Remove earlier Custom HTML, manual, CMS and template installations of Consentory before enabling this tag.

## Installation

1. Import `template.tpl` into **Templates → Tag Templates → New → Import** until this template is available in the gallery.
2. Create a tag with this template and paste the site token from your Consentory installation snippet. Paste the token alone, not the script URL.
3. Set the trigger to **Consent Initialization – All Pages** and tag firing to **Once per page**. Do not require optional consent for this CMP tag.
4. Preview and validate the states below before publishing the container.

[Installation guide](https://consentory.io/knowledge-base/google-consent-mode-v2-gtm-setup).

## Consent signals

Defaults are set synchronously before requesting the widget. All optional signals are denied globally; `security_storage` is granted. The initial wait for the asynchronous update is 500 ms. This wait is not a timeout for collecting consent and does not grant consent when it expires.

| Consentory category | Google signals |
| --- | --- |
| Analytics or performance | `analytics_storage` |
| Advertising | `ad_storage`, `ad_user_data`, `ad_personalization` |
| Functional | `functionality_storage` |
| Advertising or functional | `personalization_storage` |
| Always enabled | `security_storage` |

Valid saved decisions are restored by the widget after it checks configuration version and expiry. New choices, granular changes and withdrawals use `updateConsentState` before the widget emits `cookie_consent_update`. Missing or malformed optional signal values are denied. The template does not read consent storage itself.

Consentory's configured opt-out mode can update initial denied states to the applicable defaults after configuration is loaded. Review that site setting if your installation requires opt-in everywhere.

## Tag behavior

This template signals consent and loads the banner. Configure third-party tags with the appropriate additional consent checks and triggers. Consent Mode alone does not block every network request: Google tags in advanced mode may send cookieless pings while storage is denied. For basic mode, gate measurement tags until consent. A widget loaded through GTM cannot prevent trackers that ran before the container; remove or gate those trackers separately.

## Permissions

- Inject only `https://consentory.io/api/embed/v2/*.js`.
- Write the seven consent signals listed above; no consent read permission.
- Read and write only `ConsentoryGtmBridge` to register the callback used by the widget.

The downloaded widget handles banner rendering, saved choices and consent evidence under the site's published Consentory configuration. Inspect those settings and the site's privacy notice before rollout.

## Validation before release

Run embedded template tests in the GTM editor, then use Preview/Tag Assistant on a test site:

- Fresh visit: optional signals denied before measurement tags run.
- Accept all: optional configured purposes granted.
- Reject all: optional signals denied.
- Analytics only: analytics granted; advertising denied.
- Withdrawal through Privacy choices: previously granted optional signals denied.
- Reload with a valid decision: restore only its allowed purposes.
- Expired or obsolete decision: keep optional signals denied and show the banner.
- Block the widget request: defaults remain denied; the tag reports failure.
- Confirm there are no duplicate banners or queued `gtag('consent', …)` commands from this installation.

## Support and maintenance

Report template defects through this repository's **Issues**. Contact [info@consentory.io](mailto:info@consentory.io) for account support. Do not include private site configuration or visitor data in public issues.

The Consentory team maintains this template. For each release, repeat automated and GTM browser checks, commit `template.tpl`, then add that commit's full SHA and release notes to the top of `metadata.yaml`. Keep previous versions. The template is distributed under Apache License 2.0; this license covers this template package, not the hosted Consentory service.
