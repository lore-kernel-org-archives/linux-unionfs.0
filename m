Return-Path: <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v5 2/5] overlay: hook filesystem check helper
References: <20180301121347.5824-1-yi.zhang@huawei.com>
 <20180301121347.5824-3-yi.zhang@huawei.com>
 <CAOQ4uxhAsV6-ENGrSrHNE+Ho8_N8+msGbWy8vBCkZXmeEabTYQ@mail.gmail.com>
 <f3d16204-701d-6aad-4f07-0f3824ae0bcc@huawei.com>
 <CAOQ4uxgNHx2Vc=CNvrmYEPfQpG0jzFsit_Z7t7GNkE6ZWWp+GQ@mail.gmail.com>
 <ebb8377e-7b59-1f89-37d1-4152247b0095@huawei.com>
 <CAOQ4uxhV0fwDXVst3DOu4zew2oH6TBLeyX6KFonK0=gOLX3zzQ@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <bd890419-88c6-e32f-92f2-3756f66de677@huawei.com>
Date: Mon, 12 Mar 2018 20:34:21 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhV0fwDXVst3DOu4zew2oH6TBLeyX6KFonK0=gOLX3zzQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/3/12 17:19, Amir Goldstein Wrote:
> On Mon, Mar 12, 2018 at 10:44 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2018/3/11 16:12, Amir Goldstein Wrote:
>>> On Thu, Mar 1, 2018 at 3:11 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>> On 2018/3/1 21:03, Amir Goldstein Wrote:
>>>>> On Thu, Mar 1, 2018 at 2:13 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>>> Hook filesystem check helper to _check_test_fs and _check_scratch_fs
>>>>>> for checking consistency of underlying dirs of overlay filesystem.
>>>>>> These helpers works only if fsck.overlay exists.
>>>>>>
>>>>>> This patch introduce OVERLAY_FSCK_OPTIONS use for check overlayfs like
>>>>>> OVERLAY_MOUNT_OPTIONS, and also introduce a mount point check helper in
>>>>>> common/rc to detect a dir is a mount point or not.
>>>>>>
>>>>>> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>>>>>
>>>>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>>>>> ---
>>>>>>  README.overlay | 10 ++++--
>>>>>>  common/config  |  4 +++
>>>>>>  common/overlay | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  common/rc      | 18 +++++++++--
>>>>>>  4 files changed, 127 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/README.overlay b/README.overlay
>>>>>> index dfb8234..3cbefab 100644
>>>>>> --- a/README.overlay
>>>>>> +++ b/README.overlay
>>>>>> @@ -22,6 +22,10 @@ the base fs should be pre-formatted before starting the -overlay run.
>>>>>>  An easy way to accomplish this is by running './check <some test>' once,
>>>>>>  before running './check -overlay'.
>>>>>>
>>>>>> +'./check -overlay' support check overlay test and scratch dirs,
>>>>>> +OVERLAY_FSCK_OPTIONS should be set instead of FSCK_OPTIONS if fsck
>>>>>> +options need to given directly.
>>>>>> +
>>>>>>  Because of the lack of mkfs support, multi-section config files are only
>>>>>>  partly supported with './check -overlay'. Only multi-section files that
>>>>>>  do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
>>>>>> @@ -40,7 +44,9 @@ run overlay tests on the same base fs, but with different mount options:
>>>>>>   MOUNT_OPTIONS="-o pquota"
>>>>>>   TEST_FS_MOUNT_OPTS="-o noatime"
>>>>>>   OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
>>>>>> + OVERLAY_FSCK_OPTIONS="-n redirect_dir=off"
>>>>>
>>>>> typo for the phony options. I believe it is going to be:  "-n -o
>>>>> redirect_dir=off"
>>>>
>>>> Oh, sorry for the mistake, it is "-n -o redirect_dir=off"
>>>>
>>>
>>> Zhangyi,
>>>
>>> One thing that has occurred to me now, which should be fixed before
>>> first release
>>> is that fsck.overlay should return an error for unknown/unsupported options
>>> (e.g. fsck.overlay -o blah doesn't complain).
>>> If this doesn't happen for first release then in the future we will
>>> not be able to
>>> write test scripts to check if installed fsck.overlay version supports
>>> feature X.
>>>
>> Yes, It's time to impliment the feature/option set and do the corresponding
>> work for the already known features. I am writing the kernel side feature set
>> recent days, I will add these feature into fsck.overlay after kernel's work done.
>>
>> BTW, the feature set in kernel do the following, some suggestions?
>> 1) Add feature set into upper root xattr "trusted.overlay.feature_[compat|imcompat|rocompat]"
>>    if user give mount options "xxx=on" or some feature xattr/dir detected.
>> 2) If unknown imcompat feature in xattr detected, fall back to try to ro-mount.
> 
> fail mount for unknown incompat
> 
>> 3) If unknown ro-compat featrure in xattr detected, mount fail.
> 
> fallback to ro-mount (see ext4_feature_set_ok())
> 

