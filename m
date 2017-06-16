From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH] ovl:fix rmdir problem on impure dir
Date: Fri, 16 Jun 2017 11:55:18 +0300
Message-ID: <CAOQ4uxhj+s=hSHD-185RCBuvXgggnOfdaYxZmstBWp_hsLCbEQ@mail.gmail.com>
References: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjnVfY+jqgUxrhw0nD6FHUOaqkTynOQX2cm2MaLRd+cOg@mail.gmail.com> <3c7e4be9-03dc-ddeb-9460-87e6c0c6ba83@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36517 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbdFPIzU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 04:55:20 -0400
Received: by mail-oi0-f66.google.com with SMTP id g14so2897187oib.3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2017 01:55:19 -0700 (PDT)
In-Reply-To: <3c7e4be9-03dc-ddeb-9460-87e6c0c6ba83@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Fri, Jun 16, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/6/16 14:02, Amir Goldstein Wrote:
>> On Fri, Jun 16, 2017 at 6:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote=
:
>>> Hi All:
>>>
>>> I found another problem about impure upper dir which have left
>>> whiteout files. If an "impure && not merged" upper dir have
>>> left whiteout files(last mount created), ovl cannot clear this
>>> dir when we removing it, which may lead to rmdir fail or temp
>>> file left in workdir.
>>>
>>> Reproducer:
>>>   mkdir lower upper work merge
>>>   mkdir -p lower/dir
>>>   touch lower/dir/a
>>>   mount -t overlay overlay -olowerdir=3Dlower,upperdir=3Dupper,\
>>>     workdir=3Dwork merge
>>>   rm merge/dir/a
>>>   umount merge
>>>   rm -rf lower/*
>>>   touch lower/dir  (*)
>>>   mount -t overlay overlay -olowerdir=3Dlower,upperdir=3Dupper,\
>>>     workdir=3Dwork merge
>>>   rm -rf merge/dir
>>
>> Can you please post an xfstest with that reproducer.
>> A good starting point is test overlay/012
>>
>
> Okay=EF=BC=8CI will write a new xfstest case with this reproducer, thanks=
!
>
>>> ---
>>>  fs/overlayfs/dir.c | 13 ++++++++++---
>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>>> index a63a716..9535e2d 100644
>>> --- a/fs/overlayfs/dir.c
>>> +++ b/fs/overlayfs/dir.c
>>> @@ -336,7 +336,8 @@ static struct dentry *ovl_check_empty_and_clear(str=
uct dentry *dentry)
>>>          * Doesn't matter, since copy-up can't create a non-empty direc=
tory
>>>          * from an empty one.
>>>          */
>>> -       if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
>>> +       if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
>>> +                                    ovl_dentry_is_impure(dentry)))
>>>                 ret =3D ovl_clear_empty(dentry, &list);
>>>
>>>  out_free:
>>> @@ -633,6 +634,11 @@ static int ovl_remove_and_whiteout(struct dentry *=
dentry, bool is_dir)
>>>                         goto out;
>>>         }
>>>
>>> +       /* Mark parent "impure" because it may now contain non-pure upp=
er */
>>> +       err =3D ovl_set_impure(dentry->d_parent, upperdir);
>>> +       if (err)
>>> +               goto out_dput;
>>> +
>>
>> This should be done before ovl_whiteout().
>> You rather have false positive impure than the other way around.
>> Also please fix comment to "... may now contain whiteouts".
>>
>
> Thanks for the review comments. I will fix it.
>
> The first suggestion I don't quite understand. As you said, ovl_set_impur=
e()
> should done before ovl_whiteout()=EF=BC=8CI understand that have false im=
pure is
> doesn't matter if subsequent code return error. My patch call ovl_set_imp=
ure()
> before ovl_lock_rename_workdir() is also before ovl_whiteout().
>
> Do I misunderstand or do you mean just before ovl_whiteout() ?

I misread. Your patch is correct

>
