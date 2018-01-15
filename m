From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 14:27:37 +0200
Message-ID: <CAOQ4uxjDuLTFkwtpUJGRn7qhmBbxdm+Bnz3vFHdcbKVefi+vEg@mail.gmail.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxiHGS_t8JK+a25-Co55BdqhxASt6sTaf2rzJ0XWSdbjbQ@mail.gmail.com> <164E0FA4-DB91-4CC5-9408-E8F53D9652E7@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:43084 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbeAOM1i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:27:38 -0500
Received: by mail-yw0-f196.google.com with SMTP id x190so5317502ywd.10
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 04:27:38 -0800 (PST)
In-Reply-To: <164E0FA4-DB91-4CC5-9408-E8F53D9652E7@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 2:19 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=8815=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=887=
:30=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Mon, Jan 15, 2018 at 9:33 AM, Chengguang Xu <cgxu519@icloud.com> wrot=
e:
>>> Currently syncfs(2) call on overlayfs just simply call sync_filesystem(=
)
>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>> regardless of the overlay ownership of the inode. In the use case of
>>> container, when multiple containers using the same underlying upper
>>> filesystem, it has some shortcomings as below.
>>>
>>> (1) Performance
>>> Synchronization is probably heavy because it actually syncs unnecessary
>>> inodes for target overlayfs.
>>>
>>> (2) Interference
>>> Unplanned synchronization will probably impact IO performance of
>>> irrelative container processes on the other overlayfs.
>>
>> s/irrelative/unrelated
>>
>>>
>>> This patch iterates upper inode list in overlayfs to only sync target
>>> dirty inodes and wait for completion. By doing this, It is able to redu=
ce
>>> cost of synchronization and will not seriously impact IO performance of
>>> irrelative processes. In special case, when having very few dirty inode=
s
>>
>> unrelated processes
>>
>>> and a lot of clean upper inodes in overlayfs, then iteration may waste
>>> time so that synchronization is slower than before, but we think the
>>> potential for performance improvement far surpass the potential for
>>> performance regression in most cases.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>
>> Beyond Miklos's comment on removing inodes from list, a few more
>> comments and nits below.
>>
>>> ---
[...]
>>> +/**
>>> + * ovl_sync_filesystem
>>> + * @sb: The overlayfs super block
>>> + *
>>> + * Sync underlying dirty inodes in upper filesystem and wait for compl=
etion.
>>> + */
>>> +static int ovl_sync_filesystem(struct super_block *sb)
>>> +{
>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>> +       struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
>>> +
>>> +       ovl_sync_inodes(sb);
>>> +       ovl_wait_inodes(sb);
>>> +
>>> +       if (upper_sb->s_op->sync_fs)
>>> +               upper_sb->s_op->sync_fs(upper_sb, 1);
>>> +
>>> +       return sync_blockdev(upper_sb->s_bdev);
>>> +}
>>> +
>>> /* Sync real dirty inodes in upper filesystem (if it exists) */
>>> static int ovl_sync_fs(struct super_block *sb, int wait)
>>> {
>>> @@ -266,17 +422,19 @@ static int ovl_sync_fs(struct super_block *sb, in=
t wait)
>>>         * If this is a sync(2) call or an emergency sync, all the super=
 blocks
>>>         * will be iterated, including upper_sb, so no need to do anythi=
ng.
>>>         *
>>> -        * If this is a syncfs(2) call, then we do need to call
>>> -        * sync_filesystem() on upper_sb, but enough if we do it when b=
eing
>>> +        * If this is a syncfs(2) call, then we do need to call sync_in=
ode()
>>> +        * on underlying dirty upper_inode, but enough if we do it when=
 being
>>>         * called with wait =3D=3D 1.
>>>         */
>>>        if (!wait)
>>>                return 0;
>>>
>>>        upper_sb =3D ofs->upper_mnt->mnt_sb;
>>> +       if (sb_rdonly(upper_sb))
>>> +               return 0;
>>>
>>>        down_read(&upper_sb->s_umount);
>>> -       ret =3D sync_filesystem(upper_sb);
>>> +       ret =3D ovl_sync_filesystem(sb);
>>>        up_read(&upper_sb->s_umount);
>>
>> The boundaries between ovl_sync_fs() and ovl_sync_filesystem() are now v=
ery
>> strange.. taking upper_sb s_umount  lock outside and passing in sb etc.
>> I am not sure that ovl_sync/wait_inodes() should be called under upper_s=
b
>> s_umount lock at all. Remember we are already holding sb s_umount lock.
>> I suggest, now that ovl_sync/wait_inodes() have been factored out, to sq=
uash
>> ovl_sync_filesystem() back into ovl_sync_fs() and hold the s_umount lock
>> only around s_op->sync_fs() and sync_blockdev().
>
> From the comment in sync_filesystem, s_umount is used for against the fil=
esystem going
> from r/o to r/w or vice versa. so I think it is necessary and should move=
 readonly
> check inside ovl_sync_filesystem() to get the protection.
>

Right, but the interface between the 2 functions looks weird, so
please either get rid of
ovl_sync_filesystem() entirely and move its code into ovl_sync_fs()
under the s_umount
lock where needed or move the s_umount lock and sb_rdonly() test into
ovl_sync_filesystem(sb), which leaves ovl_sync_fs() pretty slim.

Thanks,
Amir.
