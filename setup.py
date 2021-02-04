import setuptools
from pathlib import Path


root_dir = Path(__file__).absolute().parent
with (root_dir / 'VERSION').open() as f:
    version = f.read()
with (root_dir / 'README.rst').open() as f:
    long_description = f.read()
with (root_dir / 'requirements.in').open() as f:
    requirements = f.read().splitlines()


setuptools.setup(
    name='gn_module_import',
    version=version,
    description="",
    long_description=long_description,
    long_description_content_type='text/x-rst',
    maintainer='Parcs nationaux des Écrins et des Cévennes',
    maintainer_email='geonature@ecrins-parcnational.fr',
    url='https://github.com/PnX-SI/gn_module_import',
    #packages=[ 'gn_module_import.' + p for p in setuptools.find_packages('backend') ],
    packages=setuptools.find_packages('backend'),
    package_dir={'': 'backend'},
    #package_data={'pypnusershub.migrations': ['data/*.sql']},
    install_requires=requirements,
    zip_safe=False,
    entry_points={
        'gn_module': [
            'blueprint = gn_module_import.blueprint:blueprint',
            'config_schema = gn_module_import.conf_schema_toml:GnModuleSchemaConf',
        ],
    },
    classifiers=['Development Status :: 1 - Planning',
                 'Intended Audience :: Developers',
                 'Natural Language :: English',
                 'Programming Language :: Python :: 3',
                 'Programming Language :: Python :: 3.4',
                 'Programming Language :: Python :: 3.5',
                 'Programming Language :: Python :: 3.6',
                 'Programming Language :: Python :: 3.7',
                 'Programming Language :: Python :: 3.8',
                 'License :: OSI Approved :: GNU Affero General Public License v3'
                 'Operating System :: OS Independent'],
)
