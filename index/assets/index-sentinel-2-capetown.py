#!/usr/bin/env python3

import click
import datetime
import subprocess

import pandas as pd

@click.command("index-sentinel-2_capetown")
@click.argument("product", type=str, nargs=1)

def cli(product):
    region_code_list_uri="https://raw.githubusercontent.com/digitalearthafrica/deafrica-extent/master/deafrica-mgrs-tiles.csv.gz"
    region_codes = pd.Series(pd.read_csv(region_code_list_uri).values.ravel())
    utm_zone = set(region_codes.str[0:2])

    for x in utm_zone:
        s3_path = f"s3://deafrica-sentinel-2/sentinel-s2-l2a-cogs/{x}/**/*.json"
        print(f"Running for {s3_path} and {product}")
        subprocess.run(["s3-to-dc", '--stac', '--no-sign-request', s3_path, product])


if __name__ == "__main__":
    cli()
