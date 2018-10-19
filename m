Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181016074559.24728-1-yi.zhang@huawei.com> <20181016074559.24728-3-yi.zhang@huawei.com>
 <CAOQ4uxhJRxMqMzMn_zm+1LyaAUuRmMmr=YNPshX7U2MAUTtmYw@mail.gmail.com>
 <c3b4ba3b-001d-ad70-445f-f0c1ce5d17f0@huawei.com> <CAOQ4uxgZCWFR5qr-6z4DH=UrtqX+Q2aY=XiX2bEpFNpeDvN2OA@mail.gmail.com>
 <dfe2286a-e0f1-29f7-6ae2-aaf32ad203db@huawei.com>
In-Reply-To: <dfe2286a-e0f1-29f7-6ae2-aaf32ad203db@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Oct 2018 17:00:30 +0300
Message-ID: <CAOQ4uxjAJ_X0=jCaGqxycOjJYH2XfyNXEH2LS=gDkuHZjaaSnQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] overlay: fix exit code for some fsck.overlay valid cases
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 19, 2018 at 3:36 PM zhangyi (F) <yi.zhang@huawei.com> wrote:
>
> On 2018/10/18 12:44, Amir Goldstein Wrote:
> > On Thu, Oct 18, 2018 at 6:43 AM zhangyi (F) <yi.zhang@huawei.com> wrote=
:
> >>
> >> On 2018/10/16 17:26, Amir Goldstein Wrote:
> >>> On Tue, Oct 16, 2018 at 10:32 AM zhangyi (F) <yi.zhang@huawei.com> wr=
ote:
> >>>>
> >>>> Some valid test cases about fsck.overlay may be not valid enough now=
,
> >>>> they lose the impure xattr on the parent directory of the simluated
> >>>> redirect directory, and lose the whiteout which use to cover the ori=
gin
> >>>> lower object. Then fsck.overlay will fix these two inconsistency whi=
ch
> >>>> are not those test cases want to cover, thus it will lead to
> >>>> fsck.overlay return FSCK_NONDESTRUCT instead of FSCK_OK. Fix these b=
y
> >>>> complement the missing overlay related features.
> >>>>
> >>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> >>>> ---
> >>>
> >>> Ok. I think it's fine if we merge this fix now, but this way it is go=
ing
> >>> to be quite hard to maintain this test.
> >>>
> >>> Imagine every time that you add another feature to fsck.overlay,
> >>> say "add overlay features xattr", fsck will start returning FSCK_NOND=
ESTRUCT
> >>> and break this test.
> >>>
> >>> Perhaps it would have been better to construct the test cases by:
> >>> - mount overlay
> >>> - create some copied up/ redirected  dirs and whiteouts
> >>> - umount overlay
> >>> - make minor modifications to upper/lower layer
> >>> - run fsck
> >>>
> >>> Then you wouldn't need to worry about things like impure parent dir
> >>> and future overlay features.
> >>>
> >>> I will leave it to you to decide if you want to fix this now or the
> >>> next time around...
> >>>
> >>
> >> Indeed, I thought about this choice. If we create overlay on-disk feat=
ures
> >> (xattrs=EF=BC=8Cwhiteouts...) through overlayfs, the fsck tests result=
s becomes
> >> non-independent. It will depends on the kernel (overlayfs module) user=
 are
> >> running the test. Imaging if user want to test the latest fsck.overlay
> >> on the old kernel which contains a compatible feature xattr fsck.overl=
ay
> >> know but the kernel don't, we will get the unexpected result. Or maybe
> >> we can add some _require_xxx_feature() helper to enforce user doing te=
st
> >> on the kernel which supports the specified feature?
> >>
> >
> > I think the only sane choice is for this test to relax the expectation =
of 0
> > exit code to "correct" exit code (i.e. _overlay_repair_dirs()) for the =
"Valid"
> > test cases.
> >
> The meaning of the "valid" test cases is to make sure fsck.overlay will n=
ever
> change the on-disk filesystem if the feature(xattr) we want to test is va=
lid,
> so the FSCK_OK and FSCK_NONDESTRUCT is totally different.
>
> If we relax the expectation of 0(FSCK_OK) exit code, we couldn't distingu=
ish
> the fsck was changed the file system or not, if so, we also couldn't dist=
inguish
> it's caused by some bugs of fsck or the base dirs were not valid enough. =
Then
> the "valid" test cases cannot catch fsck's fault accurately. So I think m=
ake
> a valid enough overlay image manually now is still the best way.
>
> I think maybe after we introduce "feature set" xattr, it will becomes muc=
h easier,
> fsck.overlay will fix things according to feature set, and we create over=
lay image
> through mkfs.overlay. So we could disable some irrelevant features to avo=
id
> disturbing our tests. Is it fine?
>

Its fine by me to re-open this for discussion that next time fsck.overlay
changes and breaks the test.

Thanks,
Amir.
