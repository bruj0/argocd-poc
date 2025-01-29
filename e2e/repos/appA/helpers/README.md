# How to run it
* Requires Python 3.12
* Install `uv` https://docs.astral.sh/uv/getting-started/installation/
* Sync the dependencies: uv sync
* Run it:

``` sh
$ uv run python -m argo_generator.main --template-path argo_generator/templates --config-file tests/fixtures/component_manifest.yaml
```

* Unit tests:
``` sh
$ uv run python -m pytest tests -vvv
```
