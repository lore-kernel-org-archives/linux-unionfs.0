Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190328153829.729-1-amir73il@gmail.com> <20190328214008.GB3559@redhat.com>
In-Reply-To: <20190328214008.GB3559@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 29 Mar 2019 00:20:37 +0200
Message-ID: <CAOQ4uxijiUOvfndP25=WDsVME-nA=uau3idFyo1J8Rh4tfD9YA@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 28, 2019 at 11:40 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Mar 28, 2019 at 05:38:29PM +0200, Amir Goldstein wrote:
> > This nasty little syzbot repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
> >
> > Creates overlay mounts where the same directory is both in upper
> > and lower layers. Simplified example:
> >
> >   mkdir foo work
> >   mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"
> >
> > The repro runs several threads in parallel that attempt to chdir
> > into foo and attempt to symlink/rename/exec/mkdir the file bar.
> >
> > The repro hits a WARN_ON() I placed in ovl_instantiate(), which
> > suggests that an overlay inode already exists in cache and is hashed
> > by the pointer of the real upper dentry that ovl_create_real() has
> > just created. At the point of the WARN_ON(), for overlay dir inode
> > lock is held and upper dir inode lock, so at first, I did not see how
> > this was possible.
> >
> > On a closer look, I see that after ovl_create_real(), because of the
> > overlapping upper and lower layers, a lookup by another thread can
> > find the file foo/bar that was just created in upper layer, at overlay
> > path foo/foo/bar and hash the an overlay inode with the new real dentry
> > as lower dentry. This is possible because the overlay directory
> > foo/foo is not locked and the upper dentry foo/bar is in dcache, so
> > ovl_lookup() can find it without taking upper dir inode shared lock.
> >
> > Overlapping layers is considered a wrong setup which would result in
> > unexpected behavior, but it shouldn't crash the kernel and it shouldn't
> > trigger WARN_ON() either,
>
> Hi Amir,
>
> Is it possible detect this overlapping layer configuration and fail the
> mount instead (is_subdir())?
>

Possible? Yes - see ovl_workdir_ok(), feel free to post a patch...

Race free? Not that I know of.

Instead of the fix - No, because upper dir can be moved under lower
layer root also after mount (same for work dir btw) and there are
likely other ways to make a mess that do not involve moving the
layer root (cross layer hardlinks are not pretty).

That is the incentive to my proposal of "rename fences":
https://marc.info/?l=linux-fsdevel&m=155082091218483&w=2

Thanks,
Amir.
