From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 20:35:11 +0800
Message-ID: <E375813F-AD52-4BE5-B294-69741305C46A@icloud.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxiHGS_t8JK+a25-Co55BdqhxASt6sTaf2rzJ0XWSdbjbQ@mail.gmail.com>
 <164E0FA4-DB91-4CC5-9408-E8F53D9652E7@icloud.com>
 <CAOQ4uxjDuLTFkwtpUJGRn7qhmBbxdm+Bnz3vFHdcbKVefi+vEg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:44697 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbeAOMfY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:35:24 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2L00500K0ZJF00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 15 Jan 2018 12:35:23 +0000 (GMT)
In-reply-to: <CAOQ4uxjDuLTFkwtpUJGRn7qhmBbxdm+Bnz3vFHdcbKVefi+vEg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C215=C8=D5=A3=AC=CF=C2=CE=E78:27=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Jan 15, 2018 at 2:19 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
>>> =D4=DA 2018=C4=EA1=D4=C215=C8=D5=A3=AC=CF=C2=CE=E77:30=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Mon, Jan 15, 2018 at 9:33 AM, Chengguang Xu <cgxu519@icloud.com> =
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
>>>=20
>>> s/irrelative/unrelated
>>>=20
>>>>=20
>>>> This patch iterates upper inode list in overlayfs to only sync =
target
>>>> dirty inodes and wait for completion. By doing this, It is able to =
reduce
>>>> cost of synchronization and will not seriously impact IO =
performance of
>>>> irrelative processes. In special case, when having very few dirty =
inodes
>>>=20
>>> unrelated processes
>>>=20
>>>> and a lot of clean upper inodes in overlayfs, then iteration may =
waste
>>>> time so that synchronization is slower than before, but we think =
the
>>>> potential for performance improvement far surpass the potential for
>>>> performance regression in most cases.
>>>>=20
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>=20
>>> Beyond Miklos's comment on removing inodes from list, a few more
>>> comments and nits below.
>>>=20
>>>> ---
> [...]
>>>> +/**
>>>> + * ovl_sync_filesystem
>>>> + * @sb: The overlayfs super block
>>>> + *
>>>> + * Sync underlying dirty inodes in upper filesystem and wait for =
completion.
>>>> + */
>>>> +static int ovl_sync_filesystem(struct super_block *sb)
>>>> +{
>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> +       struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
>>>> +
>>>> +       ovl_sync_inodes(sb);
>>>> +       ovl_wait_inodes(sb);
>>>> +
>>>> +       if (upper_sb->s_op->sync_fs)
>>>> +               upper_sb->s_op->sync_fs(upper_sb, 1);
>>>> +
>>>> +       return sync_blockdev(upper_sb->s_bdev);
>>>> +}
>>>> +
>>>> /* Sync real dirty inodes in upper filesystem (if it exists) */
>>>> static int ovl_sync_fs(struct super_block *sb, int wait)
>>>> {
>>>> @@ -266,17 +422,19 @@ static int ovl_sync_fs(struct super_block =
*sb, int wait)
>>>>        * If this is a sync(2) call or an emergency sync, all the =
super blocks
>>>>        * will be iterated, including upper_sb, so no need to do =
anything.
>>>>        *
>>>> -        * If this is a syncfs(2) call, then we do need to call
>>>> -        * sync_filesystem() on upper_sb, but enough if we do it =
when being
>>>> +        * If this is a syncfs(2) call, then we do need to call =
sync_inode()
>>>> +        * on underlying dirty upper_inode, but enough if we do it =
when being
>>>>        * called with wait =3D=3D 1.
>>>>        */
>>>>       if (!wait)
>>>>               return 0;
>>>>=20
>>>>       upper_sb =3D ofs->upper_mnt->mnt_sb;
>>>> +       if (sb_rdonly(upper_sb))
>>>> +               return 0;
>>>>=20
>>>>       down_read(&upper_sb->s_umount);
>>>> -       ret =3D sync_filesystem(upper_sb);
>>>> +       ret =3D ovl_sync_filesystem(sb);
>>>>       up_read(&upper_sb->s_umount);
>>>=20
>>> The boundaries between ovl_sync_fs() and ovl_sync_filesystem() are =
now very
>>> strange.. taking upper_sb s_umount  lock outside and passing in sb =
etc.
>>> I am not sure that ovl_sync/wait_inodes() should be called under =
upper_sb
>>> s_umount lock at all. Remember we are already holding sb s_umount =
lock.
>>> I suggest, now that ovl_sync/wait_inodes() have been factored out, =
to squash
>>> ovl_sync_filesystem() back into ovl_sync_fs() and hold the s_umount =
lock
>>> only around s_op->sync_fs() and sync_blockdev().
>>=20
>> =46rom the comment in sync_filesystem, s_umount is used for against =
the filesystem going
>> from r/o to r/w or vice versa. so I think it is necessary and should =
move readonly
>> check inside ovl_sync_filesystem() to get the protection.
>>=20
>=20
> Right, but the interface between the 2 functions looks weird, so
> please either get rid of
> ovl_sync_filesystem() entirely and move its code into ovl_sync_fs()
> under the s_umount
> lock where needed or move the s_umount lock and sb_rdonly() test into
> ovl_sync_filesystem(sb), which leaves ovl_sync_fs() pretty slim.

OKAY, I take the latter option.

Thanks,
Chengguang.
