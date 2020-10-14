#!/usr/bin/env python3

import click
import datetime
import subprocess


@click.command("index-sentinel-2")
@click.option(
    "--start-date",
    help="Start date in the format yyyy-mm-dd. Inclusive.",
)
@click.option(
    "--end-date",
    help="End date in the format yyyy-mm-dd. Exclusive.",
)
@click.argument("product", type=str, nargs=1)
def cli(start_date, end_date, product):
    print(f"Job running from {start_date} to {end_date}")
    start = datetime.datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.datetime.strptime(end_date, "%Y-%m-%d")

    if end < start:
        raise Exception("Start date is after end date, this is bad.")

    current_date = start

    while current_date < end:
        s3_path = f"s3://dea-public-data/L2/sentinel-2-nbar/S2MSIARD_NBAR/{current_date:%Y-%m-%d}/**/*.yaml"
        print(f"Running for {s3_path} and {product}")

        subprocess.run(["s3-to-dc", s3_path, product])

        current_date = current_date + datetime.timedelta(days=1)


if __name__ == "__main__":
    cli()
