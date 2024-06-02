import yaml
from jinja2 import Environment, FileSystemLoader

# Load YAML data
with open('data.yaml', 'r') as file:
    data = yaml.safe_load(file)

# Load Jinja environment
env = Environment(loader=FileSystemLoader('.'))
template = env.get_template('resume.j2')

# Render template with data
rendered_tex = template.render(data)

# Write rendered LaTeX to file
with open('output.tex', 'w') as file:
    file.write(rendered_tex)
