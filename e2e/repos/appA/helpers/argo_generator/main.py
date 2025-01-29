# Description:
# This application called argo-generator will take as input a "Component Manifest".
# This data structure can be in json or yaml and has the following elements:
# 1. Docker image name and tag
# 2. Helm chart name and version
# 5. Helm value definition
# 3. Application name
# 4. Namespace
# 6. An Argo CD project name
# 7. A version of this data structure that will match the version of the template at templates/argo-app-{v1}.yaml.j2
# 8. Environment name, dev, staging, or prod
# Logic:
# * Generates an Argo CD application manifest using a Jinja2 template that is versioned
# under the directory argo-app-generator/templates/argo-app-v1.yaml.j2.
# * Saves the generated manifest to a file called argo-app.yaml in the current working directory
# and print it out to console.
# Libraries that it will use:
# * dataclass decorator to define the data structure that will be used to pass the input to the Jinja2 template.
# * click library to define the CLI interface for the application.
# * jinja2 library to render the template with the input data structure.
# * yaml library to dump the generated manifest to a file and print it out to console.
# * logging library to log the input data structure and the generated manifest.

import click
import jinja2
import yaml
import logging
import json
from dataclasses import dataclass

# Configure logging
logging.basicConfig(level=logging.INFO)

PATH_TO_INLINE_VALUES = "/values/{{environment}}/in-line-values.yaml"

@dataclass
class ComponentManifest:
    docker_image: str
    helm_chart: str
    helm_chart_version: str
    helm_values: str
    app_name: str
    namespace: str
    argo_project: str
    template_version: str
    environment: str


@dataclass
class AppConfig:
    template_path: str = "templates"
    component_manifest: ComponentManifest = None


def to_nice_yaml(value, indent=2, **kwargs):
    return yaml.dump(value, indent=indent, default_flow_style=False, **kwargs)


def render_template(config: AppConfig) -> str:
    template_loader = jinja2.FileSystemLoader(searchpath=config.template_path)
    template_env = jinja2.Environment(loader=template_loader)
    template_env.filters["to_nice_yaml"] = to_nice_yaml
    template_file = f"argo-app-v{config.component_manifest.template_version}.yaml.j2"
    template = template_env.get_template(template_file)
    return template.render(config=config.component_manifest)


def load_config_file(config_file: str) -> dict:
    with open(config_file, "r") as file:
        if config_file.endswith(".json"):
            return json.load(file)
        elif config_file.endswith(".yaml") or config_file.endswith(".yml"):
            return yaml.safe_load(file)
        else:
            raise ValueError(
                "Unsupported file format. Please provide a .json or .yaml file."
            )


@click.command()
@click.option(
    "--config-file",
    required=True,
    help="Path to the configuration file (JSON or YAML)",
)
@click.option(
    "--template-path",
    default="argo_generator/templates",
    help="Path to the templates",
)
@click.option(
    "--log-level",
    default="INFO",
    help="Set the log level (e.g., DEBUG, INFO, WARNING, ERROR, CRITICAL)",
)
def generate_manifest(config_file, template_path, log_level):
    logging.basicConfig(level=getattr(logging, log_level.upper()))

    config_data = load_config_file(config_file)
    component_manifest = ComponentManifest(**config_data)
    config = AppConfig(
        template_path=template_path, component_manifest=component_manifest
    )

    logging.info(f"Input configuration: {config}")

    manifest = render_template(config)
    logging.info(f"Generated manifest: \n\n{manifest}")

    with open("argo-app.yaml", "w") as f:
        yaml.dump(yaml.safe_load(manifest), f)


if __name__ == "__main__":
    generate_manifest()
