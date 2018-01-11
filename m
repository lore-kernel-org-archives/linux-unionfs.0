From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2] ovl: Improving syncfs efficiency
Date: Thu, 11 Jan 2018 11:59:31 +0800
Message-ID: <166B9DF2-46CB-480D-8654-97C9B0CE4793@icloud.com>
References: <1515587531-33474-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxjnDMTf+uBja5-F4nSm2BYmpfK8nOfR1hhYMo7VC02vQg@mail.gmail.com>
 <06EB0CEE-9822-49FB-9793-28D615A0AD83@icloud.com>
 <CAOQ4uxhf+1-JDNCS2_8Wp9SrZ2uLtuu37_qdDRhrC53EytE2YA@mail.gmail.com>
 <2C41CE6B-EB95-45DA-8771-66005275B88B@icloud.com>
 <CAOQ4uxgscdL_9027K-epZy6aPVH72SVrj8C-zu=hsEey0Y04mQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:64266 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeAKD7i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 22:59:38 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2D00400HMWOP00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Thu, 11 Jan 2018 03:59:37 +0000 (GMT)
In-reply-to: <CAOQ4uxgscdL_9027K-epZy6aPVH72SVrj8C-zu=hsEey0Y04mQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C211=C8=D5=A3=AC=C9=CF=CE=E711:13=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Jan 11, 2018 at 2:53 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
> [...]
>>>>>> +       mutex_lock(&upper_sb->s_sync_lock);
>>>>>=20
>>>>> So it makes some sense to use upper_sb sync lock
>>>>> to synchronize with callers of sync(2)/syncfs(2) on the upper fs,
>>>>> but that could result syncfs() on overlay to take much longer if
>>>>> there is a syncfs() on upper fs in progress.
>>>>=20
>>>> I have two proposals for this.
>>>>=20
>>>> A.
>>>> After changing wait list to global, I think waiting without
>>>> upper_sb->s_sync_lock is still safe, so we can avoid coupling
>>>> with syncfs of upper filesystem and I prefer this.
>>>>=20
>>>> B.
>>>> If you are worried about solution A, then we can introduce a =
mutex_lock
>>>> inside overlayfs for serializing concurrent sync waiting =
operations.
>>>>=20
>>>=20
>>> No need to introduce a new mutex you should just use sb->s_sync_lock
>>> and BTW, option A is probably safe w.r.t races, because according to
>>> comment above wait_sb_inodes(), s_sync_lock is meant to improve
>>> performance, not to avoid races.
>>=20
>> I don=A1=AFt think s_sync_lock here is only for performance, option A =
is safe because
>> we do not manipulate sb->s_inodes_wb list, but wait_sb_inodes() will =
do.
>>=20
>=20
> See commit e97fedb9ef98 ("sync: serialise per-superblock sync =
operations")
> s_sync_lock was added to solve a performance issue.

commit e97fedb9ef98 is indeed for performance issue,=20
but you can see following commit 6c60d2b5746cf23 ("fs/fs-writeback.c: =
add a new writeback list for sync=A1=B1),
in this commit, change to local temporary waiting list instead of =
iterating all inode of filesystem,
so now I think it=A1=AFs also for avoiding race condition.

Thanks,
Chengguang.=
