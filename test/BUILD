load("//openapi:openapi.bzl", "openapi_gen")

openapi_gen(
    name = "petstore",
    language = "go",
    spec = "petstore.yaml",
)

openapi_gen(
    name = "petstore_java",
    language = "java",
    spec = "petstore.yaml",
)

openapi_gen(
    name = "petstore_java_feign",
    additional_properties = {
        "library": "feign",
    },
    language = "java",
    spec = "petstore.yaml",
)

openapi_gen(
    name = "petstore_java_no_tests",
    language = "java",
    spec = "petstore.yaml",
    system_properties = {
        "apiTests": "false",
        "modelTests": "false",
    },
)

openapi_gen(
    name = "petstore_java_bigdecimal",
    language = "java",
    spec = "petstore.yaml",
    type_mappings = {
        "Integer": "java.math.BigDecimal",
    },
)

openapi_gen(
    name = "petstore_scala_openapi_5",
    language = "scala-sttp",
    spec = "petstore.yaml",
    codegen_cli = "//external:io_bazel_rules_openapi_openapi_5/dependency/openapi-cli",
    additional_properties = {
        "jsonLibrary": "circe",
        "sttpClientVersion": "2.2.0"
    },
)

openapi_gen(
    name = "petstore_scala_openapi_4",
    language = "scala-sttp",
    spec = "petstore.yaml",
    codegen_cli = "//external:io_bazel_rules_openapi_openapi_4/dependency/openapi-cli",
    additional_properties = {
        "jsonLibrary": "circe",
        "sttpClientVersion": "2.2.0"
    },
)