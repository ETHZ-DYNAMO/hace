from setuptools import setup, find_packages
setup(
    name='hace',
    version='0.0.2',
    packages=find_packages(include=['hace', 'hace.*']),
    requires = [
    ],
    install_requires = [
		"lark==1.2.2",
		"networkx",
		"z3-solver",
    ]
)
