# jupyter-rna

[![Harbor](https://github.com/tyson-swetnam/jupyter-rna/actions/workflows/harbor.yml/badge.svg)](https://github.com/tyson-swetnam/jupyter-rna/actions/workflows/harbor.yml)

<a href="https://de.cyverse.org/apps/de/d2bd883c-7bd1-11ed-a9cd-008cfa5ae621/versions/ddb2bca8-150f-11ee-935e-008cfa5ae621/launch" target="_blank"><img src="https://img.shields.io/badge/SuperShell-latest-orange?style=plastic&logo=jupyter"></a> <- Click to launch in CyVerse Discovery Environment

## Build

```{bash}
docker build -t harbor.cyverse.org/vice/jupyter/supershell:latest .
```

## Pull

```{bash}
docker pull harbor.cyverse.org/vice/jupyter/supershell:latest
```

## Test

```{bash}
docker run -it --rm -p 8888:8888 harbor.cyverse.org/vice/jupyter/supershell:latest
```
