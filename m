From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: sync filesystem of overlayfs
Date: Mon, 27 Nov 2017 13:30:35 +0200
Message-ID: <CAOQ4uxiROew32J_Xv7bGnHxaM9iexjJ6dQSbJ1gENbCUtHi1aQ@mail.gmail.com>
References: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
 <CAOQ4uxjnVajcd=0tqVYbGiTSmMhN_Pemjn3N2fhTZs4KYasV_w@mail.gmail.com> <771732B7-80A0-4011-BC98-9A40375A8858@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:42076 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdK0Lah (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 06:30:37 -0500
Received: by mail-yb0-f170.google.com with SMTP id w203so10419025ybe.9
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 03:30:36 -0800 (PST)
In-Reply-To: <771732B7-80A0-4011-BC98-9A40375A8858@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, suyue@meili-inc.com

On Mon, Nov 27, 2017 at 12:31 PM, cgxu <cgxu@mykernel.net> wrote:
>
>
>> =E5=9C=A8 2017=E5=B9=B411=E6=9C=8827=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
4:59=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Mon, Nov 27, 2017 at 10:08 AM, cgxu <cgxu@mykernel.net> wrote:
>>>
>>> Hi,
>>>
>>> Recently I found syncfs and umount could not make data consistency in o=
verlayfs.
>>> I did some investigations and now I know synchronization didn=E2=80=99t=
 directly happen
>>> in upperdir filesystem during these operations executed in overlayfs.
>>>
>>
>> Can you share the method of your investigation?
>> Maybe make it into an xfstest?
>> You can probably use dmflakey target.
>
> Testing method as below. (I tested in virtual machine)
>
> 1. stop bd_writeback behavior by adjusting parameters in /proc/sys/vm/
> 2. copy a large file to overlayfs directory and then do syncfs or umount.
> 3. power off && power on
> 4. compare content of files using diff.
>
> and I also applied below simple quick patch (may need more check for deta=
il) to check fixing result.
>
> -----------
> $ git diff
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 7b64d5c..3ab25a7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1222,11 +1222,24 @@ static struct dentry *ovl_mount(struct file_syste=
m_type *fs_type, int flags,
>         return mount_nodev(fs_type, flags, raw_data, ovl_fill_super);
>  }
>
> +static void ovl_kill_super(struct super_block *sb)
> +{
> +        struct ovl_fs *ufs =3D sb->s_fs_info;
> +       struct super_block *real_super =3D ufs->upper_mnt->mnt_sb;
> +
> +        if (!(sb->s_flags & MS_RDONLY)) {
> +                down_read(&real_super->s_umount);
> +                sync_filesystem(real_super);
> +                up_read(&real_super->s_umount);
> +        }
> +        kill_anon_super(sb);
> +}
> +

kill_anon_super() -> generic_shutdown_super() -> sync_filesystem()

So your implementation should go into ovl_sync_fs instead to cover
other cases like freeze_super() and plain syncfs().

>  static struct file_system_type ovl_fs_type =3D {
>         .owner          =3D THIS_MODULE,
>         .name           =3D "overlay",
>         .mount          =3D ovl_mount,
> -       .kill_sb        =3D kill_anon_super,
> +       .kill_sb        =3D ovl_kill_super,
>  };
>  MODULE_ALIAS_FS("overlay");
>
> diff --git a/fs/sync.c b/fs/sync.c
> index 83ac79a..d49792c 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -161,6 +161,8 @@ void emergency_sync(void)
>         if (!f.file)
>                 return -EBADF;
>         sb =3D f.file->f_path.dentry->d_sb;
> +       if (!(sb->s_flags & MS_RDONLY))
> +               sb =3D d_real(f.file->f_path.dentry, NULL, f.file->f_flag=
s, 0)->d_sb;
>

No reason to change vfs.
sync_filesystem() calls ovl_sync_fs() where upper fs can be synced.

>         down_read(&sb->s_umount);
>         ret =3D sync_filesystem(sb);
>
>
> -----------
>
>
>>
>>> I'm also confused by below comment in function ovl_sync_fs() in super.c
>>>
>>> /* real inodes have already been synced by sync_filesystem(ovl_sb) */
>>>
>>> In my understanding sync_filesystem(ovl_sb) can not make real inodes sy=
nced
>>> unless delivers real superblock of upperdir filesystem to sync_filesyst=
em().
>>>
>>> I can=E2=80=99t make sure current implementation is by design or for so=
me other reasons because
>>> sync upperdir filesystem may be a little bit heavy especially in a larg=
e filesystem.
>>> Could anyone give me a hint for this=EF=BC=9F
>>>
>>
>> Looks like you are right.
>> That comment I wrote is an oversight, not by design, although the concer=
n
>> that you raise is valid.
>>
>>> If this problem needs to be fix, I=E2=80=99ll try to make a patch for r=
eview.
>>>
>>
>> So the simple way would be to call __sync_filesystem() from ovl_sync_fs(=
)
>> instead of calling upper_sb->s_op->sync_fs(), but that would be heavy
>> as you said.
>> A better fix would be to iterate overlay sb inodes and flush only the di=
rty
>> ovl_inode_upper() pages, before calling upper_sb->s_op->sync_fs().
>>
>> I didn't look closely to see how complex that would be, so let me know w=
hat
>> you think is best.
>
> The easiest way is as you said or like quick patch above,
> but sync_fs() seems like doing superblock related things only in most cas=
e.
>

It does everything that generic vfs sync_filesystem() doesn't do.
In overlayfs case, that is syncing upper fs.

> For me maybe ideal way is define new virtual BDI for overlayfs,
> and using that to organize dirty inodes, so that we don=E2=80=99t have to=
 put much
> effort to looking for target inodes. If this approach makes sense I=E2=80=
=99ll
> carefully consider detail.
>
> We can just fix this problem in simple way first and consider
> better solution later because that is probably related to many complex th=
ings.
>

Agree. Safety first!

> I think for most people umount or sync_fs takes time is acceptable and at=
 least
> it is much better than data inconsistency.
>

Not sure about that. I heard there are use cases for containers for
which the time
of mount/umount matters.
We'll have to see about that.

Thanks,
Amir.
