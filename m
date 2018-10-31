Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <877bef77-3434-656f-a989-143179c2e1b7@gmail.com> <20181031083109.GE23439@veci.piliscsaba.redhat.com>
In-Reply-To: <20181031083109.GE23439@veci.piliscsaba.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 10:50:37 +0200
Message-ID: <CAOQ4uxjOy9HFU6GB8j=hr2XqzKCOaNG3qvCDqCdHSMZwDXRqdg@mail.gmail.com>
Subject: Re: [PATCH] ovl: do not hash ovl dentry when inode is NULL in ovl_lookup
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: xiakaixu1987@gmail.com, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 10:31 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 31, 2018 at 03:12:03PM +0800, kaixuxia wrote:
> > The dentry is hashed even if the inode is NULL in ovl_lookup and
> > later we get this dentry in lookup_dcache. But this dentry may
> > become stale when someone could (mistakenly or maliciously) manually
> > unlink the whiteout file directly from upperdir. So the NUll pointer
> > error occur when create the same name directory and system crash.
> >
> > Simple reproducer:
> >   $ mkdir lower upper work merge
> >   $ touch lower/file
> >   $ mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
> > merge
> >   $ rm merge/file
> >   $ ls -al merge/file
> > ls: cannot access merge/file: No such file or directory
> >   $ rm upper/file
> >   $ ls -al merge/
> > ls: cannot access merge/file: No such file or directory
> > total 0
> > drwxr-xr-x 1 root root  6 Oct 30 09:16 .
> > drwxr-xr-x 6 root root 57 Oct 30 09:15 ..
> > -????????? ? ?    ?     ?            ? file
> >   $ mkdir merge/file
> > Killed
> >
> > [ 2313.705789] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
>
> Good catch!
>
> Not hashing a negative dentry is not a good solution, however, because in the
> normal case cached negative dentries are quite useful and improve performance of
> various workloads.
>
> Here's a tested patch that should fix the real issue: vfs_rename() with
> RENAME_EXCHANGE must get two positive dentries.
>
> Amir, we need a test for this in one of the suites.  Which one is more
> appropriate, unionmount-testsuite or xfstests?

xfstests.
Its a simple regression test for a bug fix that mangles with underlying
files, much like overlay/010.

unionmount-testsuite never mangles with lower files - it is only testing
the VFS interface (+ few verification checks on underlying layers).

Thanks,
Amir.
