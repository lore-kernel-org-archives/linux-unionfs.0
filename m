From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 11:35:00 +0800
Message-ID: <75c3288d-a2d5-d476-17a9-06b56f187152@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
 <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:37503 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754824AbdLODff (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:35:35 -0500
In-Reply-To: <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, miaoxie@huawei.com

On 2017/12/14 22:13, Miklos Szeredi Wrote:
> On Thu, Dec 14, 2017 at 7:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> fsck.overlay
>> ============
>>
>> fsck.overlay is used to check and optionally repair underlying
>> directories of overlay-filesystem.
> 
> Thanks for working on this.
> 
> 
>>
>> Check the following points:
>>
>> Whiteouts
>> ---------
>>
>> A whiteout is a character device with 0/0 device number. It is used to
>> record the removed files or directories, When a whiteout is found in a
>> directory, there should be at least one directory or file with the same
>> name in any of the corresponding lower layers. If not exist, the whiteout
>> will be treated as orphan whiteout and remove.
> 
> Okay.
> 
>>
>> Opaque directories
>> ------------------
>>
>> An opaque directory is a directory with "trusted.overlay.opaque" xattr
>> valued "y". There are two legal situations of making opaque directory: 1)
>> create directory over whiteout 2) creat directory in merged directory. If an
>> opaque directory is found, corresponding matching name in lower layers might
>> exist or parent directory might merged, If not, the opaque xattr will be
>> treated as invalid and remove.
> 
> Current version of overlay fs doesn't bother with removing opaque
> attribute.  So not sure fsck.overlay should care.  Or at least is
> should be an optional thing and not worth warning about, since it's
> perfectly normal.
> 
Indeed, we can introduce '-f' option to handle this (e2fsck(8)):

  -f     Force checking even if the file system seems clean.

>>
>> Redirect directories
>> --------------------
>>
>> An redirect directory is a directory with "trusted.overlay.redirect"
>> xattr valued to the path of the original location from the root of the
>> overlay. It is only used when renaming a directory and "redirect dir"
>> feature is enabled. If an redirect directory is found, the following
>> must be met:
>>
>> 1) The directory store in redirect xattr should exist in one of lower
>> layers.
> 
> Okay.
> 
>> 2) The origin directory should be redirected only once in one layer,
>> which mean there is only one redirect xattr point to this origin directory in
>> the specified layer.
>> 3) A whiteout or an opaque directory with the same name to origin should
>> exist in the same directory as the redirect directory.
>>
>> If not, 1) The redirect xattr is invalid and need to remove 2) One of
>> the redirect xattr is redundant but not sure which one is, ask user 3)
>> Create a whiteout device or set opaque xattr to an existing directory if the
>> parent directory was meregd or remove xattr if not.
> 
> Hmm, in this case also should ask the user, as it's not clear that the
> "new" copy resulting from removal of whiteout on upper is the wanted
> one or the "old" renamed copy.
> 
Thanks for point this out, do you mean the newly created directory over whiteout
between old renamed directory? If so, Amir have already pointed out in the first
iteration and I handled it in current version. Please see:

https://www.spinics.net/lists/linux-unionfs/msg03268.html

Now, fsck will also check dir's redirect xattr for this case, it will add opaque
xattr only when parent is merged and not redirected.

>>
>> Usage
>> =====
>>
>> 1. Ensure overlay filesystem is not mounted based on directories which
>> need to check.
>>
>> 2. Run fsck.overlay program:
>>    Usage:
>>    fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
>>
>>    Options:
>>    -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
>>                              multiple lower use ':' as separator.
>>    -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
>>    -w, --workdir=WORKDIR     specify work directory of overlayfs
> 
> Not sure what other fsck do, but I'd feel more logical to have the
> same -olowerdir=..., etc. notation as for mount.
> 
It's fine by me, I will change it for current version.

Thanks,
Yi.
