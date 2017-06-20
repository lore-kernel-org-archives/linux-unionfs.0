From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Tue, 20 Jun 2017 10:04:51 +0300
Message-ID: <CAOQ4uxhHiCVFkumKsEFzwihBfy-BTC4JxbpB04=HdvQWC_vovA@mail.gmail.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
 <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
 <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
 <14574573-a05e-8045-93d4-e27ec5430c14@huawei.com> <CAJfpegugA+M1sYOpLHKzAQU3qR901Nn3g5MEqSqdNjGLOctStw@mail.gmail.com>
 <CAOQ4uxhm=FLKiFSb3yhTF8gWEPhAGvSF_0tP9hFRotxZ=jiNaQ@mail.gmail.com> <6878b23b-af71-cebc-6cfe-3761df6936af@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33097 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdFTHEw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2017 03:04:52 -0400
Received: by mail-ot0-f193.google.com with SMTP id q16so11222913otb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2017 00:04:52 -0700 (PDT)
In-Reply-To: <6878b23b-af71-cebc-6cfe-3761df6936af@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, miaoxie@huawei.com

On Tue, Jun 20, 2017 at 9:10 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/6/19 20:07, Amir Goldstein Wrote:
>> On Mon, Jun 19, 2017 at 2:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Mon, Jun 19, 2017 at 1:19 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>> On 2017/6/19 16:28, Amir Goldstein wrote:
>>>>> On Mon, Jun 19, 2017 at 10:59 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>> On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>
>>> It's done for the root of the overlay by Amir's patchset, but that
>>> probably should be done generically for all merged directories not
>>> already having an origin marking.   It could be done at lookup time,
>>> or at whiteout time.  Not sure which is better.
>>>
>>
>> Checking merge dir origin is something I planned to do anyway, because
>> it is needed for NFS export (only verified lower can be indexed).
>> In fact, I already did it, but yanked it out of the current series because
>> it is not needed for indexing non-dirs, see:
>> https://github.com/amir73il/linux/commit/9af404799ba4ba4d08e147c7d54f6bcef0527bc9#diff-643262c1d5b2cba0bc9500e531831c12R481
>>
>> On top of my current ovl-hardlinks branch, the following change in lookup
>> would get the required origin mark on merge dirs and code will
>> be inline with upcoming NFS export changes:
>>
>> @@ -416,6 +478,17 @@ struct dentry *ovl_lookup(struct inode *dir,
>> struct dentry *dentry,
>>                 if (err)
>>                         goto out_put;
>>
>> +               /* Verify that uppermost lower matches the copy up origin fh */
>> +               if (this && upperdentry && !ctr &&
>> +                   ovl_indexdir(dentry->d_sb))) {
>> +                       err = ovl_verify_set_origin(upperdentry, lowerpath.mnt,
>> +                                               this, "merge", true);
>> +                       if (err && err != -ENODATA) {
>> +                               dput(this);
>> +                               break;
>> +                       }
>> +               }
>> +
>>                 if (!this)
>>                         continue;
>>
>
> It looks good to me. Do you have a plan to push this code? I can fix this whiteout
> problem base on it.
>

My plans were to defer it to next-next (v4.14) merge cycle along with
NFS export.

I suggest that you post a fix to the whiteout problem based on (MERGE
|| ORIGIN),
disregarding the issue of pre kernel v4.12 upper layers (MERGE && !ORIGIN).

After my current patch set lands on linux-next, or even after v4.13-rc1, we
can decide if it is worth while to merge the extra hunk above for the sake of
fixing whiteout problem with pre v4.12 upper layers.

Does your use case have to deal with migrating existing upper layers?

BTW, does you use case also care about other types of lower layer changes?
As part of the work for overlayfs snapshots and NFS export, I also plan to
post patches to follow renamed lower dir to their new location, instead of
treating the upper dir as !MERGE, see:
https://github.com/amir73il/linux/commits/ovl-verify-dir

Amir.
