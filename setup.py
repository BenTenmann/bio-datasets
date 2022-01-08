import re
from pathlib import Path

from setuptools import setup, find_packages

DIR = Path(__file__).parent


def main():
    try:
        changelog = (DIR / 'CHANGELOG.md').read_text()
        __version__, *_ = re.findall(r"\[([0-9.]+)]", changelog)

    except (FileNotFoundError, ValueError):
        __version__ = '0.1.0'

    long_description = (DIR / 'README.md').read_text()
    setup(
        name='bio-datasets',
        version=__version__,
        long_description=long_description
    )


if __name__ == '__main__':
    main()
