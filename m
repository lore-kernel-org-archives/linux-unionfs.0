Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7921d87b-daaa-e436-8464-9ab1203fd8f7@huawei.com>
References: <20180223120106.32921-1-yangerkun@huawei.com> <CAOQ4uxj7Bg5vjoCtke=R1D3aG73rNRg_hKJofkJWk0vjfcxyMw@mail.gmail.com>
 <733feaf3-0885-b57d-674d-2ebcb963484a@huawei.com> <CAOQ4uxg3G=V7+eGMt8snHf0TFgfrYO2BLdyKPHUHqy=aQh=fKw@mail.gmail.com>
 <7921d87b-daaa-e436-8464-9ab1203fd8f7@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Feb 2018 09:07:52 +0200
Message-ID: <CAOQ4uxgo=xZbqiqp=BA0+4RTKQZFqErowdmTiVQqTcsmgM59mw@mail.gmail.com>
Subject: Re: [PATCH] fsck.overlay: add ovl_check_origin helper
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: yangerkun <yangerkun@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 4:10 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2018/2/25 2:46, Amir Goldstein wrote:
>> On Sat, Feb 24, 2018 at 11:36 AM, yangerkun <yangerkun@huawei.com> wrote=
:
[...]

>>>> I suggest at least the following safely checks on start of fsck.overla=
y:
>>>> - Check if index dir exists in workdir
>>>> - Check if upperdir root has an unrecognized origin xattr format
>>>> - Check if index dir root has an unrecognized origin xattr format
>>>>
>>>> If any of the checks above is positive, fsck.overlay should issue a
>>>> warning
>>>> and refuse to fix fielsystem. Running with -n -f is allowed.
>>>> See if index dir exists, then removing origin xattr can corrupt the in=
dex.
>>>> When fsck.overlay gains the knowledge about checking and fixing index,
>>>> user would opt-in to checking an overlayfs with index by -o index=3Don
>>>
>>>
>>> When compile the kernel, we can choose the default config about overlay=
,
>>> which user won't get. So, user may choose the fault arguments like
>>> "fsck.overlay -olower..." while index xattr is on when there is really
>>> overlayfs. Other filesystems can get xattr from superblock in disk, but=
 we
>>> cannot use this way in overlay. So, how to deal with this=EF=BC=9F
>>>
>>>
>>
>> The kernel default options for overlayfs mount really does not matter fo=
r
>> fsck.overlay. The only thing that matters is to detect whether the layer=
s
>> were *ever* mounted by a kernel which enabled features that fsck.overlay
>> does not support.
>>
>> The current state of fsck.overlay is:
>> - supports redirect feature
>> - does not support any other feature including upstream features index a=
nd
>> nfs_export and future features like metacopy.
>>
>> A filesystem repair tool should NOT fix the filesystem if it detects on-=
disk
>> format that it does not recognize.
>>
>> That means among other things for overlayfs that if an xattr if found on=
 any
>> file by the name of trusted.overlay.<something> and <something> is not a
>> an expected name, then fsck.overlay should shout that it does not
>> recognize the on-disk format (print out the unrecognized xattr name) and
>> refuse to continue.
>>
>> The problem with overlayfs compares to traditional filesystems is the la=
ck
>> of "feature bits" in the "super block", so there is no O(1) test for uns=
upported
>> features, but they still can be detected.
>>
>> Contrary to the example above, there is a simple O(1) test to check if
>> overlayfs was mounted with index feature enabled - the existence of a
>> non empty $workdir/index dir is de-facto a "feature bit" and until fsck.=
overlay
>> knows how to verify and fix overlayfs without corrupting the index it sh=
ould
>> refuse to fix an overlay filesystem with an index.
>>
>
> Maybe we can store "feature bit" in upper root xattr or somewhere else in=
 workdir
> after we implement mkfs.overlay, and classify them into compat and incomp=
at
> features, we can use old fsck.overlay to fix the filesystem if there is n=
o
> unrecognized incompat feature.
>

Yes, we could and probably should.

A "feature set" as xattr was proposed by Miklos when introducing
redirect_dir [1].
and then I proposed a different implementation of "feature set" when introd=
ucing
index feature [2].

The biggest problem with these implementation is that old kernel doesn't kn=
ow
about the incompat features.
For this problem, fsck.overlay is at least a partial solution, because
it will be possible
for user to run fsck.overlay to "sanitize" an overlayfs for mount with
old kernel, for
example:
fsck.overlay -o redirect_dir=3Doff,index=3Doff  (*)
could be used to sanitize overlayfs for mount on kernel < v4.10.

(*) Another option is to follow mkfs.ext4/tune2fs standard of -O
^redirect_dir,^index.

IMO, now that fsck.overlayfs has materialized, thanks to you,
it is a good time to set the feature set format in stone and implement it i=
n
kernel and fsck (hint hint, if you post I will review...)

> Before this, the index dir can be treated as a kind of "unrecognized inco=
mpat
> feature", so the "simple O(1) test" can works well, but how can we handle
> another incompat feature tomorrow? Should we implement mkfs.overlay befor=
e the
> first release version of fsck.overlay?
>

I wouldn't say that we need to implement mkfs.overlay, but we *do*
need to define
the feature set on-disk format and fsck.overlay *does* have to check
the incomapt
features from the very first release and new kernel *should* check and set =
the
"feature bits".
I am in favor of something similar to [1], but with
3 sets of features: compat,incompat,rocompat.

If I am not missing anything, upstream overlayfs now supports 4 on-disk for=
mat
features that were not supported in the first upstream release (v3.18):
incomapt: redirect_dir
rocompat: index,nfs_export
compat: constant_ino (i.e. origin+impure xattr)

redirect_dir can be detected only by scanning all dirs.
constant_ino can be detected only by scanning all files. It's not really th=
at
important to cleanup a compat feature that the first version of fsck suppor=
ts,
but its not hard to implement it either.
index can be detected by checking index dir exists (or not empty).
nfs_export can be detected by checking if index dir contains whiteout
and directory entries.

IMO we should not merge another incompat feature like metacopy before
defining the feature set format and setting the incompat "feature bit" on
first mount with metacopy enabled.

Thanks,
Amir.

[1] https://marc.info/?l=3Dlinux-unionfs&m=3D147739471816673&w=3D2
[2] https://marc.info/?l=3Dlinux-unionfs&m=3D150885903123037&w=3D2
