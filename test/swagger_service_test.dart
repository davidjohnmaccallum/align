import 'dart:convert';

import 'package:align/services/swagger_service.dart';
import 'package:test/test.dart';

void main() {
  test('Swagger to markdown', () async {
    var swagger = SwaggerService();
    expect(swagger.toMarkdown(jsonDecode('''{
  "swagger" : "2.0",
  "info" : {
    "version" : "beta",
    "title" : "",
    "contact" : {
      "name" : ""
    },
    "license" : {
      "name" : "",
      "url" : "http://licenseUrl"
    }
  },
  "host" : "localhost:9000",
  "basePath" : "/",
  "tags" : [ {
    "name" : "Order Injection"
  }, {
    "name" : "Health"
  } ],
  "paths" : {
    "/api/mirror-tal-xch/{oldId}" : {
      "post" : {
        "tags" : [ "Order Injection" ],
        "operationId" : "mirrorTalXch",
        "parameters" : [ {
          "name" : "oldId",
          "in" : "path",
          "required" : true,
          "type" : "integer",
          "format" : "int64"
        } ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "headers" : { },
            "schema" : {
              "\$ref" : "#/definitions/ActionJsValue"
            }
          }
        }
      }
    },
    "/api/tal-xch-mdx-to-options" : {
      "post" : {
        "tags" : [ "Order Injection" ],
        "summary" : "Persist MDX to Option ID links for TAL XCHs",
        "description" : "Please note that this endpoint is only be be used in the interim while TAL exchanges are not being handleddirectly by this service.",
        "operationId" : "persistTalXchMdxOptionLinks",
        "parameters" : [ {
          "in" : "body",
          "name" : "body",
          "description" : "Details about the exchange waybill and options",
          "required" : true,
          "schema" : {
            "\$ref" : "#/definitions/TalXchMdxOptionDetails"
          }
        } ],
        "responses" : {
          "200" : {
            "description" : "Success"
          },
          "404" : {
            "description" : "The return leg for the exchange was not found"
          },
          "500" : {
            "description" : "Something went wrong"
          }
        }
      }
    },
    "/api/find-option-ids-by-mdx/{mdx}" : {
      "get" : {
        "tags" : [ "Order Injection" ],
        "summary" : "Get the associated option id with the given mdx number.",
        "description" : "",
        "operationId" : "findOptionIdByMdx",
        "parameters" : [ {
          "name" : "mdx",
          "in" : "path",
          "description" : "MDX Number",
          "required" : true,
          "type" : "string",
          "x-example" : "MDX27499405"
        } ],
        "responses" : {
          "200" : {
            "description" : "",
            "schema" : {
              "type" : "array",
              "items" : {
                "type" : "integer",
                "format" : "int64"
              }
            }
          }
        }
      }
    },
    "/api/inject" : {
      "post" : {
        "tags" : [ "Order Injection" ],
        "summary" : "Inject an order into Express",
        "description" : "",
        "operationId" : "inject",
        "parameters" : [ {
          "in" : "body",
          "name" : "body",
          "description" : "Specify an order injection",
          "required" : true,
          "schema" : {
            "\$ref" : "#/definitions/OrderInjectionPayload"
          }
        } ],
        "responses" : {
          "200" : {
            "description" : "Injection Success",
            "schema" : {
              "\$ref" : "#/definitions/ExpressInjectionResponse"
            }
          },
          "409" : {
            "description" : "Duplicate injection detected!"
          }
        }
      }
    },
    "/api/ready" : {
      "get" : {
        "tags" : [ "Health" ],
        "summary" : "Readiness Check",
        "description" : "",
        "operationId" : "ready",
        "parameters" : [ ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "schema" : {
              "\$ref" : "#/definitions/ActionAnyContent"
            }
          }
        }
      }
    },
    "/api/health" : {
      "get" : {
        "tags" : [ "Health" ],
        "summary" : "Health Check",
        "description" : "",
        "operationId" : "ping",
        "parameters" : [ ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "schema" : {
              "\$ref" : "#/definitions/ActionAnyContent"
            }
          }
        }
      }
    }
  },
  "definitions" : {
    "Action" : {
      "type" : "object"
    },
    "ActionJsValue" : {
      "type" : "object"
    },
    "TalXchMdxOptionDetails" : {
      "type" : "object",
      "required" : [ "deliveryLegMdx", "deliveryLegOptionId", "returnLegOptionId" ],
      "properties" : {
        "deliveryLegMdx" : {
          "type" : "integer",
          "format" : "int64",
          "example" : 27499405
        },
        "deliveryLegOptionId" : {
          "type" : "integer",
          "format" : "int64",
          "example" : 1003346144
        },
        "returnLegOptionId" : {
          "type" : "integer",
          "format" : "int64",
          "example" : 1003346145
        }
      }
    },
    "ActionAnyContent" : {
      "type" : "object"
    },
    "OrderInjectionResponse" : {
      "type" : "object",
      "required" : [ "status" ],
      "properties" : {
        "status" : {
          "type" : "string"
        }
      }
    },
    "ExpressInjectionResponse" : {
      "type" : "object",
      "required" : [ "errors", "mrdxid", "processtime", "result" ],
      "properties" : {
        "result" : {
          "type" : "string"
        },
        "supplier_code" : {
          "type" : "string"
        },
        "errors" : {
          "type" : "array",
          "items" : {
            "type" : "string"
          }
        },
        "mrdxid" : {
          "type" : "integer",
          "format" : "int64"
        },
        "processtime" : {
          "type" : "integer",
          "format" : "int64"
        },
        "rawresult" : {
          "\$ref" : "#/definitions/JsValue"
        },
        "pmdx" : {
          "type" : "string"
        },
        "mdx" : {
          "type" : "string"
        },
        "waybill" : {
          "type" : "object"
        },
        "area" : {
          "type" : "string"
        },
        "duplicate" : {
          "type" : "object"
        },
        "courier" : {
          "type" : "string"
        },
        "v2" : {
          "type" : "object"
        }
      }
    },
    "JsValue" : {
      "type" : "object"
    },
    "Customer" : {
      "type" : "object",
      "required" : [ "email", "first_name", "last_name" ],
      "properties" : {
        "first_name" : {
          "type" : "string"
        },
        "last_name" : {
          "type" : "string"
        },
        "title" : {
          "type" : "string"
        },
        "id_number" : {
          "type" : "string"
        },
        "telno1" : {
          "type" : "string"
        },
        "telno2" : {
          "type" : "string"
        },
        "telno3" : {
          "type" : "string"
        },
        "email" : {
          "type" : "string"
        }
      }
    },
    "Label" : {
      "type" : "object",
      "required" : [ "company", "contactTelNumber", "courier", "hubCode", "hubName", "id", "mdx", "notes", "payment", "serviceName", "serviceType", "sortArea", "verifyId" ],
      "properties" : {
        "id" : {
          "type" : "integer",
          "format" : "int64"
        },
        "courier" : {
          "type" : "string"
        },
        "payment" : {
          "type" : "string"
        },
        "serviceType" : {
          "type" : "string"
        },
        "serviceName" : {
          "type" : "string"
        },
        "company" : {
          "type" : "string"
        },
        "hubCode" : {
          "type" : "string"
        },
        "hubName" : {
          "type" : "string"
        },
        "mdx" : {
          "type" : "string"
        },
        "verifyId" : {
          "type" : "boolean"
        },
        "notes" : {
          "type" : "string"
        },
        "contactTelNumber" : {
          "type" : "string"
        },
        "sortArea" : {
          "type" : "string"
        },
        "area" : {
          "type" : "string"
        }
      }
    },
    "OrderInjectionPayload" : {
      "type" : "object",
      "required" : [ "clientRef", "customer", "shipments" ],
      "properties" : {
        "note" : {
          "type" : "string"
        },
        "returnReason" : {
          "type" : "string"
        },
        "returnDescription" : {
          "type" : "string"
        },
        "returnReasons" : {
          "type" : "array",
          "items" : {
            "\$ref" : "#/definitions/ReturnReasonData"
          }
        },
        "clientRef" : {
          "type" : "string"
        },
        "originalClientRef" : {
          "type" : "string"
        },
        "customer" : {
          "\$ref" : "#/definitions/Customer"
        },
        "recipient" : {
          "\$ref" : "#/definitions/Recipient"
        },
        "shipments" : {
          "type" : "array",
          "items" : {
            "\$ref" : "#/definitions/Shipment"
          }
        },
        "source" : {
          "\$ref" : "#/definitions/Source"
        },
        "injectedAsCOD" : {
          "type" : "object"
        },
        "duplicateMrrnItemId" : {
          "type" : "object"
        }
      }
    },
    "Recipient" : {
      "type" : "object",
      "required" : [ "first_name", "last_name", "telno1" ],
      "properties" : {
        "first_name" : {
          "type" : "string"
        },
        "last_name" : {
          "type" : "string"
        },
        "telno1" : {
          "type" : "string"
        }
      }
    },
    "ReturnReasonData" : {
      "type" : "object",
      "required" : [ "returnItemId" ],
      "properties" : {
        "returnItemId" : {
          "type" : "integer",
          "format" : "int64"
        },
        "reason" : {
          "type" : "string"
        },
        "title" : {
          "type" : "string"
        },
        "quantity" : {
          "type" : "object"
        }
      }
    },
    "Shipment" : {
      "type" : "object",
      "required" : [ "id", "optionId" ],
      "properties" : {
        "id" : {
          "type" : "integer",
          "format" : "int64"
        },
        "optionId" : {
          "type" : "integer",
          "format" : "int64"
        },
        "expectedDate" : {
          "type" : "object"
        },
        "mdx" : {
          "type" : "string"
        },
        "label" : {
          "\$ref" : "#/definitions/Label"
        },
        "waveCourier" : {
          "type" : "string"
        },
        "sortArea" : {
          "type" : "string"
        }
      }
    },
    "Source" : {
      "type" : "object",
      "required" : [ "source_collection_region", "source_contact", "source_id", "source_location_id", "source_name", "source_telno" ],
      "properties" : {
        "source_contact" : {
          "type" : "string"
        },
        "source_telno" : {
          "type" : "string"
        },
        "source_name" : {
          "type" : "string"
        },
        "source_id" : {
          "type" : "integer",
          "format" : "int32"
        },
        "source_collection_region" : {
          "type" : "string"
        },
        "source_location_id" : {
          "type" : "integer",
          "format" : "int32"
        }
      }
    }
  }
}''')), '''### POST /api/mirror-tal-xch/{oldId}

| Response | Description |
| --- | --- |
| 200 | successful operation |

### POST /api/tal-xch-mdx-to-options

Persist MDX to Option ID links for TAL XCHs

Please note that this endpoint is only be be used in the interim while TAL exchanges are not being handleddirectly by this service.

| Response | Description |
| --- | --- |
| 200 | Success |
| 404 | The return leg for the exchange was not found |
| 500 | Something went wrong |

### GET /api/find-option-ids-by-mdx/{mdx}

Get the associated option id with the given mdx number.

| Response | Description |
| --- | --- |
| 200 |  |

### POST /api/inject

Inject an order into Express

| Response | Description |
| --- | --- |
| 200 | Injection Success |
| 409 | Duplicate injection detected! |

### GET /api/ready

Readiness Check

| Response | Description |
| --- | --- |
| 200 | successful operation |

### GET /api/health

Health Check

| Response | Description |
| --- | --- |
| 200 | successful operation |

''');
  });
}
