Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <CACna6rx_jSTEEt6TAzQcBpAHZA_CJGhkjJhWWJKG3cQmr9c9ug@mail.gmail.com>
 <3000620.g91H2S8sUk@blindfold> <CAOQ4uxii0rZv3SVXWNN7yug_WZ-TKLL3Wo-mti0y9K66Z+-EcQ@mail.gmail.com>
 <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com>
In-Reply-To: <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Oct 2018 20:00:46 +0300
Message-ID: <CAOQ4uxgySZfoh-6p9FG_pOQ7zt02bSQQLk9YeD1nj5a+_RyrYA@mail.gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, russell@personaltelco.net, openwrt-devel@lists.openwrt.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 22, 2018 at 6:34 PM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> On Mon, 22 Oct 2018 at 10:57, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Mon, Oct 22, 2018 at 11:26 AM Richard Weinberger <richard@nod.at> wr=
ote:
> > >
> > > Am Montag, 22. Oktober 2018, 09:14:08 CEST schrieb Rafa=C5=82 Mi=C5=
=82ecki:
> > > > On Fri, 19 Oct 2018 at 14:31, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail=
.com> wrote:
> > > > > Since OpenWrt switch from kernel 4.9 to 4.14 users started random=
ly
> > > > > reporting file system corruptions. OpenWrt uses overlay(fs) with
> > > > > squashfs as lowerdir and ubifs as upperdir. Russell managed to is=
olate
> > > > > & describe test case for reproducing corruption when doing a powe=
r cut
> > > > > after first boot.
> > > > >
> > > > > (...)
> > > > >
> > > > > Can I ask you to check if there is something possibly wrong with =
the
> > > > > above ovl commit? Or does it expose some problem with the ubifs? =
Or
> > > > > maybe the whole UBI?
> > > > >
> > > > > FWIW testing above commit (and one before it) always results in s=
ingle
> > > > > error in the kernel log:
> > > > > [   14.250184] UBIFS error (ubi0:1 pid 637): ubifs_add_orphan: or=
phaned twice
> > > > >
> > > > > That UBIFS error doesn't occur with 4.12.14. Unfortunately it's
> > > > > impossible to cleanly revert 3a1e819b4e80 from the top of 4.12.14=
.
> > > >
> > > > Let me provide a summary of all relevant commits & tests:
> > > >
> > > > By "Corruption" I mean file system corruption after power cut
> > >
> > > Well, is the filesystem not consistent anymore?
> > > From what Russel explained to me, I thought the main problem is that =
no write back happens.
> > > IOW the inode is present, has correct length, but no content is there=
 (all zeros).
> > >
> > > Just like the typical case where userspace does not fsync.
> > > But in your case sooner or later write back should have happened beca=
use the writeback timer
> > > fires at some point.
> > >
> >
> > For the records overlayfs does:
> > - open(O_TMPFILE)
> > - setxattr() [with 3a1e819b4e80]
> > - write to tmpfile
> > - fsync tmpfile
> > - link tmpfile
> >
> > I suggest that you try the same from user space on ubifs.
>
> Are you 100% sure about it? I tried writing C app behaving as you
> described above and I could not reproduce the problem.
>

I am never 100% sure ;-)
I looked at upstream code, which does ovl_set_origin() before
copying data.
commit  3a1e819b4e80 does ovl_set_origin() after fsync like you say.

> Then I took a close look at ovl_copy_up_locked() and it seems above
> info isn't accurate. It seems to me that setxattr() happens between
> fsync and link. I modified my C app to follow that order (open, write,
> fsync, setxattr, link) and I can reproduce the problem now!
>
> Steps to reproduce the problem:
> 1) compile tmptest.c
> 2) tmptest /overlay/upper/foo.txt user.bar baz
> 3) wait 5 seconds (so ubifs writes to flash)
> 4) power cut
> 5) boot again and check content of /overlay/upper/foo.txt
> 6) in my case content appears to be 00 00 00 00
>
> Is this correct for ovl to call vfs_setxattr() *after* calling vfs_fsync(=
)?
>

Let's just clarify that for the matter of data corruption it doesn't matter
if and when overlayfs does vfs_setxattr(). Overalyfs does write()+fsync()
and that is all that should matter for guarantying data integrity.

Regarding "Is it correct to setxattr after fsync()?", that question depends
on what overlayfs needs to guaranty w.r.t crash consistency of its private
xattrs and on the type of crash consistency guaranties overlayfs expects
from the underlying filesystem.

Overlayfs needs to guaranty that if crash happens mid copy up, after
reboot, either the upper file is not there or the upper file is there with
all copied data and all copied metadata and the overlay xattrs.

Overlayfs current code expects the upper filesystem to have "strictly
ordered metadata" semantics, meaning that setxattr();link(), cannot
appear after crash as a linked file without the xattr. Just the same as
mkdir();chown();rename() cannot appear after crash as renamed dir
without the chwon();

Those semantics are provided by the journaling file systems (xfs, ext4)
and to be honest I am not sure if they are provided by btrfs or not -
every time this subject came up, btrfs developer answers were a bit too
vague for me to understand what is the expected behavior in btrfs.

Does ubifs has a problem to provide this guaranty?

Finally, I'll repeat with what I started - this has nothing to do with
data consistency. In fact, in the specific case of lower squashfs,
overlayfs will end up writing a zero length xattr, which overlayfs
only ever cares about on directories anyway.

Thanks,
Amir.
