Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190528151723.12525-1-amir73il@gmail.com> <20190528151723.12525-4-amir73il@gmail.com>
 <20190602070949.GS15846@desktop>
In-Reply-To: <20190602070949.GS15846@desktop>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 2 Jun 2019 11:07:01 +0300
Message-ID: <CAOQ4uxgvajS+JzAc9NTNHF4XtYDp_mqV22dDZ73uEu72uQJP1g@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] overlay: correct fsck.overlay exit code
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jun 2, 2019 at 10:26 AM Eryu Guan <guaneryu@gmail.com> wrote:
>
> On Tue, May 28, 2019 at 06:17:22PM +0300, Amir Goldstein wrote:
> > From: "zhangyi (F)" <yi.zhang@huawei.com>
> >
> > fsck.overlay should return correct exit code to show the file system
> > status after fsck, instead of return 0 means consistency and !0 means
> > inconsistency or something bad happened.
> >
> > Fix the following three exit code after running fsck.overlay:
> >
> > - Return FSCK_OK if the input file system is consistent,
> > - Return FSCK_NONDESTRUCT if the file system inconsistent errors
> >   corrected,
> > - Return FSCK_UNCORRECTED if the file system still have inconsistent
> >   errors.
> >
> > This patch also add a helper function to run fsck.overlay and check
> > the return value is expected or not.
> >
> > [amir] rename helper to _overlay_fsck_expect, split define of FSCK_*
> > to a seprate path.
> >
> > Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  common/overlay    | 19 +++++++++++++++++++
> >  tests/overlay/045 | 27 +++++++++------------------
> >  tests/overlay/046 | 36 ++++++++++++------------------------
> >  tests/overlay/056 |  9 +++------
> >  4 files changed, 43 insertions(+), 48 deletions(-)
> >
> > diff --git a/common/overlay b/common/overlay
> > index a71c2035..53e35caf 100644
> > --- a/common/overlay
> > +++ b/common/overlay
> > @@ -193,6 +193,25 @@ _overlay_fsck_dirs()
> >                          -o workdir=$workdir $*
> >  }
> >
> > +# Run fsck and check for expected return value
> > +_overlay_fsck_expect()
> > +{
> > +     # The first arguments is the expected fsck program exit code, the
> > +     # remaining arguments are the input parameters of the fsck program.
> > +     local expect_ret=$1
> > +     local lowerdir=$2
> > +     local upperdir=$3
> > +     local workdir=$4
> > +     shift 4
> > +
> > +     _overlay_fsck_dirs $lowerdir $upperdir $workdir $* >> \
> > +                     $seqres.full 2>&1
> > +     fsck_ret=$?
> > +
> > +     [[ "$fsck_ret" == "$expect_ret" ]] || \
> > +             echo "fsck return unexpected value:$expect_ret,$fsck_ret"
>
> This statement looks ambiguous, it's not that clear which return value
> is expected and which is unexpected. I'd like to change it to something
> like:
>
> "expect fsck.overlay to return $expect_ret, but got $fsck_ret"
>
> I can fix it on commit if you're OK with this change.
>

Fine by me.

Thanks,
Amir.
