From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][V4] ovl: fix lookup failure on multi lower squashfs
Date: Thu, 14 Nov 2019 16:37:17 +0100
Message-ID: <CAJfpegufS=OGcvFbWEVumNSCPO_JXyEuJNAbmO5ubscSarVtRQ@mail.gmail.com>
References: <20191113200651.114606-1-colin.king@canonical.com>
 <CAJfpegug-saOEigqDNKfwMR5qdzrbLnRBD=0eN5juGioFH_L_Q@mail.gmail.com> <CAOQ4uxgf5KAq7VoHVNVUD9QtA7Y++-_TdwOe6=icHLgJvyrg1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgf5KAq7VoHVNVUD9QtA7Y++-_TdwOe6=icHLgJvyrg1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Colin King <colin.king@canonical.com>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 14, 2019 at 3:43 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Nov 14, 2019 at 12:30 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Nov 13, 2019 at 9:06 PM Colin King <colin.king@canonical.com> wrote:
> > >
> > > From: Amir Goldstein <amir73il@gmail.com>
> > >
> > > In the past, overlayfs required that lower fs have non null
> > > uuid in order to support nfs export and decode copy up origin file handles.
> > >
> > > Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
> > > lower fs") relaxed this requirement for nfs export support, as long
> > > as uuid (even if null) is unique among all lower fs.
> >
> > I see another corner case:
> >
> > n- two filesystems, A and B, both have null uuid
> >  - upper layer is on A
> >  - lower layer 1 is also on A
> >  - lower layer 2 is on B
> >
> > In this case bad_uuid won't be set for B, because the check only
> > involves the list of lower fs.  Hence we'll try to decode a layer 2
> > origin on layer 1 and fail.
>
> Right.
>
> >
> > Can we fix this without special casing lower layer fsid == 0 in
> > various places?  I guess that involves using lower_fs[0] for the
> > fsid=0 case (i.e. index lower_fs by fsid, rather than (fsid -1)).
> > Probably warrants a separate patch.
> >
>
> I guess we should.
> I do hate that special casing.
> I can work of that, but would you like to hold back this patch now?
> Or just fix that corner case later?

Okay, let's fix the main case first, then the corner case...

Thanks,
Miklos
