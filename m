Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v2 1/2] ovl: add option parsing support for remount
From: cgxu519@gmx.com
In-Reply-To: <CAOQ4uxgeD6zHm+D1B2H-P4WUpAgK2BgpSw6KXsiyiEaJpSpR9Q@mail.gmail.com>
Date: Wed, 11 Apr 2018 13:59:19 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <AC729CAD-5B27-439D-B899-E592A936DC5C@gmx.com>
References: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxgeD6zHm+D1B2H-P4WUpAgK2BgpSw6KXsiyiEaJpSpR9Q@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C24=C8=D5=A3=AC=CF=C2=CE=E76:44=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Apr 4, 2018 at 12:27 PM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> Some overlayfs mount options cannot be changed via remount,
>> but remount operation does not return proper error even if
>> we specify different value to unchangeable options.
>>=20
>> This patch add option parsing support for remount so we can
>> recogonize unchangeable options in remount.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>>=20
>> Changes since v1:
>> - Add remount option validation to parse_opt()
>>=20
>> fs/overlayfs/super.c | 133 =
++++++++++++++++++++++++++++++++++++++++++++++++---
>> 1 file changed, 127 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 7c24619..4112720 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -425,6 +425,16 @@ static char *ovl_next_opt(char **s)
>>=20
>> static int ovl_parse_redirect_mode(struct ovl_config *config, const =
char *mode)
>> {
>> +
>> +       if (!mode) {
>> +               config->redirect_mode =3D =
kstrdup(ovl_redirect_mode_def(),
>> +                                                       GFP_KERNEL);
>> +               if (!config->redirect_mode)
>> +                       return -ENOMEM;
>> +
>> +               mode =3D config->redirect_mode;
>> +       }
>=20
> This makes @mode argument to function redundant.

Maybe moving default initialization before calling parse_opt() is =
better,=20
what do you think?


>=20
>> +
>>        if (strcmp(mode, "on") =3D=3D 0) {
>>                config->redirect_dir =3D true;
>>                /*
>> @@ -446,13 +456,49 @@ static int ovl_parse_redirect_mode(struct =
ovl_config *config, const char *mode)
>>        return 0;
>> }
>>=20
>> -static int ovl_parse_opt(char *opt, struct ovl_config *config)
>> +static char *ovl_token_to_string(int token)
>> {
>> -       char *p;
>> +       switch (token) {
>> +       case OPT_UPPERDIR: return "upperdir";
>> +       case OPT_LOWERDIR: return "lowerdir";
>> +       case OPT_WORKDIR: return "workdir";
>> +       case OPT_DEFAULT_PERMISSIONS: return "default_permissions";
>> +       case OPT_REDIRECT_DIR: return "redirect_dir";
>> +       case OPT_INDEX_ON:
>> +       case OPT_INDEX_OFF: return "index";
>> +       case OPT_NFS_EXPORT_ON:
>> +       case OPT_NFS_EXPORT_OFF: return "nfs_export";
>> +       default: return "???";
>> +       }
>> +}
>=20
> You don't need this. The option name is available in args[0]
> variable when calling the parsing macros and I don't think
> you need to bother with stripping the =3Dxxx part.
>=20
>>=20
>> -       config->redirect_mode =3D kstrdup(ovl_redirect_mode_def(), =
GFP_KERNEL);
>> -       if (!config->redirect_mode)
>> -               return -ENOMEM;
>> +static int ovl_valid_remount_string_option(int token, const char =
*new,
>> +                                               const char *old)
>> +{
>> +       if (!old || strcmp(new, old)) {
>> +               pr_err("overlayfs: option %s cannot be changed on =
remount.\n",
>> +                               ovl_token_to_string(token));
>> +               return -EINVAL;
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int ovl_valid_remount_bool_option(int token, const bool new,
>> +                                               const bool old)
>> +{
>> +       if (new !=3D old) {
>> +               pr_err("overlayfs: option %s cannot be changed on =
remount.\n",
>> +                               ovl_token_to_string(token));
>> +               return -EINVAL;
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int ovl_parse_opt(char *opt, struct ovl_config *config,
>> +                                       struct ovl_config =
*old_config)
>> +{
>> +       char *p;
>> +       int err;
>>=20
>>        while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
>>                int token;
>> @@ -468,6 +514,14 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config)
>>                        config->upperdir =3D match_strdup(&args[0]);
>>                        if (!config->upperdir)
>>                                return -ENOMEM;
>> +                       if (old_config) {
>> +                               err =3D =
ovl_valid_remount_string_option(
>> +                                       token,
>> +                                       config->upperdir,
>> +                                       old_config->upperdir);
>> +                               if (err)
>> +                                       return err;
>> +                       }
>=20
> Brevity: instead of adding 8 lines to each case, you can squeeze the =
entire
> handling of string option to a single macro, e.g.:
>=20
>        err =3D (ovl_parse_string_option(upperdir, &args[0], config, =
oldconfig);
>        if (err)
>            return err;
>=20
> Same for ovl_parse_bool_option.
>=20
> Later, when you want to introduce an option that could be changed
> on remount or only changed from NULL, just add new macro flavors:
>=20
> ovl_parse_remount_[string|bool]_option
> ovl_parse_test_and_remount_[string|bool]_option
>=20
> Let me know if you are not clear on how.

OK, I=A1=AFll make the code looks more concise, but I still hope to put =
all related
checking logic inside remount and just keep parse_opt as simple as =
possible.
Because parse_opt also calls from mount and I think validating related =
options
in one place will be simpler.


Thanks,
Chengguang.
