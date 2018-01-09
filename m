From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/23] ovl: unbless lower st_ino of files under
 unverified redirected dir
Date: Tue, 9 Jan 2018 15:28:42 +0100
Message-ID: <CAJfpegumB9iODDCAUSLe65YGA294SJqMEoBMwM_Z9gydOZxDNA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-9-git-send-email-amir73il@gmail.com> <CAJfpegum9hUj9YzjWRZcta5tDR1mof5dYc0igFAZdKM1n2Tf9Q@mail.gmail.com>
 <CAOQ4uxi+QiBso9_pLgFUAvhy7yE-_U6=-bzc5UiGFjvyY9vacw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41005 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755227AbeAIO2n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:28:43 -0500
Received: by mail-qt0-f195.google.com with SMTP id i40so17980694qti.8
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 06:28:43 -0800 (PST)
In-Reply-To: <CAOQ4uxi+QiBso9_pLgFUAvhy7yE-_U6=-bzc5UiGFjvyY9vacw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 3:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Jan 9, 2018 at 3:31 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On a malformed overlay, several redirected dirs can point to the same
>>> dir on a lower layer. This presents a similar challenge as broken
>>> hardlinks, because different objects in the overlay can return the same
>>> st_ino/st_dev pair from stat(2).
>>>
>>> For broken hardlinks, we do not provide constant st_ino on copy up to
>>> avoid this inconsistency. When "verify" feature is enabled, apply
>>> the same logic to files nested under unverified redirected dirs.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/inode.c     | 18 ++++++++++++++----
>>>  fs/overlayfs/namei.c     |  4 ++++
>>>  fs/overlayfs/overlayfs.h |  4 ++++
>>>  fs/overlayfs/util.c      | 27 +++++++++++++++++++++++++++
>>>  4 files changed, 49 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> index 00b6b294272a..1b53755bd86c 100644
>>> --- a/fs/overlayfs/inode.c
>>> +++ b/fs/overlayfs/inode.c
>>> @@ -105,12 +105,22 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>>>                          * Lower hardlinks may be broken on copy up to different
>>>                          * upper files, so we cannot use the lower origin st_ino
>>>                          * for those different files, even for the same fs case.
>>> +                        *
>>> +                        * Similarly, several redirected dirs can point to the
>>> +                        * same dir on a lower layer. With the "verify" feature,
>>> +                        * we do not use the lower origin st_ino, if any parent
>>> +                        * is redirected and we haven't verified that this
>>> +                        * redirect is unique.
>>> +                        *
>>>                          * With inodes index enabled, it is safe to use st_ino
>>> -                        * of an indexed hardlinked origin. The index validates
>>> -                        * that the upper hardlink is not broken.
>>> +                        * of an indexed origin. The index validates that the
>>> +                        * upper hardlink is not broken and that a redirected
>>> +                        * dir is the only redirect to that origin.
>>>                          */
>>> -                       if (is_dir || lowerstat.nlink == 1 ||
>>> -                           ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>>> +                       if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
>>> +                           ((is_dir || lowerstat.nlink == 1) &&
>>> +                            (!ovl_verify(dentry->d_sb) ||
>>> +                             !ovl_dentry_is_renamed(dentry))))
>>
>> Won't this make st_ino change when an ancestor directory is renamed?
>> Even if there is no "double redirect" that we are fearing?  If so,
>> than I think the cure is worse than the disease.
>>
>
> Right. I should drop ovl_dentry_is_renamed(). It was ill conceived.
>
> For verify=off, we trust lower st_ino for non-indexed dir and non-hardlink.
> For verify=on, we only trust lower st_ino for indexed dir and non-dir.
> Using the upper st_ino for non-indexed upper with verify=on is
> consistent with the fact that we also encode an upper file handle
> for non-indexed upper.
>
> That means that st_ino remains constant on copy up for both
> verify=on/off, but when same overlay is mounted verify=off and then
> verify=on, st_ino of an already copied up (and non-indexed) file st_ino
> will change.
>
> I don't think that behavior is a problem, considering the fact that merge
> dir without verified origin will also not behave the same on verify=on/off
> cases.

Yes, fine.

Thanks,
Miklos
