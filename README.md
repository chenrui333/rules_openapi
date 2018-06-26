# bazel openapi rules [![Build Status](https://travis-ci.org/meetup/rules_openapi.svg?branch=master)](https://travis-ci.org/meetup/rules_openapi)

> [Bazel](https://bazel.build/) rules for generating sources and libraries from [openapi](https://www.openapis.org/) schemas

## Rules

* [openapi_gen](#openapi_gen)

## Getting started

To use the Openapi rules, add the following to your projects `WORKSPACE` file

```python
rules_openapi_version="c449fd6d1ac8b3dffb8bae3bca7305167b800267" # update this as needed

git_repository(
    name = "io_bazel_rules_openapi",
    commit = rules_openapi_version,
    remote = "git@github.com:meetup/rules_openapi.git",
)

load("@io_bazel_rules_openapi//openapi:openapi.bzl", "openapi_repositories")
openapi_repositories()
```

Then in your `BUILD` file, just add the following so the rules will be available:

```python
load("@io_bazel_rules_openapi//openapi:openapi.bzl", "openapi_gen")
```

## openapi_gen

```python
openapi_gen(name, spec, api_package, model_package, invoker_package)
```

Generates `.srcjar` containing generated source files from a given openapi specification

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

Meetup 2017
