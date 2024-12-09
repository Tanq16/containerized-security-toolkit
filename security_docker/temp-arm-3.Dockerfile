FROM tanq16/sec_docker:interimarm1 as interim1
FROM tanq16/sec_docker:interimarm2 as interim2

FROM alpine
RUN mkdir /executables/
COPY --from=interim1 /executables/* /executables/
COPY --from=interim2 /executables/* /executables/
COPY --from=interim1 /neovim-linux64.deb /neovim-linux64.deb
