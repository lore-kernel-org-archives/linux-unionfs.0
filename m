Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
Date: Sun, 1 Apr 2018 16:22:22 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>


> =D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E73:39=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> Check remount options and return error if there is any unchangeable
>> option.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> fs/overlayfs/super.c | 110 =
+++++++++++++++++++++++++++++++++++++++++----------
>> 1 file changed, 89 insertions(+), 21 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 5c8944b..ba00295 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -353,27 +353,6 @@ static int ovl_show_options(struct seq_file *m, =
struct dentry *dentry)
>>        return 0;
>> }
>>=20
>> -static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>> -{
>> -       struct ovl_fs *ofs =3D sb->s_fs_info;
>> -
>> -       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>> -               return -EROFS;
>> -
>> -       return 0;
>> -}
>> -
>> -static const struct super_operations ovl_super_operations =3D {
>> -       .alloc_inode    =3D ovl_alloc_inode,
>> -       .destroy_inode  =3D ovl_destroy_inode,
>> -       .drop_inode     =3D generic_delete_inode,
>> -       .put_super      =3D ovl_put_super,
>> -       .sync_fs        =3D ovl_sync_fs,
>> -       .statfs         =3D ovl_statfs,
>> -       .show_options   =3D ovl_show_options,
>> -       .remount_fs     =3D ovl_remount,
>> -};
>> -
>> enum {
>>        OPT_LOWERDIR,
>>        OPT_UPPERDIR,
>> @@ -534,6 +513,95 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config, bool remount)
>>        return ovl_parse_redirect_mode(config, config->redirect_mode);
>> }
>>=20
>> +static bool ovl_string_option_equal(const char *new, const char =
*old)
>> +{
>> +       if (new) {
>> +               if (old) {
>> +                       if (!strcmp(new, old))
>> +                               return true;
>> +                       else
>> +                               return false;
>> +               } else {
>> +                       return false;
>> +               }
>> +       } else {
>> +               if (old)
>> +                       return false;
>> +               else
>> +                       return true;
>> +       }
>> +}
>> +
>=20
> Or maybe just:
> {  return old && !strcmp(new, old); }
>=20
> You really only need to check when new is non NULL.
>=20
> But you don't even need this much if you follow my suggestion below.

Yes, you are right. I just think to make a common string option compare =
function,
so it is not optimized and it is maybe useful for further case(ro->rw?), =
in this
case upperdir/wordir are from NULL to non NULL. If there is no other =
place need
it in the future then we will need to modify it to better fit for =
existing case.=20


>=20
>> +static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>> +{
>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>> +       struct ovl_config *old_config =3D &ofs->config;
>> +       struct ovl_config *new_config;
>> +       bool remount =3D true;
>=20
> No need for helper var.
>=20
>> +       int err;
>> +
>> +       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>> +               return -EROFS;
>> +
>> +       new_config =3D kzalloc(sizeof(struct ovl_config), =
GFP_KERNEL);
>> +       if (!new_config)
>> +               return -ENOMEM;
>> +
>> +       new_config->index =3D old_config->index;
>> +       new_config->nfs_export =3D old_config->nfs_export;
>> +
>> +       err =3D ovl_parse_opt((char *)data, new_config, remount);
>> +       if (err)
>> +               goto out_err;
>> +
>> +       err =3D -EINVAL;
>> +       if (new_config->lowerdir &&
>> +                       =
!ovl_string_option_equal(new_config->lowerdir,
>> +                                       old_config->lowerdir))
>> +               goto out_err;
>> +
>> +       if (new_config->upperdir &&
>> +                       =
!ovl_string_option_equal(new_config->upperdir,
>> +                                       old_config->upperdir))
>> +               goto out_err;
>> +
>> +       if (new_config->workdir &&
>> +                       !ovl_string_option_equal(new_config->workdir,
>> +                                       old_config->workdir))
>> +               goto out_err;
>> +
>> +       if (new_config->redirect_mode &&
>> +               !ovl_string_option_equal(new_config->redirect_mode,
>> +                                       old_config->redirect_mode))
>> +               goto out_err;
>> +
>> +       if (new_config->index !=3D old_config->index)
>> +               goto out_err;
>> +
>> +       if (new_config->nfs_export !=3D old_config->nfs_export)
>> +               goto out_err;
>> +
>> +       return 0;
>> +out_err:
>=20
> This error really calls for error in dmesg preferably pointing user
> to the offending mount option.
>=20
> For this reason, I think it might be better to implement those checks
> inside ovl_parse_opt() while parsing each option.
>=20
> Instead of passing bool remount, you can pass ovl_config *oldconfig
> to signify remount.
>=20
> For string options, you can replace the following code with a small =
helper
> or macro to also include the remount logic:
>=20
>                        kfree(config->upperdir);
>                        config->upperdir =3D match_strdup(&args[0]);
>                        if (!config->upperdir)
>                                return -ENOMEM;
>                        if (oldconfig && old->config->upperdir &&
> !strcmp(config->upperdir, old->config->upperdir)
>                                goto remount_err; // where you can
> print an error with args[0]
>=20

Actually, in my initial version I did just like what you wrote here,=20
but considering some future potential abilities(for example ro -> rw)
that we can add later, I decided to get new value through parsing.

I haven=A1=AFt got time to check closely, but ro -> rw in remount seems =
doable
if we carefully handle readdir related things, and what about other =
options?
Are all of them really unchangeable?=20


>=20
> For bool options you just need to add a test at the end
> to compare values with oldconfig if oldconfig is not NULL
> and error, because it is OK to pass options index=3Don,index=3Doff,..
> as long as the last is same as oldconfig.
>=20
>=20
>> +       kfree(new_config->lowerdir);
>> +       kfree(new_config->upperdir);
>> +       kfree(new_config->workdir);
>> +       kfree(new_config->redirect_mode);
>> +       kfree(new_config);
>=20
> That's code duplication with ovl_free_fs()
> Please use ovl_free_config() helper.
>=20
> Thanks,
> Amir.
