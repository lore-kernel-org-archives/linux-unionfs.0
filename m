Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-3-olga.kornievskaia@gmail.com> <20181027091240.GK6311@dastard>
 <20181027132339.GZ25444@bombadil.infradead.org> <20181028013307.GM6311@dastard>
 <CAN-5tyHPT4oYgWJTJg2pMbKoKCoqkf+dow1FXayD+r9gMZnh=Q@mail.gmail.com> <CAN-5tyEGoDma_mn3srk8pKR65Aq4EGWgmNU4oRML_aA9Enk72Q@mail.gmail.com>
In-Reply-To: <CAN-5tyEGoDma_mn3srk8pKR65Aq4EGWgmNU4oRML_aA9Enk72Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Oct 2018 19:49:43 +0200
Message-ID: <CAOQ4uxiWWzAB1M5EVK6+a+ncPKMk2q-LZr-m3snPQyV+rfOwDg@mail.gmail.com>
Subject: Re: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device copies
Content-Type: text/plain; charset="UTF-8"
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 5:52 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> On Mon, Oct 29, 2018 at 10:25 AM Olga Kornievskaia
> <olga.kornievskaia@gmail.com> wrote:
> >
> > On Sat, Oct 27, 2018 at 9:33 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Sat, Oct 27, 2018 at 06:23:39AM -0700, Matthew Wilcox wrote:
> > > > On Sat, Oct 27, 2018 at 08:12:40PM +1100, Dave Chinner wrote:
> > > > > > @@ -131,7 +132,8 @@ There is not enough space on the target filesystem to complete the copy.
> > > > > >  .B EXDEV
> > > > > >  The files referred to by
> > > > > >  .IR file_in " and " file_out
> > > > > > -are not on the same mounted filesystem.
> > > > > > +are not on the same mounted filesystem when the kernel does not support
> > > > > > +cross device file copy.
> > > > >
> > > > > Kernel can support cross device file copy, the filesystem may not.
> > > > >
> > > > > EXDEV
> > > > >     One of the files specified by file_in and file_out are on a
> > > > >     filesystem that does not support cross device copies.
> > > >
> > > > I mentioned this in my last review, and Olga pointed out that one of
> > > > the changes in this patch means the kernel will do the copy using
> > > > do_splice_direct if the filesystem doesn't support cross-device copying.
> > > > We should keep this error documented for those on old kernels, but the
> > > > kernel will never return -EXDEV any more.
> > >
> > > Uh, wot? Where's the patch named "VFS: enable copy_file_range() for
> > > all filesystems"? That shoul dnot be a detail hidden inside some
> > > other patch that multiple people completely miss during review.
> >
> > The fact that cross-device check was moved is what allowed for all
> > filesystems to use copy_file_range(). I think choosing the words of
> > "moving cross device check" was also appropriate title for the VFS
> > patch.
>
> I wasn't completely correct. It was the check removal and then also
> allowing for -EXDEV error to keep going with the  do_splice_direct().
> I could have left EXDEV being an error but thought it would be
> beneficial to add such ability. One reason to keep all the changes in
> one patch was said to be so that porting back all of this
> functionality is included.
>

Olga,

There are many details in this patch series and repeated miscommunications
about the details. Accuracy is important - "the reason to keep all changes" -
that was a commetn of mine referring *only* to the move of same sb check
from VFS to different filesystems.

The *extra* change of do_splice_direct cross fs was a very nice low
hanging fruit, but completely unrelated to your original  motivation.
I completely agree with Dave that it should be in a separate patch.
I also side with Dave that it would make sense as the first patch of the series.

> So one option would be keep EXDEV as an error if that's what folks
> want then this side-effect would not be a problem and the focus would
> be on what it was in the first place : removal (or relocation) of the
> cross device check into the filesystems.
>

This is up to you. It's an extra change and not related to your NFS work
and you may submit it or not. I think it will be nice if you did submit it.
There was no objection to this change, only objection was to bundle it together
with a different unrelated patch.

Thanks,
Amir.
