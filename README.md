# DEPRECATED

Please use starlabio/tpm-emulator:2.0 which contains both TPM 1.2 and TPM 2.0.

[https://github.com/starlab-io/docker-tpm-emulator](GitHub)

[https://hub.docker.com/r/starlabio/tpm-emulator](Docker Hub)

# tpm2-emulator

Provides the TPM 2.0 tool software stack with the command line tools and
the TPM 2.0 emulator.

## Running the emulator

```bash
tpm_server &
```

If you want to start with a fresh state run it with `-rm` as an option.

Before any TPM command will work you must send it a startup command, with
a real TPM it is apparently the job of the BIOS to do this.

```bash
tpm2_startup --clear
```

## Docker container availability

```bash
docker pull starlabio/tpm2-emulator
docker run -it starlabio/tpm2-emulator
```
