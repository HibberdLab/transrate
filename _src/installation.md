---
layout: page
title: "Installation"
---

{% include JB/setup %}

## Installing transrate

### Quick install

```bash
$ gem install transrate && transrate --install-deps
```

OR

```bash
$ sudo gem install transrate && transrate --install-deps
```

### Detailed instructions

If you've got Ruby v2.0.0 or later, install Transrate with the command:

```bash
$ gem install transrate
```

If your Ruby installation is system-wide you may need to add a `sudo` command for the install to work:

```bash
$ sudo gem install transrate
```

Before you can run transrate, you will need to make sure you have all the dependencies installed.

### Installing Ruby

If you don't have at least v2 Ruby installed, you should install the latest version, then install transrate as above.

We recommend using the Ruby Version Manager to install and manage Ruby: [RVM.io](http://rvm.io) - there are instructions for setting up RVM for single users and on multi-user environments such as clusters and HPC setups.

To install Ruby and transrate, you can use the command:

```bash
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
$ \curl -sSL https://get.rvm.io | bash -s stable --ruby --gems=transrate
```

### Installing dependencies

Transrate depends on several external pieces of software. Any missing dependencies can be installed automatically by running the command:

```bash
$ transrate --install-deps
```

The `--install-deps` command will make all the dependent binaries available in your system PATH by installing them to the Ruby gem directory (for a user-space install of ruby), or to `~/.local/` (for a system-wide install of Ruby).

If you only want to run the read metrics, you can use the `--install-read-deps` command to install only the dependencies required for that analysis. Similarly, if you only want to run the reference metrics, you can use `--install-ref-deps`.

If you prefer, you can install the dependencies yourself, or ask your system administrator to install them for you. Just make sure all the binaries end up in the system PATH. The full list of dependencies for transrate v1.0.0.beta2 is:

- [SNAP](http://snap.cs.berkeley.edu/) `v1.0.0dev67.trfix1`
- [Salmon](https://github.com/kingsfordgroup/sailfish/releases/tag/v0.2.7) `v0.2.7`
- [transrate-tools](https://github.com/Blahah/transrate-tools/releases/tag/v1.0.0.beta3) `v1.0.0.beta3`
- [BLAST+](http://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) `v2.2.X` (only required for reference-based analysis)

We provide links to the linux and macosx binaries for these dependencies below:

|                 | linux                                                                                                                       |                                                                                                                       macosx |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------:|
| SNAP            | [v1.0.dev67.trfix1](https://github.com/Blahah/snap/releases/download/v1.0dev.67.trfix1/snap_v1.0dev.67.trfix1_linux.tar.gz) | [v1.0dev.67.trfix1](https://github.com/Blahah/snap/releases/download/v1.0dev.67.trfix1/snap_v1.0dev.67.trfix1_macosx.tar.gz) |
| Salmon          | [v0.2.7](https://github.com/kingsfordgroup/sailfish/releases/download/v0.2.7/Salmon-v0.2.7_Ubuntu-12.04.tar.gz)             | [v0.2.7](https://github.com/kingsfordgroup/sailfish/releases/download/v0.2.7/Salmon-v0.2.7_MacOSX-10.10.1.tar.gz)            |
| transrate-tools | [v1.0.0.beta3](https://github.com/Blahah/transrate-tools/releases/download/v1.0.0.beta3/bam-read_1.0.0.beta3_linux.tar.gz)  | [v1.0.0.beta3](https://github.com/Blahah/transrate-tools/releases/download/v1.0.0.beta3/bam-read_1.0.0.beta3_macosx.tar.gz)  |
| BLAST+          | [v2.2.29](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-x64-linux.tar.gz)                   | [v2.2.29](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-universal-macosx.tar.gz)             |
