Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1545233975.3954.8.camel@linux.ibm.com> <1545234449.3954.14.camel@linux.ibm.com>
 <CAOQ4uxgG9yu-dOgOZyFnck+=ZjsoDe0SCJ6S-4+s0kB6mH2Maw@mail.gmail.com> <1545245504.3954.51.camel@linux.ibm.com>
In-Reply-To: <1545245504.3954.51.camel@linux.ibm.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 19 Dec 2018 22:47:37 +0200
Message-ID: <CAOQ4uxiv_Pcm1zOr3N+=ySqePvRkqoraH6Xkja3Z9WeywDpt3g@mail.gmail.com>
Subject: Re: [Fwd: Re: EVM: Permission denied with overlayfs]
Content-Type: text/plain; charset="UTF-8"
To: zohar@linux.ibm.com
Cc: iforster@suse.de, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Dec 19, 2018 at 8:51 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Wed, 2018-12-19 at 18:35 +0200, Amir Goldstein wrote:
> > On Wed, Dec 19, 2018 at 5:47 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > >
> > > Hi Ignaz, Amir,
> > >
> > > CONFIG_OVERLAY_FS_METACOPY was introduce in linux-4.19.  Do either of
> > > you by have time to bisect this and find the commit that introduced
> > > the regression?
> > >
> >
> > Hi Mimi,
> >
> > v4.19 has a big change that removes many VFS hacks in favor of
> > overlayfs stacked file operations.
> >
> > The major implication for VFS code is that file_inode(file) is now the overlayfs
> > inode and not the real inode. Therefore, file_dentry(file) is also the overlayfs
> > dentry and not the real dentry.
> >
> > I am not sure how that change impacts EVM ?
> > FWIW, d_backing_inode(dentry) was never anything more than d_inode(dentry).
> >
> > Can you please try to describe in more details for someone who has no clue what
> > EVM does how exactly the v4.19 change is manifested in the EVM use case.
> >
> > AFAIKT, evm_calc_hmac_or_hash() would get the overlayfs dentry both in
> > v4.18 and v4.19 and therefore d_backing_inode(dentry) should be the
> > overlayfs inode in both kernels (?).
> >
> > The value of overlayfs inode i_ino can be identical to i_ino of the real inode
> > under some conditions, but far from always and the value of overlayfs inode
> > i_generation is almost guaranteed to not match that of the real inode.
> >
> > Ignaz, can you add some more debug prints to shed some light on what
> > exactly has changed, between the two kernels?
> > If the calculated hashes do not match in two different execution paths,
> > please provide two sample stack traces that see different i_ino, so we can
> > examine them.
>
> Attached is the output from the script below.  With the posted kernel
> patch, these are the dmesg messages (d_backing_inode, d_real_inode,
> dentry->d_name.name):
>
> [ 8973.189712] evm: ino: 61217 1841346 61217 oo.text
> [ 8973.202776] evm: ino: 60375 1836705 60375 ll.text
> [ 8973.203683] evm: ino: 61217 1841346 61217 oo.text
> [ 8973.204713] evm: ino: 60380 1839227 60380 uu.text
>

The patch I sent can iron these changes out, but it won't iron out
the i_generation change.

> script:
> -------
> #!/bin/bash
> # A small example for reproduction (on a system with IMA appraisal):
> set -x
> cd /home/mimi/tmp/
> OVERLAYFS_TEST_DIR=overlay
> mkdir $OVERLAYFS_TEST_DIR
> mkdir "${OVERLAYFS_TEST_DIR}/lower"
> mkdir "${OVERLAYFS_TEST_DIR}/upper"
> mkdir "${OVERLAYFS_TEST_DIR}/work"
> mkdir "${OVERLAYFS_TEST_DIR}/merged"
> mount -t overlay overlay -o lowerdir="${OVERLAYFS_TEST_DIR}/lower",upperdir="${OVERLAYFS_TEST_DIR}/upper",workdir="${OVERLAYFS_TEST_DIR}/work" "${OVERLAYFS_TEST_DIR}/merged"
>
> echo lower > overlay/lower/ll.text
> echo upper > overlay/upper/uu.text
> echo overlay > overlay/merged/oo.text
> set +x
> find overlay -type f -exec stat {} \;
> echo =====
> find overlay -type f -exec cat {} \;
>
> =====
> cat: overlay/merged/ll.text: Permission denied
> cat: overlay/merged/oo.text: Permission denied
> cat: overlay/merged/uu.text: Permission denied
> overlay
> upper
> lower

What I am still missing is:
1. What does the call stack look like when calculating the hash on oo.text?
2. What does the call stack look like when failing to verify the hash
on oo.text?
3. If the same tests does pass pre v4.19, please provide call stacks from that
kernel as well.

Thanks,
Amir.
