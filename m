Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38830 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfFBXSk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 2 Jun 2019 19:18:40 -0400
MIME-Version: 1.0
References: <CAH2+hP4Q3i4LdKL2Cz=1uWq0+JSD1RnzcdmicDtCeqEUqLo+hg@mail.gmail.com>
 <CAOQ4uxgPXBazE-g2v=T_vOvnr_f0ZHyKYZ4wvn7A3ePatZrhnQ@mail.gmail.com> <20190602180057.GA4865@mit.edu>
In-Reply-To: <20190602180057.GA4865@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Jun 2019 02:18:25 +0300
Message-ID: <CAOQ4uxhbSc0nZ69ffJVfNgVnr=ahg+HetiXcZKMXA2nXKCabqA@mail.gmail.com>
Subject: Re: which lower filesystems are actually supported?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Marco Nelissen <marco.nelissen@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Gabriel Krisman Bertazi <krisman@collabora.com>, Eric Biggers <ebiggers@google.com>
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
[...]
> >
> > I am guessing when people start using case insensitive enabled ext4,
> > this problem
> > is going to surface, because the same ext4 (e.g. root fs) could be
> > used for samba
> > export (case insensitive) and docker storage (overlayfs).
>
[...]
>
> We *might* be able to only set the dentry functions on directory
> entries belonging to directories which have the casefold flag set,
> instead of simply setting it on all ext4 dentry entries.  But still
> won't change the fact that overlayfs is going to have case
> insensitivity support if we want the combination of overlayfs &&
> casefold to be supported.
>

My intention was not that overlayfs should support casefold, just that
an isolated casefold subdir in an ext4 fs shouldn't make the entire fs
not usable with overlayfs.

Incidentally, we already ran into a similar issue with ext4 encryption.
Issue was reported by OpenWRT developers and fixed by:
d456a33f041a fscrypt: only set dentry_operations on ciphertext dentries

I recon casefold is taking a similar direction to the fs/crypto library, so
solution should be similar as well.

BTW, is casefold feature mutually exclusive with encryption feature?
Because if it isn't, d_set_d_op() in __fscrypt_prepare_lookup() is
going to WARN_ON dentry already has ext4_dentry_ops.

Thanks,
Amir.
