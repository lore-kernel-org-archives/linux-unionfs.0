From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3] ovl: mark upper merge dir with type origin entries "impure"
Date: Wed, 31 May 2017 14:31:42 +0200
Message-ID: <CAJfpegvefEXxgTZDb2zSUNV=jSopi0dsSUYi7UFsjrhcSCODuA@mail.gmail.com>
References: <1495628973-12099-1-git-send-email-amir73il@gmail.com> <CAOQ4uxiicCAfd4TF1ym=qGTz1egGVnpZYdescFgGHQ2X8Dp6Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36146 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdEaMbo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 08:31:44 -0400
Received: by mail-oi0-f65.google.com with SMTP id w138so1648064oiw.3
        for <linux-unionfs@vger.kernel.org>; Wed, 31 May 2017 05:31:43 -0700 (PDT)
In-Reply-To: <CAOQ4uxiicCAfd4TF1ym=qGTz1egGVnpZYdescFgGHQ2X8Dp6Nw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, May 29, 2017 at 10:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, May 24, 2017 at 3:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> An upper dir is marked "impure" to let ovl_iterate() know that this
>> directory may contain non pure upper entries whose d_ino may need to be
>> read from the origin inode.
>>
>> We already mark a non-merge dir "impure" when moving a non-pure child
>> entry inside it, to let ovl_iterate() know not to iterate the non-merge
>> dir directly.
>>
>> Mark also a merge dir "impure" when moving a non-pure child entry inside
>> it and when copying up a child entry inside it.
>>
>> This can be used to optimize ovl_iterate() to perform a "pure merge" of
>> upper and lower directories, merging the content of the directories,
>> without having to read d_ino from origin inodes.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/copy_up.c   |  7 +++++++
>>  fs/overlayfs/dir.c       | 31 ++++++-------------------------
>>  fs/overlayfs/namei.c     | 20 --------------------
>>  fs/overlayfs/overlayfs.h | 14 +++++++++++---
>>  fs/overlayfs/super.c     |  5 ++++-
>>  fs/overlayfs/util.c      | 31 +++++++++++++++++++++++++++++++
>>  6 files changed, 59 insertions(+), 49 deletions(-)
>>
>>
>> Miklos,
>>
>> Please consider this patch for v4.12-rc3 on top of the one already in
>> overlayfs-next.
>>
>> Not sure how common the use case of "pure merge" is, but the optimization
>> of not doing the origin lookup in ovl_interate() is trivial [1], so better
>> have the merge dir marked "impure" now when introducing overlay.origin.
>
> Miklos,
>
> Ping for rc4.
>
> FYI, I have been testing this patch along with ovl-constino and the rest of
> my dev branch over the past week and everything looks sane.
>
> Please see one clarification/disclaimer below, which I don't think warrants
> a problem w.r.t merging this patch to rc4.
>
> Thanks,
> Amir.
>
>
>>
>> v3:
>> - Fix bug that slipped into ovl_check_dir_xattr() in v1
>>
>> v2:
>> - Check on mount if upper dir is impure
>> - Tested the optimization [1] with consistent st_ino/d_ino patch
>>
>> [1] https://github.com/amir73il/linux/blob/ovl-constino/fs/overlayfs/readdir.c#L413
>>
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index 843ed2a..1ae1790 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -459,6 +459,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>>         ovl_path_upper(parent, &parentpath);
>>         upperdir = parentpath.dentry;
>>
>> +       /* Mark parent "impure" because it may now contain non-pure upper */
>> +       if (!ovl_dentry_is_impure(parent)) {
>> +               err = ovl_set_impure(parent, upperdir);
>> +               if (err)
>> +                       return err;
>> +       }
>> +
>
> Disclaimer:
> ---------------
> ovl_dentry_is_impure() here is not tested under any lock and with no
> explicit memory barriers
> nor does ovl_dentry_set_impure() inside ovl_set_impure().
> The worst outcome for this code seems to be that overlay.impure xattr
> can be set twice, which
> shouldn't be a problem (?).

Right.  Unlikely race can result in .impure xattr being set twice, no
other effect.

> For v4.13, when ovl_iterate() will test ovl_dentry_is_impure(), it
> will be more important to make
> sure that ovl_iterate() does not read an old false value of oe->impure
> and cause some
> inconsistency. I think that the (real) parent i_mutex lock taken
> further down copy up and
> the (overlay) parent i_mutex lock taken in iterate_dir() guaranty the
> required memory barriers (?).

Yes.

Thanks,
Miklos
