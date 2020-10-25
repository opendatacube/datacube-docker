#!/usr/bin/env python3

import click
import datetime
import subprocess

import pandas as pd

@click.command("index-sentinel-2_capetown")
@click.argument("product", type=str, nargs=1)
@click.argument("utm-zone", type=str, nargs=1)

def cli(product, utm_zone):
    s3_path = f"s3://deafrica-sentinel-2/sentinel-s2-l2a-cogs/{utm_zone}/**/*.json"
    print(f"Running for {s3_path} and {product}")
    subprocess.run(["s3-to-dc", '--stac', '--no-sign-request', s3_path, product])


if __name__ == "__main__":
    cli()
