# OpenAPI rules for Bazel <!-- omit in toc -->

[![Workflow Status](https://github.com/meetup/rules_openapi/workflows/Main/badge.svg)](https://github.com/meetup/rules_openapi/actions)

> [Bazel](https://bazel.build/) rules for generating sources and libraries from [openapi](https://www.openapis.org/) schemas.

- [Rules](#rules)
- [Getting started](#getting-started)
- [Bazel compatibility matrix](#bazel-compatibility-matrix)
- [OpenAPI generator](#openapi-generator)
- [openapi_gen](#openapi_gen)

## Rules

* [openapi_gen](#openapi_gen)

## Getting started

To use the OpenAPI rules, add the following to your projects `WORKSPACE` file

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

RULES_OPEN_API_COMMIT = "f0f42afb855139ad5346659d089c32fb756d068e" # see compatibility matrix
RULES_OPEN_API_SHA256 = "9570186948f1f65c61d2c6c6006840ea70888b270f028bbd0eb736caae1cd9df" # see compatibility matrix

http_archive(
    name = "io_bazel_rules_openapi",
    strip_prefix = "rules_openapi-%s" % RULES_OPEN_API_COMMIT,
    url = "https://github.com/meetup/rules_openapi/archive/%s.tar.gz" % RULES_OPEN_API_COMMIT,
    sha256 = RULES_OPEN_API_SHA256
)

load("@io_bazel_rules_openapi//openapi:openapi.bzl", "openapi_repositories")
openapi_repositories()
```

Then in your `BUILD` file, just add the following so the rules will be available:

```python
load("@io_bazel_rules_openapi//openapi:openapi.bzl", "openapi_gen")
```

## Bazel compatibility matrix

| Bazel version | rules_openapi commit                     | sha256 hash                                                      |
| ------------- | ---------------------------------------- | ---------------------------------------------------------------- |
| 1.2.1         | 32527fd4f9b4a50199b3905d34027b1eaf61b88a | 700feae8dda1a6400672c77e0b2bc2d5db9a21b902c20b342d65bb314af953f3 |
| 2.0.0         | c6e77e314df7ced9652bc68f3ee32d5425160716 | ba55fbd75a50eb8e2fd08d4dc72a8f32858bc14db184677cee969453d72d7c67 |
| 2.1.0         | c289e0b4e127924e2a18bc8f345b6cf1945735de | f88a6627533d2974385b36ce1f3606795cd08070e28e5e44074ed2101afdd348 |
| 2.1.1         | 4e35a7b968908213e3c6eedc4435d140dbb577b3 | d1af6e9bd23b24a07f059b1a97f0bc305d7cf74a2965f06fc11c182d568a0e1c |
| 2.2.0         | 08e2472385e8929a21bf8cd747f26e3b933dbd2f | 9dfeeb8cef2347b5ba3d59b7948fd26518eefc537ca95d4846d6c124e38d294a |
| 3.0.0         | 2528ecbfe628211de87e1924908350014fb0d03e | d4c5b924f0a2a7d844650ff3b76c0475f370e5ceb5b1811665144102e7296383 |
| 3.6.0         | 112663e9935f4711c7c14c3357f8e4547d43cd8c | cf32217fda600e49848cd9b496a2e77e50d695230f437f8d5a2f0f2f5d437338 |
| 3.7.0         | f0f42afb855139ad5346659d089c32fb756d068e | 9570186948f1f65c61d2c6c6006840ea70888b270f028bbd0eb736caae1cd9df |
| 3.7.1         | 896323d32a19078e83a70513077554a6529b18b7 | dca86aea8e76ae891bedf42dbb91a7d4b573efc7142cb6049d6b061768c43701 |
| 4.0.0         | d39cf5731254bbf6ef973228bb6f5f4050aa7e60 | 264808b5fa537806fe78ac67a41cb6e0b14e63e67981b3058c5a6758675e7e4f |
| 4.1.0         | 89882964f041a9d11bdc48299defdd500e3e1995 | 89ab3a0c8190d5c88c3bd19d16585153b4ce5aba3a47cdefdc5eee63f4bd813a |
| 4.2.1         | 8b33d29996d539937e11f7da22f85047fab01197 | e76d5e3a807a5eae6d7059393759869336a5f649906b64c488e1ada89675908a |

## OpenAPI generator

By default the code will be generated using [Swagger's codegen](https://github.com/swagger-api/swagger-codegen#swagger-code-generator) it is however possible to switch
to [OpenAPI's generator](https://github.com/OpenAPITools/openapi-generator). This can be done by passing some parameters to the `openapi_repositories` function:

WORKSPACE:
```python
load("@io_bazel_rules_openapi//openapi:openapi.bzl", "openapi_repositories")
openapi_repositories(
    codegen_cli_version = "5.0.0",
    codegen_cli_sha256 = "839fade01e54ce1eecf012b8c33adb1413cff0cf2e76e23bc8d7673f09626f8e",
    codegen_cli_provider = "openapi"
)
```

For most languages, changing the generator should be seamless. You might however need to change the `language` field in you rule to match one available on the selected generator.

## openapi_gen

```python
openapi_gen(name, spec, api_package, model_package, invoker_package)
```

This generates a `.srcjar` archive containing generated source files from a given openapi specification.

These rules rely on [swagger-codegen](https://github.com/swagger-api/swagger-codegen#swagger-code-generator) which defines many [configuration options](https://github.com/swagger-api/swagger-codegen#to-generate-a-sample-client-library). Not all configuration options
are implemented in these rules yet but contributions are welcome. You can also request features [here](https://github.com/meetup/rules_openapi/issues/new?title=I%20would%20like%20to%20see...)

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <code>Name, required</code>
        <p>A unique name for this rule.</p>
      </td>
    </tr>
    <tr>
      <td><code>spec</code></td>
      <td>
        <code>String, required</code>
        <p>
          Path to <code>.yaml</code> or <code>.json</code> file containing openapi specification
        </p>
      </td>
    </tr>
    <tr>
      <td><code>language</code></td>
      <td>
        <code>String, required</code>
        <p>Name of language to generate.</p>
        <p>If you wish to use a custom language, you'll need to create a jar containing your <a href="https://github.com/swagger-api/swagger-codegen#making-your-own-codegen-modules">custom codegen module</a>, then use <code>deps</code> to add the custom codegen module to the classpath.</p>
        <p>
          Note, not all swagger codegen provided languages generate the exact same source given the exact same set of arguments.
          Be aware of this in cases where you expect bazel not to perform a previous executed action for the same sources.
        </p>
      </td>
    </tr>
    <tr>
      <td><code>api_package</code></td>
      <td>
        <code>String, optional</code>
        <p>package for api.</p>
      </td>
    </tr>
    <tr>
      <td><code>module_package</code></td>
      <td>
        <code>String, optional</code>
        <p>package for models.</p>
      </td>
    </tr>
    <tr>
      <td><code>invoker_package</code></td>
      <td>
        <code>String, optional</code>
        <p>package for invoker.</p>
      </td>
    </tr>
    <tr>
      <td><code>additional_properties</code></td>
      <td>
        <code>Dict of strings, optional</code>
        <p>Additional properties that can be referenced by the codegen
        templates. This allows setting parameters that you'd normally put in
        <code>config.json</code>, for example the Java library template:</p>
        <pre>
    language = "java",
    additional_properties = {
        "library": "feign",
    },</pre>
      </td>
    </tr>
    <tr>
      <td><code>system_properties</code></td>
      <td>
        <code>Dict of strings, optional</code>
        <p>System properties to pass to swagger-codegen.  This allows setting parameters that you'd normally
        set with <code>-D</code>, for example to disable test generation:</p>
        <pre>
    language = "java",
    system_properties = {
        "apiTests": "false",
        "modelTests": "false",
    },</pre>
      </td>
    </tr>
    <tr>
      <td><code>type_mappings</code></td>
      <td>
        <code>Dict of strings, optional</code>
        <p>Allows control of the types used in generated code with
        swagger-codegen's <code>--type-mappings</code> parameter. For example to
        use Java 8's LocalDateTime class:</p>
        <pre>
    language = "java",
    additional_properties = {
        "dateLibrary": "java8",
    },
    type_mappings = {
        "OffsetDateTime": "java.time.LocalDateTime",
    },</pre>
      </td>
    </tr>
  </tbody>
</table>

An example of what a custom language may look like

```python
java_import(
  name = "custom-scala-codegen",
  jars = ["custom-scala-codegen.jar"]
)

openapi_gen(
  name = "petstore-client-src",
  language = "custom-scala",
  spec = "petstore-spec.json",
  api_package = "com.example.api",
  model_package = "com.example.model",
  invoker_package = "com.example",
  deps = [
    ":custom-scala-codegen"
  ]
)

scala_library(
  name = "petstore-client",
  srcs = [":petstore-client-src"]
)
```
