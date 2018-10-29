Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org>
In-Reply-To: <20181027200450.GA5909@thunk.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Oct 2018 09:37:50 +0200
Message-ID: <CAOQ4uxj=4xciEFz4SRygGE4cObKB9zRzQLYXvRtLkEK2FqFscg@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 11:05 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> I was rebuilding my dropbox Docker container, and it failed in 4.19
> with the following error:
>
> dpkg: error processing archive /var/cache/apt/archives/perl-base_5.20.2-3+deb8u11_amd64.deb (--unpack):
>  unable to make backup link of `./usr/bin/perl5.20.2' before installing new version: Invalid cross-device link
> dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
> dpkg: error: error creating new backup file '/var/lib/dpkg/status-old': Invalid cross-device link
> E: Sub-process /usr/bin/dpkg returned an error code (2)
>

When that happens can you please 'stat /usr/bin/perl{5.20.2}', in
lower upper and overlay.
Assuming link does not exist in neither lower nor upper, please try to create
/usr/bin/perl5.20.2 link manually from /usr/bin/perl on overlay.

> When I booted the 4.18.0-2 kernel from Debian, the exact same Docker
> file worked just fine.  With 4.19 it fails reliably.
>

Strange, I expected many things to behave differently with v4.19 due to
stacked f_ops . link() was not one of them...

> To reproduce:
>
> git clone https://github.com/tytso/docker-dropbox
> cd docker-dropbox
> docker build --no-cache .
>
> I'm using a Debian testing (buster) userspace, using the docker-ce
> from dropbox.com, version 18.03.1~ce-0~debian, using overlay2 storage
> driverh.
>

What file system are you using for /var/lib/docker? ext4?
Is your docker overlay2 driver maybe configured to limit container
size with project quotas?
I don't know if there is a default for that, but anyway, there is no
ext4 project quota
support in docker AFAIK (only xfs project quotas).

> Does this ring a bell at all?  Can someone give me some tips on how to
> troubleshoot this?
>

I tried to reproduce on a xfstests-bld image with chroot and dpkg, but
didn't get far.
I get this warning with or without overlayfs:
update-alternatives: warning: forcing reinstallation of alternative
/usr/bin/prename
because link group rename is broken
I'll try to setup a new vm to test your reproducer.

Thanks,
Amir.
