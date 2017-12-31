From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for merge dir
Date: Sun, 31 Dec 2017 10:05:15 +0200
Message-ID: <CAOQ4uxg-vzRDAkSV_apBwr7exCieNUztqEeABwFE85osfPDRgA@mail.gmail.com>
References: <20171230074915.33685-1-yi.zhang@huawei.com> <CAOQ4uxjt6+UuSbWoACRsFbpstJVuRJGJgby_DqbqJfEJBk6odw@mail.gmail.com>
 <4d71f377-6b52-7be3-9271-298543c4a2b2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:38971 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdLaIFQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 Dec 2017 03:05:16 -0500
Received: by mail-yw0-f193.google.com with SMTP id q26so10575294ywa.6
        for <linux-unionfs@vger.kernel.org>; Sun, 31 Dec 2017 00:05:15 -0800 (PST)
In-Reply-To: <4d71f377-6b52-7be3-9271-298543c4a2b2@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: zhangyi <yizhang089@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Sun, Dec 31, 2017 at 8:11 AM, zhangyi <yizhang089@gmail.com> wrote:
> On 2017/12/30 17:51, Amir Goldstein Wrote:
>
>> On Sat, Dec 30, 2017 at 9:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>
>>> Current ovl_getattr() (stat(2)) return lower's d_ino for merge
>>> directory (No any extended attribute) but ovl_iterate()
>>> (getdents(2)) return upper's d_ino.
>>>
>>> This patch correct inconsistent d_ino for this case, change to
>>> return lower's d_ino in ovl_iterate() for merge dir.
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>> ---
>>>   fs/overlayfs/readdir.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
>>> index 8c98578..9548712 100644
>>> --- a/fs/overlayfs/readdir.c
>>> +++ b/fs/overlayfs/readdir.c
>>> @@ -136,6 +136,11 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data
>>> *rdd,
>>>              ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
>>>                  return true;
>>>
>>> +       /* Recalc d_ino for all dir in merge dir (contains merge subdirs)
>>> */
>>> +       if (p->type == DT_DIR &&
>>> +           OVL_TYPE_MERGE(ovl_path_type(rdd->dentry)))
>>
>> Why only subdirs and not files with origin?
>> This is a partial fix and I think Miklos has rejected a similar fix by
>> Chandan
>> and said that this should be fixed by a future fsck.overlay (hint hint).

I guess the quote I remembered was from another patch fixing exposing
whiteouts when former merge dir has no origin xattr:
https://marc.info/?l=linux-unionfs&m=151022204326441&w=2

>> The inconsistency is that the directory contains origin (and merge subdir)
>> and is not marked "impure". That is what fsck.overlay needs to fix and
>> then
>> "Recalc d_ino for for all entries if dir is impure (contains copied up
>> entries)"
>> will do the right thing.
>>
> I understand the inconsistency of missing impure xattr should be fixed by
> fsck.overlay,
> but the case of this patch want to fix is not this one.
>
> It's for the case of newly created overlay image. There is no origin xattr
> for the merge
> subdir and no impure xattr for it's parent, and there is also no requirement
> that user
> should run fsck.overlay before first mount.
>
> eg (a simplest situation):
> # mkdir lower upper work merge
> # mkdir lower/dir upper/dir
> # mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
> merge
> # stat -c "%i" merge/dir/
> 389572
> # getdents merge | grep dir                     (getdents is program list in
> getdents(2))
> 389573  directory    16          2  dir

OK, but as far as users are concerned, this is not really a regression.
There are hardly any deployments out there where d_ino returns
values that are consistent with st_ino.

Sooner or later, we will have to "educate" the users and set expectations
w.r.t. implications of crafting layers manually.
Advance features, like online consistency verification (e.g. multiple redirect)
and NFS export are simply NOT going to work with hand drafted layers.

Users are going to either have to start with an empty upper layer, or use
a dedicated mkfs.overlay to compose overlay images or run fsck.overlay
over hand crafted layers with the proper options (e.g. verify=on).

>
> I think if we set origin for merge dir and set impure for it's parent in
> ovl_lookup() can also
> fix this problem.
>

Indeed. IMO, that would be a more appropriate fix.
The "set origin" part I already implemented here:
https://github.com/amir73il/linux/commits/ovl-verify-dir
Right now, fixing merge dir origin is opt-in by verify=on,
but it could be made default (the set if not exist part).
Setting impure for parent at the same opportunity is a good idea -
I will add it to next posting of "verify" feature.

Thanks,
Amir.
