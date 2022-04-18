# Django Docker dev

Docker image for Django development tools.

## Usage

Build the image:

``` bash
make build
```

Add an alias in your `.bashrc` file:

``` bash
alias django-docker-dev='docker run --rm -it -v "$(pwd):/apps" -p 8500:8500 --name ddd "django-docker-dev"'
````
