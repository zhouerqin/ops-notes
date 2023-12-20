# Dockerfile

一些Dockerfile指令

## FROM

## LABEL

## RUN
1. RUN <command> (shell form, the command is run in a shell, which by default is on Linux or on Windows)/bin/sh -ccmd /S /C
2. RUN ["executable", "param1", "param2"] (exec form)

单行语法

`RUN echo "hello world"`

多行语法

```Dockerfile
RUN echo "hello world"; \
    echo "hello 123"
```

```Dockerfile
RUN <<EOF bash
echo "hello world"
echo "hello 123"
```

```Dockerfile
RUN <<EOF bash -ex
echo "hello world"
echo "hello 123"
```

## COPY

## ADD

## EXPOSE

## VOLUME

## RUN