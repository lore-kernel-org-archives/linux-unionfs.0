From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 17:26:01 +0200
Message-ID: <CAOQ4uxhfdLv3+w=5iO2duQVBjmXgdvVaAvYsxA48Xy2-cABDbg@mail.gmail.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com>
 <CAOQ4uxg6HvakDexhwunMcMwoJUoZs2t9syjA+A_Bi8QxnhOuCw@mail.gmail.com>
 <CAJfpegtTUi51viUWE1tz3kvfGpwfj-kpivHQb=7vtr4tj5M+2g@mail.gmail.com> <9507D064-3327-4E83-BED3-E0DA880766BC@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:33633 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966384AbeAOP0C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 10:26:02 -0500
Received: by mail-yb0-f172.google.com with SMTP id c66so5139497ybf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 07:26:02 -0800 (PST)
In-Reply-To: <9507D064-3327-4E83-BED3-E0DA880766BC@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 3:41 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8815=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=886=
:19=EF=BC=8CMiklos Szeredi <miklos@szeredi.hu> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Mon, Jan 15, 2018 at 11:10 AM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
>>> On Mon, Jan 15, 2018 at 11:29 AM, Miklos Szeredi <miklos@szeredi.hu> wr=
ote:
>>>> On Mon, Jan 15, 2018 at 8:33 AM, Chengguang Xu <cgxu519@icloud.com> wr=
ote:
>>>>> Currently syncfs(2) call on overlayfs just simply call sync_filesyste=
m()
>>>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>>>> regardless of the overlay ownership of the inode. In the use case of
>>>>> container, when multiple containers using the same underlying upper
>>>>> filesystem, it has some shortcomings as below.
>>>>>
>>>>> (1) Performance
>>>>> Synchronization is probably heavy because it actually syncs unnecessa=
ry
>>>>> inodes for target overlayfs.
>>>>>
>>>>> (2) Interference
>>>>> Unplanned synchronization will probably impact IO performance of
>>>>> irrelative container processes on the other overlayfs.
>>>>>
>>>>> This patch iterates upper inode list in overlayfs to only sync target
>>>>> dirty inodes and wait for completion. By doing this, It is able to re=
duce
>>>>> cost of synchronization and will not seriously impact IO performance =
of
>>>>> irrelative processes. In special case, when having very few dirty ino=
des
>>>>> and a lot of clean upper inodes in overlayfs, then iteration may wast=
e
>>>>> time so that synchronization is slower than before, but we think the
>>>>> potential for performance improvement far surpass the potential for
>>>>> performance regression in most cases.
>>>>>
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> ---
>>>>> Changes since v3:
>>>>> - Introduce upper_inode list to organize ovl indoe which has upper in=
ode.
>>>>
>>>> Where is the inode removed from the list?  Should be done in
>>>> ovl_destroy_inode().
>>>>
>>>> Problem is: we can drop the overlay inode even when the underlying
>>>> inode is dirty, so we need to sync the upper inode before letting it
>>>> go in ovl_destroy_inode().
>>>>
>>>
>>> Isn't that a bit counter to the lazy inode writeback approach?
>>
>> Not really.  The dcache still keeps inodes and cache in memory, until
>> there's memory pressure to get rid of the dentry itself.
>>
>> So this is about syncing the upper inode when the overlay dentry is
>> flushed out of the dcache, which should not interfere with lazy
>> writeback in general.
>>
>>> Won't this cause a change of behavior, e.g. by forcing data sync before
>>> returning from close of file after a large write?
>>
>> No, file keeps a ref on dentry, which keeps a ref on inode +
>> underlying dentries.
>>
>
> Hi Miklos, Amir
>
> Thanks for your comments for the patch.
>
> If the speed of ovl inode destruction is not serious problem, I would lik=
e to
> implement like below, what do you think?
>
> In the process of ovl inode destruction:
> (I will introduce evict operation and do below oprations there)
>
> 1. start syncing inode.
> 2. add current inode to sb->s_inodes_wb list
> 3. take sb->s_sync_lock and wait until all inode in the wait list finishi=
ng syncing.
> #Of course, we can only wait for specific inode, but is that really helpi=
ng much?
>
> Maybe in the worst case, inode destruction will take time for the first i=
node,
> but I think it is not common for all inodes. The purpose of adding inode =
to
> sb->s_inodes_wb list is for data consistency of sync result, because I=E2=
=80=99m afraid that
> inode destruction will let dirty inode escaping from sync waiting list.
>

I don't see a flaw in this plan, but here is another alternative plan
to consider:

Implement drop_inode() operation (not evict_inode) as follows:

if inode->i_stat & I_WILL_FREE:
    return 1 /* ok to evict */
else if upper is dirty:
    increment i_refcount
    inode->i_stat |=3D I_WILL_FREE
    add to sb->s_inodes_wb list
    return 0 /* don't evict */
else:
    return 1 /* ok to evict */

If I am not wrong, this will let inode live a little longer with a
single refcount
on sb->s_inodes_wb list until a later umount or syncfs syncs the
sb->s_inodes_wb list and drops the last refcount.

This way on memory pressure, when many overlay inodes are evicted, we
do not sync and wait on them one at a time, but like most fs, we sync and
then wait on all of them on sync_filesystem() call.

Hope I am not sending you on a dangerous adventure, so maybe consider
the simple and slower implementation before trying this optimization.

Thanks,
Amir.
