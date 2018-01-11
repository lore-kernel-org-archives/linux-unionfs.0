From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: Improving syncfs efficiency
Date: Thu, 11 Jan 2018 05:13:46 +0200
Message-ID: <CAOQ4uxgscdL_9027K-epZy6aPVH72SVrj8C-zu=hsEey0Y04mQ@mail.gmail.com>
References: <1515587531-33474-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxjnDMTf+uBja5-F4nSm2BYmpfK8nOfR1hhYMo7VC02vQg@mail.gmail.com>
 <06EB0CEE-9822-49FB-9793-28D615A0AD83@icloud.com> <CAOQ4uxhf+1-JDNCS2_8Wp9SrZ2uLtuu37_qdDRhrC53EytE2YA@mail.gmail.com>
 <2C41CE6B-EB95-45DA-8771-66005275B88B@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:40526 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbeAKDNr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 22:13:47 -0500
Received: by mail-yb0-f193.google.com with SMTP id s10so493687ybl.7
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jan 2018 19:13:47 -0800 (PST)
In-Reply-To: <2C41CE6B-EB95-45DA-8771-66005275B88B@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 2:53 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
[...]
>>>>> +       mutex_lock(&upper_sb->s_sync_lock);
>>>>
>>>> So it makes some sense to use upper_sb sync lock
>>>> to synchronize with callers of sync(2)/syncfs(2) on the upper fs,
>>>> but that could result syncfs() on overlay to take much longer if
>>>> there is a syncfs() on upper fs in progress.
>>>
>>> I have two proposals for this.
>>>
>>> A.
>>> After changing wait list to global, I think waiting without
>>> upper_sb->s_sync_lock is still safe, so we can avoid coupling
>>> with syncfs of upper filesystem and I prefer this.
>>>
>>> B.
>>> If you are worried about solution A, then we can introduce a mutex_lock
>>> inside overlayfs for serializing concurrent sync waiting operations.
>>>
>>
>> No need to introduce a new mutex you should just use sb->s_sync_lock
>> and BTW, option A is probably safe w.r.t races, because according to
>> comment above wait_sb_inodes(), s_sync_lock is meant to improve
>> performance, not to avoid races.
>
> I don=E2=80=99t think s_sync_lock here is only for performance, option A =
is safe because
> we do not manipulate sb->s_inodes_wb list, but wait_sb_inodes() will do.
>

See commit e97fedb9ef98 ("sync: serialise per-superblock sync operations")
s_sync_lock was added to solve a performance issue.

> In conclusion, we can take s_sync_lock of overlayfs instead to decouple w=
ith syncfs of
> upper filesystem and at the same time avoiding race condition for syncfs =
of overlayfs.
>

Yes.
Thanks,
Amir.
