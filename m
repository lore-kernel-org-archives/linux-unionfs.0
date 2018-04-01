Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 1/2] ovl: add option parsing support for remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxhRyG-0JYNWsVhkzQ0+ue-xdSVkfM7gX4LdNu9kkoWNTg@mail.gmail.com>
Date: Sun, 1 Apr 2018 16:50:18 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1EDA16B-2547-4DA9-9687-4417C11491A3@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhRyG-0JYNWsVhkzQ0+ue-xdSVkfM7gX4LdNu9kkoWNTg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E73:11=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> Some overlayfs mount options cannot be changed via remount,
>> but remount operation does not return proper error even if
>> we specify different value to unchangeable options.
>>=20
>> This patch add option parsing support for remount so we can
>> recogonize unchangeable options in remount.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> fs/overlayfs/super.c | 19 +++++++++++++------
>> 1 file changed, 13 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 7c24619..5c8944b 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -446,14 +446,10 @@ static int ovl_parse_redirect_mode(struct =
ovl_config *config, const char *mode)
>>        return 0;
>> }
>>=20
>> -static int ovl_parse_opt(char *opt, struct ovl_config *config)
>> +static int ovl_parse_opt(char *opt, struct ovl_config *config, bool =
remount)
>> {
>>        char *p;
>>=20
>> -       config->redirect_mode =3D kstrdup(ovl_redirect_mode_def(), =
GFP_KERNEL);
>> -       if (!config->redirect_mode)
>> -               return -ENOMEM;
>> -
>>        while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
>>                int token;
>>                substring_t args[MAX_OPT_ARGS];
>> @@ -517,6 +513,9 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
>>                }
>>        }
>>=20
>> +       if (remount)
>> +               return 0;
>> +
>>        /* Workdir is useless in non-upper mount */
>>        if (!config->upperdir && config->workdir) {
>>                pr_info("overlayfs: option \"workdir=3D%s\" is useless =
in a non-upper mount, ignore\n",
>> @@ -525,6 +524,13 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
>>                config->workdir =3D NULL;
>>        }
>>=20
>> +       if (!config->redirect_mode) {
>> +               config->redirect_mode =3D =
kstrdup(ovl_redirect_mode_def(),
>> +                                                       GFP_KERNEL);
>> +               if (!config->redirect_mode)
>> +                       return -ENOMEM;
>> +       }
>> +
>=20
> You can move this chunk into ovl_parse_redirect_mode() no?

I just guess the purpose of sending "config->redirect_mode=A1=B1 as =
function parameter,
then I think the author hopes adding =A1=AEconst=A1=AF attribution to =
the string when doing
comparison. I=A1=AFm not so sure should break the rule or not, What do =
you think?


>=20
>>        return ovl_parse_redirect_mode(config, config->redirect_mode);
>> }
>>=20
>> @@ -1250,6 +1256,7 @@ static int ovl_fill_super(struct super_block =
*sb, void *data, int silent)
>>        struct ovl_entry *oe;
>>        struct ovl_fs *ofs;
>>        struct cred *cred;
>> +       bool remount =3D false;
>=20
> This helper var is not needed.
>=20
> Thanks,
> Amir.
>=20
>>        int err;
>>=20
>>        err =3D -ENOMEM;
>> @@ -1263,7 +1270,7 @@ static int ovl_fill_super(struct super_block =
*sb, void *data, int silent)
>>=20
>>        ofs->config.index =3D ovl_index_def;
>>        ofs->config.nfs_export =3D ovl_nfs_export_def;
>> -       err =3D ovl_parse_opt((char *) data, &ofs->config);
>> +       err =3D ovl_parse_opt((char *) data, &ofs->config, remount);
>>        if (err)
>>                goto out_err;
>>=20
>> --
>> 1.8.3.1
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
