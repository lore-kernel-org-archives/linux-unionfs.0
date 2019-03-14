Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181207121027.GA5996@dnyarri> <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri> <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri> <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
 <20190314010928.GA748@dnyarri> <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 Mar 2019 12:40:52 +0200
Message-ID: <CAOQ4uxifMY+CLeVoPXF3UORtAdcM1Uq_nxsCyc6cgpKK8ObK8w@mail.gmail.com>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Content-Type: text/plain; charset="UTF-8"
To: aszlig <aszlig@nix.build>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, cleverca22@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 14, 2019 at 9:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Mar 14, 2019 at 3:09 AM aszlig <aszlig@nix.build> wrote:
> >
> > On Sun, Feb 03, 2019 at 03:51:53PM +0200, Amir Goldstein wrote:
> > > OK, what I don't understand and requires debugging is that the print of
> > > (realfile, IS_ERR(realfile) ? 0 : realfile->f_flags) suggests that realfile
> > > is not an error value and realfile->f_flags are 0.
> >
> > Just got back to debugging this properly.
> >
> > I think you're confusing the same thing as I ded when first looking at the
> > code, because realfile actually _is_ an error in this case, so the output is
> > correct (I personally probably also got confused because of the
> > realinode/realfile variable names).
> >
> > So after debugging this further (and totally digging in wrong places at first)
> > I found that the actual problem here is the O_NOATIME flag that is passed to
> > the underlying file system. If you look in fs/namei.c in function may_open(),
> > there is a check for inode_owner_or_capable().
> >
> > Being able to read a file despite being the owner but having read permissions
> > is pefectly fine, but due to the fact that O_NOATIME is passed, the open()
> > fails.
> >
> > Now in normal situations where the overlayfs is mounted as root, this shouldn't
> > be a problem, but as soon as you have a networked file system, things go bad.
> >
> > That's what happened in our case, where we have a 9p file system mounted in a
> > guest VM and a lowerdir of overlayfs on top of that. If the file owner on the
> > host is the same as the current uid of qemu process, the open() works
> > correctly. However if it's not the case, it will fail with EPERM on the host
> > side (even though you have read access).
> >
> > The attached patch simply removes the O_NOATIME flag, which fixes the issue.
> >
> > I originally thought about adding a condition on whether to add the flag, but I
> > only see two options here, which IMHO are bad in their own rights:
> >
> >   * Using inode_owner_or_capable() to check whether to add O_NOATIME, which has
> >     the downside that it will not work with networked file systems where you
> >     map different users (I've tested this already with a different patch[1]).
> >   * Check for failure of open_with_fake_path() and retry without O_NOATIME,
> >     which *could* be an option, but I think that might come with a performance
> >     penalty.
> >
> > Actually, a third option would be to just ignore O_NOATIME in fs/namei.c
> > instead of returning -EPERM, but I think that could open up a whole range of
> > other bugs.
> >
> > In summary, I think just removing O_NOATIME IMHO is the most sensible option,
> > because it doesn't cause problems with network filesystems and also leaves the
> > atime/noatime decision to the administrator of the corresponding system.
> >
> > Or is there something that I've missed where one is in dire need of O_NOATIME?
> >
>
> Overlayfs is not expected to modify the lower layer.
>
> OTOH, I can't really think anything that should break horribly if
> we allow overlayfs to update atime on a writable lower layer??
>

All right. But O_NOATIME would not be needed at all
if the fake path.mnt had MNT_NOATIME.

You could try to play around with passing realpath to
open_with_fake_path(), i.e.:

ovl_path_real(file_dentry(file), &realpath);

This will also provide the MNT_READONLY write protection
of the lower layer (in case we have a bug).

I am not sure if there were other considerations for using the
overlay path as fake path. Miklos?

Also, I am not quite sure about the reason for this:
        /* Don't inherit atime flags */
        upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);

And whether it is still correct with stacked file ops?

Thanks,
Amir.
