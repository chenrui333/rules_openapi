# bazel open rules

> [Bazel](https://bazel.build/) rules for generating sources and libraries from [openapi](https://www.openapis.org/) schemas

## Rules

* [openapi_gen](#openapi_gen)

## Getting started

To use the Openapi rules, add the following to your projects `WORKSPACE` file

```python
rules_openapi_version="xxx" # update this as needed

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
open_api(name, spec, api_package, model_package, invoker_package)
```

Generates `.srcjar` containing generated source files from a given openapi specification

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
        <p>Name of language to generate. If using a custom language, use <code>deps</code> add the custom codegen module to the classpath.</p>
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
  </tbody>
</table>

Meetup 2017
