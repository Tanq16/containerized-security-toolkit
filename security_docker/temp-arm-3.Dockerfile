FROM interimarm1
FROM interimarm2

FROM alpine
RUN mkdir /executables/
COPY --from=interimarm1 /executables/* /executables/
COPY --from=interimarm2 /executables/* /executables/
COPY --from=interimarm1 /nvim-linux64.deb /neovim-linux64.deb
