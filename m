Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43279 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBUBH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 2 Jun 2019 16:01:07 -0400
MIME-Version: 1.0
References: <CAH2+hP4Q3i4LdKL2Cz=1uWq0+JSD1RnzcdmicDtCeqEUqLo+hg@mail.gmail.com>
 <CAOQ4uxgPXBazE-g2v=T_vOvnr_f0ZHyKYZ4wvn7A3ePatZrhnQ@mail.gmail.com> <20190602180057.GA4865@mit.edu>
In-Reply-To: <20190602180057.GA4865@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 2 Jun 2019 23:00:49 +0300
Message-ID: <CAOQ4uxhGCU0xqgjL94Pq2Rh9m1_YsboRMXC_mWK+fra3w85EWw@mail.gmail.com>
Subject: Re: which lower filesystems are actually supported?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Marco Nelissen <marco.nelissen@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Gabriel Krisman Bertazi <krisman@collabora.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jun 2, 2019 at 9:01 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Sun, Jun 02, 2019 at 09:42:54AM +0300, Amir Goldstein wrote:
> > [+cc ext4] Heads up on bug reports "Overlayfs fails to mount with ext4"
> >
> > On Sat, Jun 1, 2019 at 11:02 PM Marco Nelissen <marco.nelissen@gmail.com> wrote:
> > >
> > > According to the documentation, "The lower filesystem can be any filesystem
> > > supported by Linux", however this appears to not actually be the case, since
> > > using a vfat filesystem results in the mount command printing "mount:
> > > wrong fs type, bad option, bad superblock on overlay, missing codepage or
> > > helper program, or other error", with dmesg saying "overlayfs: filesystem on
> > > '/boot' not supported".
> > > (that's from ovl_mount_dir_noesc(), when ovl_dentry_weird() returns nonzero)
> >
> > Specifically for vfat it is weird because of
> > dentry->d_flags & (DCACHE_OP_HASH | DCACHE_OP_COMPARE)
> > because it is case insensitive.
>
> Marco, did you actually *need* to use the case insensitive feature?

Marco reported the error on vfat and asked which other fs will have
similar issue.

> It is not turned on by default by e2fsprogs, and the assumption was
> that it only be turned in cases where it was needed --- e.g., VM's
> running Steam games that need Microsoft file system semantics,
> including case insensitivity, Samba (and eventually NFSv4) file
> servers for the same reason, and Android (so people won't have to try
> to get the abomination known as sdcardfs upstream :-).
>
> >
> > I am guessing when people start using case insensitive enabled ext4,
> > this problem
> > is going to surface, because the same ext4 (e.g. root fs) could be
> > used for samba
> > export (case insensitive) and docker storage (overlayfs).
>
> So I didn't think this would be that common, since you can certainly
> run Sambda without this new file system feature --- Samba has lived
> without it for over a decade.

The performance penalty for brute force in some worse cases is abysmal.
Most users don't know enough to blame the case insensitive compatibility
layer.

> However, if you are running a high
> performance file server, it matters --- but if you're running a high
> performance file server, you're certainly not going to be trying to do
> it on the same server as one running Docker.

Ted, people are using docker for anything these days.
The chances that people won't use docker on the same machine
where ext4 case insensitive was enabled are slim.
It doesn't have to be high perf. server. It's enough that someone
reads an article about improving Samba with ext4 to set it up for
its home server.

>
> Now, if you're trying to use overlayfs for some kind of snapshot
> application, then we'll need to figure out how to make overlayfs and
> ext4 work together --- but I view this as much more over an overlay
> compatibility issue than an ext4 bug.
>

Sure, but the complaints will start with "I enabled ext4 case insensitive
and docker stopped working..." the sooner we are ready for this the better.

> We *might* be able to only set the dentry functions on directory
> entries belonging to directories which have the casefold flag set,
> instead of simply setting it on all ext4 dentry entries.  But still
> won't change the fact that overlayfs is going to have case
> insensitivity support if we want the combination of overlayfs &&
> casefold to be supported.
>
> > I didn't see that xfstests-bld was updated with case folding configs for ext4,
> > nor that xfstests has any new case folding tests (saw some posted), so I guess
> > that is still in the works (?).
>
> That's correct, it's still on the todo list.
>
> > Did you happen to try out overlayfs/docker over a case insensitive enabled fs?
>
> Nope.  I didn't think that was going to be a common use case.  Docker
> is typically used on servers, where as case insensitivity is important
> for clients and file servers --- at least on the general case.
>
> > I wonder if you could spare a few extra GCE instances per pre-release tests
> > to run an overlay over ext4 config?
> > I was nagging Darrick about this for a while and now I think the
> > overlay/xfs config
> > is being tested regularly.
>
> It wouldn't be that hard to test overlayfs with ext4 for my
> pre-release testing.  But it would only be in the default ext4
> configuration --- and that doesn't include the case fold feature.
>

Yep, that's what I had in mind. I know it wouldn't have caught
this specific issue.

Thanks,
Amir.
