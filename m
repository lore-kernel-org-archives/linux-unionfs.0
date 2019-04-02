Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39550 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfDBGrF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Apr 2019 02:47:05 -0400
Received: by mail-yw1-f67.google.com with SMTP id z9so4203890ywd.6
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Apr 2019 23:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190328153829.729-1-amir73il@gmail.com> <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
 <CAOQ4uxhdFA1twP4AJ9yN_aD07AnOFYKwNqPSjiLHHMv9a==MWA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhdFA1twP4AJ9yN_aD07AnOFYKwNqPSjiLHHMv9a==MWA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 Apr 2019 09:46:53 +0300
Message-ID: <CAOQ4uxjuWda90XZKajssvg=Dzu-G61+5FFY2zUQ+Zc9YmDFA2A@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Mar 31, 2019 at 8:41 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Mar 30, 2019 at 10:45 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Thu, Mar 28, 2019 at 4:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > This nasty little syzbot repro:
> > > https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
> > >
> > > Creates overlay mounts where the same directory is both in upper
> > > and lower layers. Simplified example:
> > >
> > >   mkdir foo work
> > >   mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"
> >
> > Shouldn't the mount fail in this case?
> >
>
> Sure, but that is independent of this patch, because renaming
> between lower layers after mount can get you to the same
> situation and that is harder to prevent.
>
> > Does it make any sense to allow overlapping layers?
> >
> > If doing the check the dumb way, the number of d_ancestor() calls
> > would increase quadratically with the number of layers, but I think
> > it's possible to do it in linear time if necessary.
>
> As I wrote to Vivek, we can do that, but it's only going to
> benefit users that make an innocent mistake (what's the odds of that?).
> An adversary could easily work around the mount check by moving
> lower dirs after mount.
>

What do you guys thing of this idea:

On mount we "poison" overlay inode cache with canary overlay inode
for each layer root (including upper and work).
The canary inode has the layer root inode as i_private, but both
 ovl_inode_lower() and ovl_inode_upper() NULL, so it will always
fail ovl_verify_inode().

Then in  ovl_lookup_single(), we do a sanity
ovl_lookup_inode(this->d_inode). If it returns -ESTALE, we fail
the lookup.

This should immune overlayfs from moving layers root
into other layers after mount.

During mount, after setting up all canary inodes, we can walk
back ancestors of all layers roots and use ovl_lookup_inode()
on real ancestors to check for bad setup.

A simple optimization for docker and similar container managers -
if all layers roots have the same parent or same grandparent
(e.g. /var/lib/docker/overlay), we can skip the ancestors walk
on mount, but still keep the lookup sanity checks for post mount
tampering protection.

Thoughts?

Amir.
