#!/usr/bin/env python

import yaml
import jinja2
import argparse
import os

# Set up command-line argument parsing
parser = argparse.ArgumentParser(description='Generate LaTeX document from template and YAML data.')
parser.add_argument('yaml_file', type=str, help='The YAML file containing the data')
parser.add_argument('--template', type=str, default='src/resume.j2', help='The Jinja2 template file (default: resume.j2)')

args = parser.parse_args()

# Derive the output filename from the input YAML filename
yaml_filename = os.path.basename(args.yaml_file)
output_filename = os.path.splitext(yaml_filename)[0] + '.tex'

# Read YAML data from the specified file
with open(args.yaml_file, 'r') as file:
    data = yaml.safe_load(file)

# Load the Jinja2 template
with open(args.template, 'r') as file:
    template = jinja2.Template(file.read())

# Render the template with data
output = template.render(data)

# Write the output to the derived LaTeX file
with open(output_filename, 'w') as file:
    file.write(output)

print(f"Rendered LaTeX document has been saved to {output_filename}")
