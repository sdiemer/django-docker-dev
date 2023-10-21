FROM debian:bookworm

RUN apt-get -q update
RUN apt-get -qy install --no-install-recommends sudo bash-completion make git git-lfs htop python3-setuptools python3-venv ipython3 vim
RUN apt-get -qy autoclean

# Create venv
RUN python3 -m venv /opt/venv --system-site-packages
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="$VIRTUAL_ENV/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Force usage of recent tools
RUN apt purge -y python3-setuptools python3-wheel
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Install dependencies
RUN pip install django django-debug-toolbar pytest pytest-django requests pillow bleach tinycss2 build twine

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
