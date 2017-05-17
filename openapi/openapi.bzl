_specs_filetype = FileType([".json", ".yaml"])

def openapi_repositories():
    native.maven_jar(
        name = "io_bazel_rules_openapi_io_swagger_swagger_codegen_cli",
        artifact = "io.swagger:swagger-codegen-cli:2.2.2",
        sha1 = "a5b48219c1f9898b0a1f639e0cb89396d5f8e0d1",
    )
    native.bind(
        name = 'io_bazel_rules_openapi/dependency/openapi-cli',
        actual = '@io_bazel_rules_openapi_io_swagger_swagger_codegen_cli//jar',
    )

def _new_generator_command(ctx, gen_dir, rjars):
  gen_cmd = """
  {java} -cp {cli_jar}:{jars} io.swagger.codegen.SwaggerCodegen generate -i {spec} -l {language} -o {output}""".format(
      java = ctx.executable._java.path,
      cli_jar = ctx.file._codegen_cli.path,
      jars = ":".join([j.path for j in rjars]),
      spec = ctx.file.spec.path,
      language = ctx.attr.language,
      output = gen_dir,
  )

  if ctx.attr.api_package:
      gen_cmd += " --api-package {package}".format(
          package=ctx.attr.api_package
      )
  if ctx.attr.invoker_package:
      gen_cmd += " --invoker-package {package}".format(
          package=ctx.attr.invoker_package
      )
  if ctx.attr.model_package:
      gen_cmd += " --model-package {package}".format(
          package=ctx.attr.model_package
      )
  # fixme: by default, swagger-codegen is rather verbose. this helps with that but can also mask useful error messages
  # when it fails. look into log configuration options. it's a java app so perhaps just a log4j.properties or something
  gen_cmd += " 2>/dev/null"
  return gen_cmd

def _impl(ctx):
    jars = _collect_jars(ctx.attr.deps)
    (cjars, rjars) = (jars.compiletime, jars.runtime)
    gen_dir = "{out}-tmp".format(
        out=ctx.outputs.codegen.path
    )
    commands = [
      "mkdir -p {gen_dir}".format(
        gen_dir=gen_dir
      ),
      _new_generator_command(ctx, gen_dir, rjars),
      # forcing a timestamp for deterministic artifacts
      "find {gen_dir} -exec touch -t 198001010000 {{}} \;".format(
         gen_dir=gen_dir
      ),
      "{jar} cMf {target} -C {srcs} .".format(
          jar=ctx.file._jar.path,
          target=ctx.outputs.codegen.path,
          srcs=gen_dir
      )
    ]

    inputs = ctx.files._jdk + [
        ctx.executable._java,
        ctx.file._codegen_cli,
        ctx.file.spec
    ] + list(cjars) + list(rjars)
    ctx.action(
        inputs=inputs,
        outputs=[ctx.outputs.codegen],
        command=" && ".join(commands),
        progress_message="generating openapi sources %s" % ctx.label,
        arguments=[],
    )
    return struct(
        codegen=ctx.outputs.codegen
    )

# taken from rules_scala
def _collect_jars(targets):
    """Compute the runtime and compile-time dependencies from the given targets"""  # noqa
    compile_jars = set()
    runtime_jars = set()
    for target in targets:
        found = False
        if hasattr(target, "scala"):
            if hasattr(target.scala.outputs, "ijar"):
                compile_jars += [target.scala.outputs.ijar]
            compile_jars += target.scala.transitive_compile_exports
            runtime_jars += target.scala.transitive_runtime_deps
            runtime_jars += target.scala.transitive_runtime_exports
            found = True
        if hasattr(target, "java"):
            # see JavaSkylarkApiProvider.java,
            # this is just the compile-time deps
            # this should be improved in bazel 0.1.5 to get outputs.ijar
            # compile_jars += [target.java.outputs.ijar]
            compile_jars += target.java.transitive_deps
            runtime_jars += target.java.transitive_runtime_deps
            found = True
        if not found:
            # support http_file pointed at a jar. http_jar uses ijar,
            # which breaks scala macros
            runtime_jars += target.files
            compile_jars += target.files

    return struct(compiletime = compile_jars, runtime = runtime_jars)

openapi_gen = rule(
    attrs = {
        # downstream dependencies
        "deps": attr.label_list(),
        # openapi spec file
        "spec": attr.label(
            mandatory=True,
            allow_single_file=_specs_filetype
        ),
        # language to generate
        "language": attr.string(mandatory=True),
        "api_package": attr.string(),
        "invoker_package": attr.string(),
        "model_package": attr.string(),
        "_java": attr.label(
            executable = True,
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:java"),
            single_file = True,
            allow_files = True,
        ),
        "_jdk": attr.label(default=Label("//tools/defaults:jdk"), allow_files=True),
        "_jar": attr.label(
            default=Label("@bazel_tools//tools/jdk:jar"),
            allow_files=True,
            single_file=True
        ),
        "_codegen_cli": attr.label(
            cfg = "host",
            default = Label("//external:io_bazel_rules_openapi/dependency/openapi-cli"),
            allow_single_file = True,
        ),
    },
    outputs = {
        "codegen": "%{name}_codegen.srcjar",
    },
    implementation = _impl,
)
