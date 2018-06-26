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
