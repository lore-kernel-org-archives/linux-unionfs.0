Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v5 3/3] ovl: print warning when specifying unchangeable
 options in remount
From: cgxu519@gmx.com
In-Reply-To: <CAOQ4uxhkxHohGnsFoqPa3aqCDcTpQDVsdSO0EVCL_04LDwUgAw@mail.gmail.com>
Date: Sat, 14 Apr 2018 17:08:55 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F125E20-259D-4D73-BBCC-5A05965A5F8D@gmx.com>
References: <1523687744-10103-1-git-send-email-cgxu519@gmx.com>
 <1523687744-10103-4-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhkxHohGnsFoqPa3aqCDcTpQDVsdSO0EVCL_04LDwUgAw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C214=C8=D5=A3=AC=CF=C2=CE=E74:29=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sat, Apr 14, 2018 at 9:35 AM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> Check remount options and print warning if there is any unchangeable
>> option.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> Changes since v4:
>> - Only print warning when detecting unchangeable options in remount.
>> - Add validation of option 'default_permissions'.
>> - Fix potential memleak in ovl_remount().
>>=20
>> Changes since v3:
>> - Fix error prone macro helper.
>> - Make another new patch to only include code around.
>>=20
>> Changes since v2:
>> - Introduce two macro helpers to simplify remount option validation.
>>=20
>> Changes since v1:
>> - Refactor ovl_free_fs(), move config freeing operations to =
ovl_free_config().
>>=20
>> fs/overlayfs/super.c | 76 =
++++++++++++++++++++++++++++++++++++++++++++++++----
>> 1 file changed, 71 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 0293635a..5fa1e6e 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -230,6 +230,14 @@ static void ovl_destroy_inode(struct inode =
*inode)
>>        call_rcu(&inode->i_rcu, ovl_i_callback);
>> }
>>=20
>> +static void ovl_free_config(struct ovl_config *config)
>> +{
>> +       kfree(config->lowerdir);
>> +       kfree(config->upperdir);
>> +       kfree(config->workdir);
>> +       kfree(config->redirect_mode);
>> +}
>> +
>> static void ovl_free_fs(struct ovl_fs *ofs)
>> {
>>        unsigned i;
>> @@ -249,10 +257,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>>        kfree(ofs->lower_layers);
>>        kfree(ofs->lower_fs);
>>=20
>> -       kfree(ofs->config.lowerdir);
>> -       kfree(ofs->config.upperdir);
>> -       kfree(ofs->config.workdir);
>> -       kfree(ofs->config.redirect_mode);
>> +       ovl_free_config(&ofs->config);
>>        if (ofs->creator_cred)
>>                put_cred(ofs->creator_cred);
>>        kfree(ofs);
>> @@ -542,14 +547,75 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
>>        return ovl_parse_redirect_mode(config);
>> }
>>=20
>> +static bool ovl_opt_bool_neq(bool new, bool old, const char *name)
>> +{
>> +       if (new !=3D old) {
>> +               pr_err("overlayfs: option \"%s\" cannot be %s on =
remount.\n",
>=20
>               pr_warn("overlayfs: option \"%s\" cannot be %s on
> remount, ignore.\n",
>=20
>> +                                       name, new ? "enabled" : =
"disabled");
>> +               return true;
>> +       }
>> +       return false;
>> +}
>> +
>> +static bool ovl_opt_string_neq(const char *new, const char *old,
>> +                                               const char *name)
>> +{
>> +       if (new && (!old || strcmp(new, old))) {
>> +               pr_err("overlayfs: option \"%s\" cannot be changed on =
remount.\n",
>> +                                                                     =
  name);
>> +               return true;
>> +       }
>> +       return false;
>> +}
>> +
>> +#define ovl_config_opt_neq(old, new, name, type) \
>> +       ovl_opt_##type##_neq((old)->name, (new)->name, #name)
>> +
>> +/*
>> + * In current stage we only print warning message but not return =
error code
>> + * when detecting the behavior of setting new value to unchangeable =
options.
>> + */
>> static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>> {
>>        struct ovl_fs *ofs =3D sb->s_fs_info;
>> +       struct ovl_config *oc =3D &ofs->config;
>> +       struct ovl_config *nc;
>> +       int err;
>>=20
>>        if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>                return -EROFS;
>>=20
>> -       return 0;
>> +       nc =3D kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
>> +       if (!nc)
>> +               return -ENOMEM;
>> +
>> +       nc->index =3D oc->index;
>> +       nc->nfs_export =3D oc->nfs_export;
>> +       nc->default_permissions =3D oc->default_permissions;
>> +
>> +       err =3D ovl_parse_opt((char *)data, nc);
>> +       if (err)
>> +               goto out_err;
>> +
>> +       if (ovl_config_opt_neq(nc, oc, index, bool))
>> +               goto out_err;
>=20
> No point in goto out_err if not aborting remount.

Indeed, just calling ovl_config_opt_neq() without checking return code =
will be fine.

However, I plan to return error when failing from ovl_parse_opt(), in =
another word,
if user specifies unrecognized or invalid options then return -EINVAL.

I also need to add a check for xino.

Thanks,
Chengguang.
