export const khatmaControllerSwagger = {

  paths: {
    "/khatma": {
      "post": {
        "summary": "Create a new Khatma",
        "description": "Creates a new Khatma with the given details.",
        "tags": [
          "Khatma"
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "reciterId",
                  "name",
                  "khatmaType"
                ],
                "properties": {
                  "reciterId": {
                    "type": "number",
                    "description": "ID of the reciter."
                  },
                  "name": {
                    "type": "object",
                    "description": "Localized name of the Khatma.",
                    "properties": {
                      "en": {
                        "type": "string",
                        "description": "English name."
                      },
                      "ar": {
                        "type": "string",
                        "description": "Arabic name."
                      }
                    }
                  },
                  "khatmaType": {
                    "type": "number",
                    "description": "Type of the Khatma. for example Hafs or Shoaba recitation."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Successfully created new Khatma.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "items": {
                      "type": "array",
                      "items": {
                        $ref: "#/components/schemas/KhatmaFullRes",

                      }
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "Bad request, reciterId, khatmaType or name are missing or invalid.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "404": {
            "description": "Khatma not found for the given ID.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Internal server error.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      },
      "get": {
        "summary": "Retrieve a list of Khatmat",
        "description": "Retrieve a paginated list of Khatma with optional filtering by reciter ID.",
        "tags": [
          "Khatma"
        ],
        "parameters": [
          { "$ref": "#/components/parameters/PageParam" },
          { "$ref": "#/components/parameters/LimitParam" },
          {
            "in": "query",
            "name": "reciterId",
            "schema": {
              "type": "integer"
            },
            "required": false,
            "description": "ID of the reciter to filter the Khatmat"
          }
        ],
        "responses": {
          "200": {
            "description": "A list of Khatmat.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "items": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/KhatmaResumedRes"
                      }
                    }
                  }
                }
              }
            }
          },
          "500": {
            "description": "Internal server error.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      }
    },
    "/khatma/{khatmaId}": {
      "get": {
        "summary": "Retrieve a specific Khatma by ID",
        "description": "Retrieve detailed information about a specific Khatma using its ID.",
        "tags": ["Khatma"],
        "parameters": [
          {
            "in": "path",
            "name": "khatmaId",
            "schema": {
              "type": "integer"
            },
            "required": true,
            "description": "The ID of the Khatma to retrieve"
          }
        ],
        "responses": {
          "200": {
            "description": "Detailed information about the Khatma.",
            "content": {
              "application/json": {
                "schema": {
                  $ref: "#/components/schemas/KhatmaFullRes",
                }
              }
            }
          },
          "400": {
            "description": "Bad request, khatmaId is missing or invalid.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "404": {
            "description": "Khatma not found for the given ID.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Internal server error.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      }
    }
  },
  components: {
    schemas: {
      KhatmaFullRes: {
        "allOf": [
          {
            "$ref": "#/components/schemas/KhatmaResumedRes"
          },
          {
            "type": "object",
            "properties": {
              "totalDownloads": {
                "type": "integer",
                "nullable": true,
                "description": "Total number of downloads for the Khatma."
              },
              "totalPlays": {
                "type": "integer",
                "nullable": true,
                "description": "Total number of plays for the Khatma."
              }
            }
          }
        ]
      },
      KhatmaResumedRes: {
        "type": "object",
        "properties": {
          "id": {
            "type": "integer",
            "nullable": true,
            "description": "ID of the Khatma."
          },
          "name": {
            "$ref": "#/components/schemas/LocalizedEntity"
          },
          "reciter": {
            "type": "object",
            "properties": {
              "name": {
                "$ref": "#/components/schemas/LocalizedEntity"
              },
              "id": {
                "type": "integer",
                "nullable": true
              },
              "image": {
                "type": "string",
                "nullable": true,
                "format": "uri",
                "description": "URL of the reciter's image."
              }
            }
          }
        }
      },
    }
  },
};