You are right, I get it.

>>
>>> About the possible meaning of <feature>=on/off and the meaning of <defaults>
>>> in the context of fsck.overlay, I think it is worth a separate
>>> discussion, but the
>>> way I see it:
>>> - When fsck.overlay *supports* a <feature> it should be able to detect if that
>>>   <feature> was ever enabled on overlay (e.g. known xattr exists or
>>> index dir exists).
>>
>> Agree, and we can also fix feature set when detect feature.
>>
>>> - When fsck.overlay detects an unknown <feature> it should abort
>>
>> Agree. A little more detail: if user specify upper and work dir, check imcompat
>> unknown feature; if not, check ro-imcompat unknown feature. If detected, fsck
>> about.
>>
> 
> No exactly. The difference between ext4 kernel driver and e2fsck -
> ext4 *allows* to mount with unknown compat features
> and *allows* to mount ro with unknonw ro-compat features.
> e2fsck *aborts* for any unknown compat/rocompat/incomapt feature
> 
> Meaning that you MAY be able to mount new ext4 with old kernel,
> but you CANNOT fsck new ext4 with old e2fsck
> 

Yes, you are right, I see this check in e2fsck/unix.c.

>>> - -o <feature>=off means wipe all traces of <feature> from overlay and fix if
>>>   necessary (e.g. make a copy of redirect dir before removing
>>> redirect_dir xattr)
>>
>> Agree. But not sure it is easy to implement of making a copy of redirect dir
>> when redirect_dir=off. Because it modify the directory hierarchy, it may affect
>> the origin/nlink xattr in files/dirs in index dir when index=on or nfs_export=on,
>> maybe also affect some other feature future.
>>
> 
> This is why fsck MUST refuse to run if it detects an unknown feature, even
> if that feature is "compatible" for rw mounting, fixing may break it.
> 

Right.

> And about disabling redirect_dir, yes, it means that all renamed directories
> are replaced with pure opaque (not indexed) directories and all the content
> from merged dir needs to be copied up recursively to the new directory.
> This is not trivial and may be time consuming, but with underlying fs clone
> support it is also not that bad.
> In fact, if you try to 'mv dir newdir' on overlay without redirect_dir, the 'mv'
> tool already does that fallback to create new dir and recursive rename.
> 

Yes, we can do the same thing like "mv" does when overlayfs doesn't support
rename syscall for dir(redirect_dir=off).

>>> - -o <feature>=on means bring overlay to a "feature consistent state",
>>> as if feature
>>>   was enabled from day 1 (e.g. index all copies up lower hardlinks)
>>
>> Agree.
>>
>>> - If <feature>=[on/off] is not specified, then if <feature> is not
>>> detected, it should
>>>   not be explicitly enabled and if feature is detected it should be
>>> made consistent
>>
>> Agree.
>>
>>> That last rule is certainly debatable, so maybe best if we leave that
>>> decision to
>>> admin via default policy configuration file.
>>>
>>
>> Something like /etc/mke2fs.conf but not for mkfs? Do you mean if feature
>> detected conflict with this config(eg: we detect redirect dir but "redirect_dir=off"
>> was setted in ths config file), fsck should check and fix fs according to this
>> config file?
>>
>> I think it may confusion and conflict with mount options(eg: redirect_dir=on)
>> previous mount or next mount. And IIUC, there is no such feature config file for
>> ext4/xfs, fsck.ext4 will detect feature from super block and fix fs according to
>> this detected result. So I think it's better to detect feature feature by fsck
>> itself, keep features as it was.
>>
> 
> I agree it is best to not ask user anything because user probably doesn't know
> the answer anyway. If you follow the discussion that has started on adding a
> config file for mkfs.xfs, you'll see it is mainly intended to be used
> by distributions.
> Imagine a disro that set the kernel config OVERLAY_FS_INDEX with the
> intention that all overlays will be indexed. This distro may want to make the
> default behavior of fsck.overlay to construct an index by default.
> 
> For you, the role of a config file is to reduce "bike shedding" - if there are
> conflicting options about what should be done in case feature X is detected
> or not detected and option X=on/off is not specified, instead of
> debating what the
> right thing to do by default, you delegate the decision to "config
> file" and set the
> hard coded default to what *you* think is the best behavior.
> 
> So my advise to you is to add a config file if and only if (or when) it
> becomes beneficial to you for reconciling different opinions.
> 

Yes, I get your point, It's a good point to avoid debate, and seems no
apparent defects. I'd like to add this file if no different opinions.

Thanks,
Yi.
