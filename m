From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Mon, 19 Jun 2017 15:07:51 +0300
Message-ID: <CAOQ4uxhm=FLKiFSb3yhTF8gWEPhAGvSF_0tP9hFRotxZ=jiNaQ@mail.gmail.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
 <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
 <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
 <14574573-a05e-8045-93d4-e27ec5430c14@huawei.com> <CAJfpegugA+M1sYOpLHKzAQU3qR901Nn3g5MEqSqdNjGLOctStw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36239 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFSMHw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 08:07:52 -0400
Received: by mail-ot0-f193.google.com with SMTP id r67so11003128ota.3
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 05:07:52 -0700 (PDT)
In-Reply-To: <CAJfpegugA+M1sYOpLHKzAQU3qR901Nn3g5MEqSqdNjGLOctStw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, miaoxie@huawei.com

On Mon, Jun 19, 2017 at 2:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jun 19, 2017 at 1:19 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/6/19 16:28, Amir Goldstein wrote:
>>> On Mon, Jun 19, 2017 at 10:59 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>
>>>> I still don't like adding the impure flag because of a whiteout.
>>>> Impure dir means it contains a copied up object.  In fact a valid (but
>>>> probably not worthwhile) optimizition would be to remove the impure
>>>> flag on removal of the last copied up object.
>>>>
>>>> What's wrong with testing for (origin || merge) to see if we need to
>>>> check for whiteouts?
>>>>
>>>
>>> Fine by me.
>>>
>>> Yi,
>>>
>>> Please note that you cannot use the test OVL_TYPE_ORIGIN(type)
>>> in ovl_dir_is_real(), because that flag is only set when the lower
>>> dentry is found by lookup. Instead, you should explicitly check for
>>> existence of OVL_XATTR_ORIGIN.
>>> Note that even ovl_get_origin_fh() is too strict, because it discards
>>> empty (unkown) origin, but for your use case, unknown origin is also
>>> candidate to contain whiteouts.
>>>
>>
>> I realize that impure flag is not quite suitable. If we use (origin || merge)
>> to see whether we need to check whiteouts or not, I think we still have a
>> problem.
>>
>> Thought: In my current test case, testdir was copyuped when we delete
>> the test file, so it have OVL_XATTR_ORIGIN (it's OK), but if the testdir
>> is a merged dir originally, it will not be copied up and the OVL_XATTR_ORIGIN
>> will not be set.
>>
>> So, if we want to use (origin || merge), we have to set OVL_XATTR_ORIGIN for
>> the merged parent dir when it create whiteout, any side effects?
>
> It's done for the root of the overlay by Amir's patchset, but that
> probably should be done generically for all merged directories not
> already having an origin marking.   It could be done at lookup time,
> or at whiteout time.  Not sure which is better.
>

Checking merge dir origin is something I planned to do anyway, because
it is needed for NFS export (only verified lower can be indexed).
In fact, I already did it, but yanked it out of the current series because
it is not needed for indexing non-dirs, see:
https://github.com/amir73il/linux/commit/9af404799ba4ba4d08e147c7d54f6bcef0527bc9#diff-643262c1d5b2cba0bc9500e531831c12R481

On top of my current ovl-hardlinks branch, the following change in lookup
would get the required origin mark on merge dirs and code will
be inline with upcoming NFS export changes:

@@ -416,6 +478,17 @@ struct dentry *ovl_lookup(struct inode *dir,
struct dentry *dentry,
                if (err)
                        goto out_put;

+               /* Verify that uppermost lower matches the copy up origin fh */
+               if (this && upperdentry && !ctr &&
+                   ovl_indexdir(dentry->d_sb))) {
+                       err = ovl_verify_set_origin(upperdentry, lowerpath.mnt,
+                                               this, "merge", true);
+                       if (err && err != -ENODATA) {
+                               dput(this);
+                               break;
+                       }
+               }
+
                if (!this)
                        continue;




Amir.
