Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190328153829.729-1-amir73il@gmail.com> <20190329154020.GA4104@redhat.com>
In-Reply-To: <20190329154020.GA4104@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 29 Mar 2019 22:43:47 +0300
Message-ID: <CAOQ4uxjGDDkuXxj5actEsnztCYbkSxvyCzH4FTVbig8Hohsb+w@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 29, 2019 at 6:40 PM Vivek Goyal <vgoyal@redhat.com> wrote:
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
>
> Hi Amir,
>
> Just to understand better this case, so does following fail.
>
> ovl_verify_inode)() {
>         if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry))
>                 return false;
> }
>
> Because we already found hashed inode (as lower real file), so
> ovl_inode_upper(inode) will not be set and ovl_verify_inode() will fail.
>

Yes, that's the story I told.
I have no proof that this is what happened.
But the above seems possible in the code.

> >
> > Overlapping layers is considered a wrong setup which would result in
> > unexpected behavior, but it shouldn't crash the kernel and it shouldn't
> > trigger WARN_ON() either, so relax this WARN_ON() and leave a pr_warn()
> > instead to cover all cases of failure to get an overlay inode.
>
> Is this not equivalent of lower layers being modified while overlay
> being mounted. If that's the case, then WARN_ON_ONCE() kind of makes
> sense to flag the anomaly in underlying layers?
>
> IOW, overlayfs is not crashing. It is just warning for an anomaly it
> found due to overlapping layers. And what's wrong with giving the
> warning?
>

User input (fuzzing) should not trigger BUG_ON/WARN_ON
Those are asserts that claim a bug in the code, not wrong input.
In similar cases like these that we ran into in the past we converted
overlayfs code to pr_warn_ratelimited().


> >
> > The error returned from failure to insert new inode to cache with
> > inode_insert5() was changed to -EEXIST, to distinguish from the error
> > -ENOMEM returned on failure to get/allocate inode with iget5_locked().
>
> This is a separate cleanup and not related to this issue, do I
> understand it right?
>

Right, but I would like to be able to get an affirmation to the theory
above. Another way to get to WARN_ON() is if inode_insert5()
finds an I_CREATING inode, but I don't think this can be the case here.

Thanks,
Amir.
