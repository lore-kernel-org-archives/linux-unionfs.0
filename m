Return-Path: <vgoyal@redhat.com>
Date: Fri, 6 Apr 2018 09:51:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 04/28] ovl: Provide a mount option metacopy=on/off
 for metadata copyup
Message-ID: <20180406135116.GA382@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
 <20180329193854.13814-5-vgoyal@redhat.com>
 <CAOQ4uxgkVZinCe7yE54ksVn8Tq-VwsBaMjFSS7-rUsES9F=wBg@mail.gmail.com>
 <20180402135640.GB23306@redhat.com>
 <CAOQ4uxiH-MTzJN+LA7igpeMH=qkejtmgc6hFnhVw2xhV40qLkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiH-MTzJN+LA7igpeMH=qkejtmgc6hFnhVw2xhV40qLkg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 11:16:36PM +0300, Amir Goldstein wrote:
> On Mon, Apr 2, 2018 at 4:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Mar 30, 2018 at 07:52:17AM +0300, Amir Goldstein wrote:
> >> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > By default metadata only copy up is disabled. Provide a mount option so
> >> > that users can choose one way or other.
> >> >
> >> > Also provide a kernel config and module option to enable/disable
> >> > metacopy feature.
> >> >
> >> > metacopy feature requires redirect_dir=on when upper is present. Otherwise,
> >> > it requires redirect_dir=follow atleast.
> >> >
> >> > Like index feature, we verify on mount that upper root is not being
> >> > reused with a different lower root.
> >>
> >> I don't see that in the patch
> >
> > Oh.., this is leftover from previous patches. Will remove this comment.
> > I have completely got rid of dealing with ORIGIN when moving to
> > REDIRECT based lookup.
> >
> >>
> >> > This hopes to get the configuration
> >> > right and detect the copied layers use case. But this does only so
> >> > much as we don't verify all the lowers. So it is possible that a lower is
> >> > missing and later data copy up fails.
> >> >
> >> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> > ---
> >> >  Documentation/filesystems/overlayfs.txt | 30 ++++++++++++++++++++++++-
> >> >  fs/overlayfs/Kconfig                    | 19 ++++++++++++++++
> >> >  fs/overlayfs/ovl_entry.h                |  1 +
> >> >  fs/overlayfs/super.c                    | 40 ++++++++++++++++++++++++++++++++-
> >> >  4 files changed, 88 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> >> > index 6ea1e64d1464..b7720e61973c 100644
> >> > --- a/Documentation/filesystems/overlayfs.txt
> >> > +++ b/Documentation/filesystems/overlayfs.txt
> >> > @@ -249,6 +249,30 @@ rightmost one and going left.  In the above example lower1 will be the
> >> >  top, lower2 the middle and lower3 the bottom layer.
> >> >
> >> >
> >> > +Metadata only copyup
> >> > +--------------------
> >> > +
> >> > +When metadata only copy up feature is enabled, overlayfs will only copy
> >> > +up metadata (as opposed to whole file), when a metadata specific operation
> >> > +like chown/chmod is performed. Full file will be copied up later when
> >> > +file is opened for WRITE operation.
> >> > +
> >> > +IOW, this is delayed data copy up operation and data is copied up when
> >> > +there is a need to actually modify data.
> >> > +
> 
> Vivek,
> 
> Some nick picking here.
> This is document is about the only decent documentation for overlayfs.
> I always try to live up to the standards set by Neil who started it.
> Abbreviations (IOW) doesn't seem right to me in this context.
> Also, you'll notice that the form "copyup" does not appear in this document.
> It may sound petty, but if people wish to read a coherent document about
> overlayfs, we would be wise to maintain coherency in the phrases we use
> throughout the document.

Ok, I will remove IOW. Also will replace "copyup" with "copy up".

Vivek
