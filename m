From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 21:41:43 +0800
Message-ID: <9507D064-3327-4E83-BED3-E0DA880766BC@icloud.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com>
 <CAOQ4uxg6HvakDexhwunMcMwoJUoZs2t9syjA+A_Bi8QxnhOuCw@mail.gmail.com>
 <CAJfpegtTUi51viUWE1tz3kvfGpwfj-kpivHQb=7vtr4tj5M+2g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:53885 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966570AbeAONmF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 08:42:05 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2L00O00N5L3V00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 15 Jan 2018 13:41:55 +0000 (GMT)
In-reply-to: <CAJfpegtTUi51viUWE1tz3kvfGpwfj-kpivHQb=7vtr4tj5M+2g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C215=C8=D5=A3=AC=CF=C2=CE=E76:19=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Jan 15, 2018 at 11:10 AM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Mon, Jan 15, 2018 at 11:29 AM, Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>>> On Mon, Jan 15, 2018 at 8:33 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>> Currently syncfs(2) call on overlayfs just simply call =
sync_filesystem()
>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>> regardless of the overlay ownership of the inode. In the use case =
of
>>>> container, when multiple containers using the same underlying upper
>>>> filesystem, it has some shortcomings as below.
>>>>=20
>>>> (1) Performance
>>>> Synchronization is probably heavy because it actually syncs =
unnecessary
>>>> inodes for target overlayfs.
>>>>=20
>>>> (2) Interference
>>>> Unplanned synchronization will probably impact IO performance of
>>>> irrelative container processes on the other overlayfs.
>>>>=20
>>>> This patch iterates upper inode list in overlayfs to only sync =
target
>>>> dirty inodes and wait for completion. By doing this, It is able to =
reduce
>>>> cost of synchronization and will not seriously impact IO =
performance of
>>>> irrelative processes. In special case, when having very few dirty =
inodes
>>>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>>>> time so that synchronization is slower than before, but we think =
the
>>>> potential for performance improvement far surpass the potential for
>>>> performance regression in most cases.
>>>>=20
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>> ---
>>>> Changes since v3:
>>>> - Introduce upper_inode list to organize ovl indoe which has upper =
inode.
>>>=20
>>> Where is the inode removed from the list?  Should be done in
>>> ovl_destroy_inode().
>>>=20
>>> Problem is: we can drop the overlay inode even when the underlying
>>> inode is dirty, so we need to sync the upper inode before letting it
>>> go in ovl_destroy_inode().
>>>=20
>>=20
>> Isn't that a bit counter to the lazy inode writeback approach?
>=20
> Not really.  The dcache still keeps inodes and cache in memory, until
> there's memory pressure to get rid of the dentry itself.
>=20
> So this is about syncing the upper inode when the overlay dentry is
> flushed out of the dcache, which should not interfere with lazy
> writeback in general.
>=20
>> Won't this cause a change of behavior, e.g. by forcing data sync =
before
>> returning from close of file after a large write?
>=20
> No, file keeps a ref on dentry, which keeps a ref on inode +
> underlying dentries.
>=20

Hi Miklos, Amir

Thanks for your comments for the patch.

If the speed of ovl inode destruction is not serious problem, I would =
like to
implement like below, what do you think?

In the process of ovl inode destruction:=20
(I will introduce evict operation and do below oprations there)

1. start syncing inode.=20
2. add current inode to sb->s_inodes_wb list
3. take sb->s_sync_lock and wait until all inode in the wait list =
finishing syncing.
#Of course, we can only wait for specific inode, but is that really =
helping much?

Maybe in the worst case, inode destruction will take time for the first =
inode,
but I think it is not common for all inodes. The purpose of adding inode =
to
sb->s_inodes_wb list is for data consistency of sync result, because =
I=A1=AFm afraid that
inode destruction will let dirty inode escaping from sync waiting list.



Thanks,
Chengguang.=
