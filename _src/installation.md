---
layout: page
title: "Installation"
---

{% include JB/setup %}

## Installing transrate

If you've got Ruby v2.0.0 or later, install Transrate with the command:

```bash
$ gem install transrate
```

If your Ruby installation is system-wide you may need to add a `sudo` command for the install to work:

```bash
$ sudo gem install transrate
```

Before you can run transrate, you will need to make sure you have all the dependencies installed.

## Installing Ruby

If you don't have at least v2 Ruby installed, you should install the latest version, then install transrate as above.

We recommend using the Ruby Version Manager to install and manage Ruby: [RVM.io](http://rvm.io) - there are instructions for setting up RVM for single users and on multi-user environments such as clusters and HPC setups.

## Installing dependencies

Transrate depends on several external pieces of software. The full list of dependencies for transrate v1.0.0 is:

- [SNAP](http://snap.cs.berkeley.edu/) `v1.0.0dev63` or later
- [eXpress](http://bio.math.berkeley.edu/eXpress/) `v1.5.1`
- [transrate-tools](https://github.com/cboursnell/transrate-bam-read) `v1.0.0`
- [Samtools](http://samtools.sourceforge.net/) `v0.1.19`
- [BLAST+](http://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) `v2.2.29`

Transrate can install any missing dependencies for you. This is done by running the command:

```bash
$ transrate --install-deps
```

The `--install-deps` command will make all the dependent binaries available in your system PATH by placing them in the Ruby gem binary directory. If your Ruby installation is system-wide you'll need to add a `sudo` to the command:

```bash
$ sudo transrate --install-deps
```

If you prefer, you can install the dependencies yourself, or ask your system administrator to install them for you. Just make sure all the binaries end up in the system PATH. You can see the list of required binaries for each dependency in [the transrate code on Github](https://github.com/Blahah/transrate/blob/master/deps/deps.yaml).
