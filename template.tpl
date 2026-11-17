___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Consentory CMP – Consent Mode v2",
  "categories": [
    "TAG_MANAGEMENT",
    "UTILITY"
  ],
  "brand": {
    "displayName": "Consentory"
  },
  "description": "Loads the Consentory cookie banner and manages Google Consent Mode v2. Setup and support: https://consentory.io/knowledge-base/google-consent-mode-v2-gtm-setup",
  "containerContexts": [
    "WEB"
  ]
}

___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "scriptToken",
    "displayName": "Consentory site token",
    "simpleValueType": true,
    "help": "Paste the 24-character site token from your Consentory installation snippet. Use Consent Initialization – All Pages and remove any other Consentory installation.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const setInWindow = require('setInWindow');
const copyFromWindow = require('copyFromWindow');
const getType = require('getType');

const existing = copyFromWindow('ConsentoryGtmBridge');
if (existing) {
  if (existing.token === data.scriptToken) data.gtmOnSuccess();
  else data.gtmOnFailure();
  return;
}

// Defaults take effect before the asynchronous banner request.
setDefaultConsentState({
  ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied',
  analytics_storage: 'denied', functionality_storage: 'denied',
  personalization_storage: 'denied', security_storage: 'granted',
  wait_for_update: 500
});

const token = data.scriptToken;
if (getType(token) !== 'string' || token.length !== 24 ||
    !token.split('').every(c => '0123456789abcdef'.indexOf(c) !== -1)) {
  data.gtmOnFailure();
  return;
}

const update = (payload) => {
  if (!payload) return;
  // Only literal grants are accepted; missing or malformed signals are denied.
  const consent = {};
  ["ad_storage","ad_user_data","ad_personalization","analytics_storage","functionality_storage","personalization_storage","security_storage"].forEach(key => {
    consent[key] = payload[key] === 'granted' ? 'granted' : 'denied';
  });
  consent.security_storage = 'granted';
  updateConsentState(consent);
};

if (!setInWindow('ConsentoryGtmBridge', { token: token, update: update })) {
  data.gtmOnFailure();
  return;
}
const url = "https://consentory.io/api/embed/v2/" + token + '.js';
injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, url);

___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://consentory.io/api/embed/v2/*.js"
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ConsentoryGtmBridge"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  }
]

___TESTS___

scenarios:
- name: Sets conservative defaults before loading the banner
  code: |-
    mock('copyFromWindow', () => undefined);
    mock('setInWindow', () => true);
    mock('injectScript', (url, success) => success());
    runCode({scriptToken: '0123456789abcdef01234567'});
    assertApi('setDefaultConsentState').wasCalledWith({ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied', analytics_storage: 'denied', functionality_storage: 'denied', personalization_storage: 'denied', security_storage: 'granted', wait_for_update: 500});
    assertApi('gtmOnSuccess').wasCalled();
- name: Rejects a URL instead of a site token
  code: |-
    mock('copyFromWindow', () => undefined);
    runCode({scriptToken: 'https://example.com/script.js'});
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
- name: Uses native consent updates and denies unspecified purposes
  code: |-
    mock('copyFromWindow', () => undefined);
    mock('setInWindow', (key, bridge) => { bridge.update({analytics_storage: 'granted', ad_storage: true}); return true; });
    runCode({scriptToken: '0123456789abcdef01234567'});
    assertApi('updateConsentState').wasCalledWith({ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied', analytics_storage: 'granted', functionality_storage: 'denied', personalization_storage: 'denied', security_storage: 'granted'});
- name: Reports script load failures
  code: |-
    mock('copyFromWindow', () => undefined);
    mock('setInWindow', () => true);
    mock('injectScript', (url, success, failure) => failure());
    runCode({scriptToken: '0123456789abcdef01234567'});
    assertApi('gtmOnFailure').wasCalled();

___NOTES___

Use Consent Initialization - All Pages. Requires the Consentory GTM bridge release. See README.md for validation and maintenance.
