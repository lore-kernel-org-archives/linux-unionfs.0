Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-3-olga.kornievskaia@gmail.com> <20181027091240.GK6311@dastard>
 <20181027132339.GZ25444@bombadil.infradead.org> <20181028013307.GM6311@dastard>
In-Reply-To: <20181028013307.GM6311@dastard>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 10:25:18 -0400
Message-ID: <CAN-5tyHPT4oYgWJTJg2pMbKoKCoqkf+dow1FXayD+r9gMZnh=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device copies
Content-Type: text/plain; charset="UTF-8"
To: david@fromorbit.com
Cc: willy@infradead.org, trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 9:33 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Oct 27, 2018 at 06:23:39AM -0700, Matthew Wilcox wrote:
> > On Sat, Oct 27, 2018 at 08:12:40PM +1100, Dave Chinner wrote:
> > > > @@ -131,7 +132,8 @@ There is not enough space on the target filesystem to complete the copy.
> > > >  .B EXDEV
> > > >  The files referred to by
> > > >  .IR file_in " and " file_out
> > > > -are not on the same mounted filesystem.
> > > > +are not on the same mounted filesystem when the kernel does not support
> > > > +cross device file copy.
> > >
> > > Kernel can support cross device file copy, the filesystem may not.
> > >
> > > EXDEV
> > >     One of the files specified by file_in and file_out are on a
> > >     filesystem that does not support cross device copies.
> >
> > I mentioned this in my last review, and Olga pointed out that one of
> > the changes in this patch means the kernel will do the copy using
> > do_splice_direct if the filesystem doesn't support cross-device copying.
> > We should keep this error documented for those on old kernels, but the
> > kernel will never return -EXDEV any more.
>
> Uh, wot? Where's the patch named "VFS: enable copy_file_range() for
> all filesystems"? That shoul dnot be a detail hidden inside some
> other patch that multiple people completely miss during review.

The fact that cross-device check was moved is what allowed for all
filesystems to use copy_file_range(). I think choosing the words of
"moving cross device check" was also appropriate title for the VFS
patch.

To other what you thought was the main change was a side-effect or at
least that's not where the discussion was centered. The discussion was
focused on the fact that there is cross device of same and different
file systems and such discussion deemed appropriate to be noted
clearly in the commit message. The proposed commit message below
doesn't capture it.

I'm fine with the commit message below as well. If that's acceptable
to others. I can change the commit to the wording below.

When I started reading the message I thought your comments where about
the "man-page" patch that it lacked the wording including in the VFS
patch. So to clarify, do you have any objections to the wording in the
man-page patch or was this just about the VFS patch?

> If we are completely changing the kernel's behaviour, the patch
> should be explicitly named to call out the change of behaviour, and
> the commit message should clearly explain the change being made and
> why.
>
> /me goes looking.
>
> Yup, it is only mentione din passing as a side-effect of an
> implementation change. That's back to front. Describe the behaviour
> change, what users will see and the reasons for making the change,
> leave the code to describe exactly what the change is. Then you can
> describe the actions needed to make the new functionality work. e.g.
> The first patch shoul dbe described as:
>
> VFS: generic cross-device copy_file_range() support for all filesystems

> From: ....
>
> In preparation for enabling cross-device offloading of
> copy_file_range() functionality, first enable generic cross-device
> support by allowing copy_file_range() to fall back to a page cache
> based physical data copy. This means the copy_file_range() syscall
> will never fail with EXDEV, and so in future userspace will not need
> to detect or provide a fallback for failed cross-device copies
> anymore.
>
> This requires pushing the cross device support checks down into the
> filesystem ->copy_file_range methods and falling back to the page
> cache copy if they return EXDEV.
>
> Further, clone_file_range() is only supported within a filesystem,
> so we must also check that the files belong to the same superblock
> before calling ->clone_file_range(). If they are on different
> superblocks, skip the attempt to clone the file and instead try to
> copy the file.
>
> S-o-B: .....

>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
