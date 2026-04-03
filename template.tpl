___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Webgains",
  "categories": ["AFFILIATE_MARKETING", "CONVERSIONS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "New North Digital",
    "thumbnail": ""
  },
  "description": "Webgains affiliate tracking. Click detection on all pages and conversion tracking on order confirmation.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "actionType",
    "displayName": "Action type",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "click", "displayValue": "Click tracking (all pages)"},
      {"value": "conversion", "displayValue": "Conversion tracking"}
    ],
    "simpleValueType": true,
    "help": "Click tracking fires on all pages to capture affiliate clicks. Conversion tracking fires on the order confirmation page."
  },
  {
    "type": "TEXT",
    "name": "programId",
    "displayName": "Program ID",
    "simpleValueType": true,
    "help": "Your Webgains program ID (provided by your account manager).",
    "alwaysInSummary": true,
    "valueValidators": [{"type": "NON_EMPTY"}]
  },
  {
    "type": "TEXT",
    "name": "orderReference",
    "displayName": "Order Reference",
    "simpleValueType": true,
    "help": "Unique order number/reference.",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderValue",
    "displayName": "Order Value",
    "simpleValueType": true,
    "help": "Total order value (ex-VAT if not paying commission on VAT).",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "currency",
    "displayName": "Currency",
    "simpleValueType": true,
    "defaultValue": "EUR",
    "help": "ISO currency code (EUR, GBP, USD, etc.).",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "eventId",
    "displayName": "Event ID",
    "simpleValueType": true,
    "help": "Commission type / event ID from your Webgains program.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "voucherId",
    "displayName": "Voucher Code (optional)",
    "simpleValueType": true,
    "help": "Coupon or voucher code used in the order.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "items",
    "displayName": "Items (optional)",
    "simpleValueType": true,
    "help": "A GTM variable returning an array of item objects. Each object should have: name, price, code (product ID), and optionally voucher and event.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "language",
    "displayName": "Language (optional)",
    "simpleValueType": true,
    "help": "Language code for the conversion.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "GROUP",
    "name": "debugging",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {"type": "CHECKBOX", "name": "debug", "checkboxText": "Log debug messages to console", "simpleValueType": true}
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
var injectScript = require('injectScript');
var createArgumentsQueue = require('createArgumentsQueue');
var makeString = require('makeString');
var getType = require('getType');
var getUrl = require('getUrl');

var enableDebug = data.debug;
var debugLog = function(msg) {
  if (enableDebug) log('Webgains GTM - ' + msg);
};

var programId = makeString(data.programId);
var actionType = data.actionType;
var scriptUrl = 'https://analytics.webgains.io/' + programId + '/main.min.js';

debugLog('Action: ' + actionType + ', Program: ' + programId);

if (actionType === 'click') {
  var ITCLKQ = createArgumentsQueue('ITCLKQ', 'ITCLKQ.q');
  ITCLKQ('set', 'internal.api', true);
  ITCLKQ('set', 'internal.cookie', true);
  ITCLKQ('click');
  debugLog('Click tracking configured');

  injectScript(scriptUrl, function() {
    debugLog('Click script loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('Click script failed to load');
    data.gtmOnFailure();
  }, 'webgains-click-' + programId);

} else if (actionType === 'conversion') {
  var ITCVRQ = createArgumentsQueue('ITCVRQ', 'ITCVRQ.q');

  ITCVRQ('set', 'trk.programId', programId);

  var conversionData = {
    value: makeString(data.orderValue),
    currency: makeString(data.currency || 'EUR'),
    orderReference: makeString(data.orderReference),
    location: getUrl()
  };

  if (data.eventId) conversionData.eventId = makeString(data.eventId);
  if (data.voucherId) conversionData.voucherId = makeString(data.voucherId);
  if (data.language) conversionData.language = makeString(data.language);

  if (data.items && getType(data.items) === 'array') {
    conversionData.items = data.items;
  }

  ITCVRQ('set', 'cvr', conversionData);
  ITCVRQ('conversion');

  debugLog('Conversion configured: ' + conversionData.orderReference);

  injectScript(scriptUrl, function() {
    debugLog('Conversion script loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('Conversion script failed to load');
    data.gtmOnFailure();
  }, 'webgains-cvr-' + programId);

} else {
  debugLog('Unknown action type');
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://analytics.webgains.io/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiVersion": "1"
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
                    "string": "ITCLKQ"
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
              },
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
                    "string": "ITCLKQ.q"
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
              },
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
                    "string": "ITCVRQ"
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
              },
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
                    "string": "ITCVRQ.q"
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
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: "Click tracking loads successfully"
  code: |-
    var mockData = {
      actionType: 'click',
      programId: '12345',
      debug: false
    };

    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {};
    });

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Conversion tracking with order data"
  code: |-
    var mockData = {
      actionType: 'conversion',
      programId: '12345',
      orderReference: 'ORD-001',
      orderValue: '99.95',
      currency: 'EUR',
      eventId: '1001',
      voucherId: '',
      language: 'nl',
      debug: false
    };

    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {};
    });

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    mock('getUrl', function() {
      return 'https://example.com/thank-you';
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Conversion with items array"
  code: |-
    var mockData = {
      actionType: 'conversion',
      programId: '12345',
      orderReference: 'ORD-002',
      orderValue: '149.90',
      currency: 'EUR',
      eventId: '1001',
      voucherId: 'SAVE10',
      language: 'en',
      items: [
        {name: 'Product A', price: '49.95', code: 'SKU-A', voucher: '', event: ''},
        {name: 'Product B', price: '99.95', code: 'SKU-B', voucher: '', event: ''}
      ],
      debug: true
    };

    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {};
    });

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    mock('getUrl', function() {
      return 'https://example.com/thank-you';
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Script failure calls gtmOnFailure"
  code: |-
    var mockData = {
      actionType: 'click',
      programId: '12345',
      debug: false
    };

    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {};
    });

    mock('injectScript', function(url, success, failure, token) {
      failure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created on 4/1/2026, by New North Digital.
