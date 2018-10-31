Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031095502.12504-1-mszeredi@redhat.com> <CAOQ4uxi9YX23C7NLQ2yqsz1Ur4nwMZFbQta=nBU=6bvYPU2YGg@mail.gmail.com>
 <CAJfpegtOzh9Z3xPJi6aFgzGazCVr5WHXaHw1s6mXMhpav0xT7A@mail.gmail.com>
In-Reply-To: <CAJfpegtOzh9Z3xPJi6aFgzGazCVr5WHXaHw1s6mXMhpav0xT7A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 12:33:40 +0200
Message-ID: <CAOQ4uxjeF=+GWzO2WgEaWds4Riory+QgxSPywLHT2_Bxqz=q4w@mail.gmail.com>
Subject: Re: [PATCH] overlay: create directory over deleted whiteout
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 12:26 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 31, 2018 at 11:17 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Oct 31, 2018 at 11:55 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >>
> >> There's a bug in the overlayfs implementation starting from the very first
> >> merged version that may cause an Oops of various forms if a directory is created
> >> over a whiteout dentry, but the actual whiteout on the upper layer was removed
> >> to the directory creation.
> >>
> >> Reported by: kaixuxia <xiakaixu1987@gmail.com>
> >> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> >> ---
> >
> > Looks good. A bit of commentary could be useful...
>
> Okay.
>
> >> +
> >> +# unmount overlayfs
> >> +$UMOUNT_PROG $SCRATCH_MNT
> >
> > Umount of scratch is not needed at the end of the test.
>
> It's not strictly needed, but gives additional assurance that things
> hadn't gone bad (after the oops umount returns with EBUSY).
>

But the test harness unmount the scratch mount anyway
and if you have fsck.overlay installed it also runs fsck.overay on the layers
after each test.

The question is why do you need the umount command in the test itself?
Is the output/result different without the explicit umount command in the test?

Thanks,
Amir.
