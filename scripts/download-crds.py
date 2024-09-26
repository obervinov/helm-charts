"""
This script is used to inject CRDs into the Helm charts.
The script reads the configuration file, downloads the source.
"""
import os
import requests
import yaml
from logger import log


def read_configuration(path: str = None) -> yaml.load:
    """
    Read the configuration file

    Args:
        path (str): Path to the configuration file

    Returns:
        yaml.load: Configuration file
    """
    try:
        with open(path, encoding='UTF-8') as file:
            log.info(f"Reading configuration file from {path}")
            return yaml.load(file, Loader=yaml.FullLoader)
    except Exception as error:
        log.error(f"Failed to read configuration file from {path}: {error}")
        raise error


def download_source_crds(urls: list = None, chart: str = None, version: str = None) -> None:
    """
    Download the source CRDs from the given URLs to target chart

    Args:
        urls (list): List of URLs to download the CRDs from
        chart (str): Name of the chart for which the CRDs are being downloaded
    """
    target_directory = os.path.join('..', 'src', chart, 'crds')
    os.mkdir(target_directory)
    for url in urls:
        url = url.replace('VERSION', version)
        file = url.split('/')[-1]
        log.info(f"Downloading CRD from {url}...")
        response = requests.get(url=url, timeout=30)
        with open(f"{target_directory}/{file}", 'wb') as file:
            file.write(response.content)
            log.info(f"CRD downloaded from {url} to {target_directory}/{file}")


def __main__() -> None:
    """
    Main function
    """
    file_path = os.path.abspath('inject-crds.yaml')
    configuration = read_configuration(path=file_path)
    for chart in configuration:
        download_source_crds(urls=chart['urls'], chart=chart['name'], version=chart['version'])


if __name__ == "__main__":
    __main__()
