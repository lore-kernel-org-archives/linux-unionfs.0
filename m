Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v3 1/2] ovl: adjust option parsing for supporting remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxjcfVJfi1CtkM8QAbHeL7PMHiv8mKTJXUq+JfimEsXzUQ@mail.gmail.com>
Date: Fri, 13 Apr 2018 14:35:19 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <03636809-1CE6-4726-98BF-B58B79EEFCF6@gmx.com>
References: <1523547406-67046-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxjcfVJfi1CtkM8QAbHeL7PMHiv8mKTJXUq+JfimEsXzUQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>


> =D4=DA 2018=C4=EA4=D4=C213=C8=D5=A3=AC=CF=C2=CE=E72:21=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Apr 12, 2018 at 6:36 PM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> Some overlayfs mount options cannot be changed via remount,
>> but remount does not return error even if we specify different
>> value to unchangeable options.
>>=20
>> This patch adjusts option parsing to support remount, so we
>> can recogonize unchangeable options in remount.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> Changes since v2:
>> - Move default initialization of redirect_mode to fill_super()
>> just before calling parse_opt().
>> - Move workdir validation check to fill_super().
>> - Move remount option validation to ovl_remount().
>=20
> This is not in this patch.
> IMO, you should add a cover letter (git format-patch --cover) for your
> next posting explaining your motivation to this work.
> Usually, the patch revision change log is more relevant in
> this context of the cover letter.

I=A1=AFll do.


>>=20
>> Changes since v1:
>> - Add remount option validation to parse_opt()
>>=20
>> fs/overlayfs/super.c | 29 +++++++++++++++++------------
>> 1 file changed, 17 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index e8551c9..a2a7b7a 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -457,6 +457,9 @@ static char *ovl_next_opt(char **s)
>>=20
>> static int ovl_parse_redirect_mode(struct ovl_config *config, const =
char *mode)
>> {
>> +       if (!mode)
>> +               return 0;
>> +
>=20
> When I wrote that mode argument is redundant it is because
> you always pass in config->mode and config is already an argument.
> If this function expects config->mode to be set, then you could do
>=20
> if (WARN_ON(!config->mode))
>   return 0;

config->mode is not always expected to be set, in remount it could be =
NULL.
For mode argument, I=A1=AFll fix in next version.



>>        if (strcmp(mode, "on") =3D=3D 0) {
>>                config->redirect_dir =3D true;
>>                /*
>> @@ -482,10 +485,6 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
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
>> @@ -561,14 +560,6 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
>>                }
>>        }
>>=20
>> -       /* Workdir is useless in non-upper mount */
>> -       if (!config->upperdir && config->workdir) {
>> -               pr_info("overlayfs: option \"workdir=3D%s\" is =
useless in a non-upper mount, ignore\n",
>> -                       config->workdir);
>> -               kfree(config->workdir);
>> -               config->workdir =3D NULL;
>> -       }
>> -
>>        return ovl_parse_redirect_mode(config, config->redirect_mode);
>> }
>>=20
>> @@ -1376,10 +1367,24 @@ static int ovl_fill_super(struct super_block =
*sb, void *data, int silent)
>>        ofs->config.index =3D ovl_index_def;
>>        ofs->config.nfs_export =3D ovl_nfs_export_def;
>>        ofs->config.xino =3D ovl_xino_def();
>> +
>> +       ofs->config.redirect_mode =3D =
kstrdup(ovl_redirect_mode_def(),
>> +                                                       GFP_KERNEL);
>> +       if (!ofs->config.redirect_mode)
>> +               goto out_err;
>> +
>>        err =3D ovl_parse_opt((char *) data, &ofs->config);
>>        if (err)
>>                goto out_err;
>>=20
>> +       /* Workdir is useless in non-upper mount */
>> +       if (!ofs->config.upperdir && ofs->config.workdir) {
>> +               pr_info("overlayfs: option \"workdir=3D%s\" is =
useless in a non-upper mount, ignore\n",
>> +                       ofs->config.workdir);
>> +               kfree(ofs->config.workdir);
>> +               ofs->config.workdir =3D NULL;
>> +       }
>> +
>>=20
>=20
>=20
> Why did you move this? isn't this code relevant to remount as well?

I think the code will affect result of remount option validation,
in current stage, we need return error when specifying workdir without =
upperdir in remount.

Thanks,
Chengguang.
