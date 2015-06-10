---
layout: page
title: "Installation"
---

{% include JB/setup %}

Transrate is avaiable for Mac OSX and Linux. Download the binaries below:

- [Linux 64bit v1.0.0.beta4](https://bintray.com/artifact/download/blahah/generic/transrate-1.0.0.beta4-linux-x86_64.tar.gz)
- [OSX v1.0.0.beta4](https://bintray.com/artifact/download/blahah/generic/transrate-1.0.0.beta4-osx.tar.gz)

You can get older versions from [BinTray](https://bintray.com/blahah/generic/transrate).

To install, download the package for your operating system, unpack it, and add the unpacked directory to your `PATH`.

**Notes:**

1. Because Transrate comes packaged with its binary dependencies, you must keep the directory structure of the package intact.
2. Transrate does not include BLAST+. If you want to use the reference-based metrics, you'll need to install BLAST+ yourself.

## Advanced installation

Transrate is also available as a Ruby gem. This has some advantages, such as easy checking for updates, and the ability to use Transrate as a Ruby library. However, the setup is more complex - if you just want to run Transrate, you should use the binary install above.

If you've got Ruby v2.0.0 or later, install Transrate with the command:

```bash
$ gem install transrate --pre
```

If your Ruby installation is system-wide you may need to add a `sudo` command for the install to work:

```bash
$ sudo gem install transrate --pre
```

Before you can run Transrate, you will need to make sure you have all the dependencies installed.

### Installing Ruby

If you don't have at least v2 Ruby installed, you should install the latest version, then install Transrate as above.

We recommend using the Ruby Version Manager to install and manage Ruby: [RVM.io](http://rvm.io) - there are instructions for setting up RVM for single users and on multi-user environments such as clusters and HPC setups.

### Installing dependencies

Transrate depends on several external pieces of software. The full list of dependencies for transrate v1.0.0 is:

- SNAP `v1.0.0dev67.trfix1` [download: [linux](https://github.com/Blahah/snap/releases/download/v1.0dev.67.trfix1/snap_v1.0dev.67.trfix1_linux.tar.gz) | [mac](https://github.com/Blahah/snap/releases/download/v1.0dev.67.trfix1/snap_v1.0dev.67.trfix1_macosx.tar.gz)]
- Salmon `v0.4.0` [download: [linux](https://github.com/COMBINE-lab/salmon/releases/download/v0.4.0/SalmonBeta-0.4.0_DebianSqueeze.tar.gz) | [mac](https://github.com/COMBINE-lab/salmon/releases/download/v0.4.0/SalmonBeta-0.4.0_OSX-10.10.tar.gz)]
- [bam-read](https://github.com/cboursnell/transrate-tools) `v1.0.0` [download: [linux](https://github.com/Blahah/transrate-tools/releases/download/v1.0.0.beta4/bam-read_v1.0.0.beta4_linux.tar.gz) | [mac](https://github.com/Blahah/transrate-tools/releases/download/v1.0.0.beta4/bam-read_v1.0.0.beta4_osx.tar.gz)]
- [BLAST+](http://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) `v2.2.29`

Transrate can install any missing dependencies for you. This is done by running the command:

```bash
$ transrate --install-deps
```

The `--install-deps` command will make all the dependent binaries available in your system PATH by placing them in the Ruby gem binary directory, or if it doesn't have the permissions to do that, in `~/.local`.

If you prefer, you can install the dependencies yourself, or ask your system administrator to install them for you. Just make sure all the binaries end up in the system PATH. You can see the list of required binaries for each dependency in [the transrate code on Github](https://github.com/Blahah/transrate/blob/master/deps/deps.yaml).
