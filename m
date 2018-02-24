Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <733feaf3-0885-b57d-674d-2ebcb963484a@huawei.com>
References: <20180223120106.32921-1-yangerkun@huawei.com> <CAOQ4uxj7Bg5vjoCtke=R1D3aG73rNRg_hKJofkJWk0vjfcxyMw@mail.gmail.com>
 <733feaf3-0885-b57d-674d-2ebcb963484a@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Feb 2018 20:46:08 +0200
Message-ID: <CAOQ4uxg3G=V7+eGMt8snHf0TFgfrYO2BLdyKPHUHqy=aQh=fKw@mail.gmail.com>
Subject: Re: [PATCH] fsck.overlay: add ovl_check_origin helper
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: yangerkun <yangerkun@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Feb 24, 2018 at 11:36 AM, yangerkun <yangerkun@huawei.com> wrote:
>
>
> On 2/24/2018 3:43 PM, Amir Goldstein wrote:
>>
>> On Fri, Feb 23, 2018 at 2:01 PM, yangerkun <yangerkun@huawei.com> wrote:
>>>
>>> For origin xattr, use fid in ovl_fh to consume file_handle, and use
>>> open_by_handle_at to check validity of the origin ovl_fh. In auto mode,
>>> the invalid origin xattr will remove automatic.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
[...]
>>> +
>>> +/*
>>> + * Check the validity of ovl_fh.
>>> + */
>>> +int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
>>> +{
>>> +       if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
>>> +               return -EINVAL;
>>> +
>>> +       if (fh->magic !=3D OVL_FH_MAGIC)
>>> +               return -EINVAL;
>>> +
>>> +       if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_AL=
L)
>>> +               return -ENODATA;
>>> +
>>> +       if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
>>> +           (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) !=3D
>>> OVL_FH_FLAG_CPU_ENDIAN)
>>> +               return -ENODATA;
>>> +
>>
>>
>> Overlayfs approach to unrecognized ovl_fh on-disk format is very
>> naiive borderline buggy.
>> When endian/flags/version check fails, origin is treated as "unknown"
>> and that is fine as
>> long as the only implication is change of inode number.
>> But when checking that origin of upper root matches lower root for
>> index feature, treating
>> unrecognized ovl_fh format as unknown will result in overwriting the
>> root origin and as
>> far as I can tell, this is a bug.
>>
>> The situation with fsck.overlayfs is even worse IMO, because running
>> an old fsck tools
>> is even more easy to get wrong than mounting an overlayfs with an old
>> kernel.
>> In general fsck.* tools, like e2fsck, are more prudent about fixing a
>> filesystem
>> with unknown on-disk format than the kernel about mounting filesystem
>> with unknown
>> on-disk format features.
>>
>> This patch specifically does not seem to do any harm when encountering
>> unknown
>> on-disk format of ovl_fh, but I think fsck.overlay should take some
>> extra steps for
>> safety, before fixing overlayfs with features that fsck.overlay does
>> not support.
>>
>> I suggest at least the following safely checks on start of fsck.overlay:
>> - Check if index dir exists in workdir
>> - Check if upperdir root has an unrecognized origin xattr format
>> - Check if index dir root has an unrecognized origin xattr format
>>
>> If any of the checks above is positive, fsck.overlay should issue a
>> warning
>> and refuse to fix fielsystem. Running with -n -f is allowed.
>> See if index dir exists, then removing origin xattr can corrupt the inde=
x.
>> When fsck.overlay gains the knowledge about checking and fixing index,
>> user would opt-in to checking an overlayfs with index by -o index=3Don
>
>
> When compile the kernel, we can choose the default config about overlay,
> which user won't get. So, user may choose the fault arguments like
> "fsck.overlay -olower..." while index xattr is on when there is really
> overlayfs. Other filesystems can get xattr from superblock in disk, but w=
e
> cannot use this way in overlay. So, how to deal with this=EF=BC=9F
>
>

The kernel default options for overlayfs mount really does not matter for
fsck.overlay. The only thing that matters is to detect whether the layers
were *ever* mounted by a kernel which enabled features that fsck.overlay
does not support.

The current state of fsck.overlay is:
- supports redirect feature
- does not support any other feature including upstream features index and
nfs_export and future features like metacopy.

A filesystem repair tool should NOT fix the filesystem if it detects on-dis=
k
format that it does not recognize.

That means among other things for overlayfs that if an xattr if found on an=
y
file by the name of trusted.overlay.<something> and <something> is not a
an expected name, then fsck.overlay should shout that it does not
recognize the on-disk format (print out the unrecognized xattr name) and
refuse to continue.

The problem with overlayfs compares to traditional filesystems is the lack
of "feature bits" in the "super block", so there is no O(1) test for unsupp=
orted
features, but they still can be detected.

Contrary to the example above, there is a simple O(1) test to check if
overlayfs was mounted with index feature enabled - the existence of a
non empty $workdir/index dir is de-facto a "feature bit" and until fsck.ove=
rlay
knows how to verify and fix overlayfs without corrupting the index it shoul=
d
refuse to fix an overlay filesystem with an index.

The options that will be passed to fsck.overlay (i.e.
redirect_dir=3Doff, index-on)
will not mean that  fsck.overlay should or should not check redirects/index=
.
They will mean something like:
index=3Don - reconstruct index for copied up hardlinks
redirect_dir=3Doff - remove all redirects and recursively "move" all
copied up files.

Thanks,
Amir.
