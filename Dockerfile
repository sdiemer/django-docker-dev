FROM debian:bullseye

RUN apt-get -q update
RUN apt-get -qy install --no-install-recommends sudo bash-completion make git git-lfs python3-pip python3-setuptools python3-venv ipython3
RUN apt-get -qy autoclean

RUN pip3 install django django-debug-toolbar pytest pytest-django pillow bleach

# Add unix user
ARG USER_UID
ARG USER_GID
RUN groupadd --gid $USER_GID djdev
RUN useradd --uid $USER_UID --gid $USER_GID --home-dir /home/djdev --groups sudo --shell /bin/bash djdev
RUN echo "djdev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -pv /home/djdev
RUN chown -R djdev: /home/djdev
RUN mkdir -pv /run/djdev
RUN chown -R djdev: /run/djdev

COPY bashrc /home/djdev/.bashrc

RUN mkdir -p /opt/src
WORKDIR /opt/src

USER djdev
EXPOSE 8500
CMD ["/bin/bash"]
