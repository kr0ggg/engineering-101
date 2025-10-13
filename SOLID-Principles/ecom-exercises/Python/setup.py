from setuptools import setup, find_packages

setup(
    name="bounteous-ecom",
    version="1.0.0",
    description="E-commerce application demonstrating SOLID principle violations",
    author="Bounteous",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.8",
    install_requires=[
        "psycopg2-binary>=2.9.0",
    ],
    extras_require={
        "test": [
            "pytest>=7.0.0",
            "pytest-mock>=3.10.0",
            "pytest-cov>=4.0.0",
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
)
