Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
Date: Sun, 1 Apr 2018 19:06:40 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2127448-4F45-43F9-AF2E-2CF51BC980A4@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
 <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E76:02=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 11:22 AM, cgxu519@gmx.com <cgxu519@gmx.com> =
wrote:
>>=20
>>> =D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E73:39=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>>>> Check remount options and return error if there is any unchangeable
>>>> option.
>>>>=20
>>>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>>>> ---
>>>> fs/overlayfs/super.c | 110 =
+++++++++++++++++++++++++++++++++++++++++----------
>>>> 1 file changed, 89 insertions(+), 21 deletions(-)
>>>>=20
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 5c8944b..ba00295 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>>>> @@ -353,27 +353,6 @@ static int ovl_show_options(struct seq_file =
*m, struct dentry *dentry)
>>>>       return 0;
>>>> }
>>>>=20
>>>> -static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>>>> -{
>>>> -       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> -
>>>> -       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>>> -               return -EROFS;
>>>> -
>>>> -       return 0;
>>>> -}
>>>> -
>>>> -static const struct super_operations ovl_super_operations =3D {
>>>> -       .alloc_inode    =3D ovl_alloc_inode,
>>>> -       .destroy_inode  =3D ovl_destroy_inode,
>>>> -       .drop_inode     =3D generic_delete_inode,
>>>> -       .put_super      =3D ovl_put_super,
>>>> -       .sync_fs        =3D ovl_sync_fs,
>>>> -       .statfs         =3D ovl_statfs,
>>>> -       .show_options   =3D ovl_show_options,
>>>> -       .remount_fs     =3D ovl_remount,
>>>> -};
>>>> -
>>>> enum {
>>>>       OPT_LOWERDIR,
>>>>       OPT_UPPERDIR,
>>>> @@ -534,6 +513,95 @@ static int ovl_parse_opt(char *opt, struct =
ovl_config *config, bool remount)
>>>>       return ovl_parse_redirect_mode(config, =
config->redirect_mode);
>>>> }
>>>>=20
>>>> +static bool ovl_string_option_equal(const char *new, const char =
*old)
>>>> +{
>>>> +       if (new) {
>>>> +               if (old) {
>>>> +                       if (!strcmp(new, old))
>>>> +                               return true;
>>>> +                       else
>>>> +                               return false;
>>>> +               } else {
>>>> +                       return false;
>>>> +               }
>>>> +       } else {
>>>> +               if (old)
>>>> +                       return false;
>>>> +               else
>>>> +                       return true;
>>>> +       }
>>>> +}
>>>> +
>>>=20
>>> Or maybe just:
>>> {  return old && !strcmp(new, old); }
>>>=20
>>> You really only need to check when new is non NULL.
>>>=20
>>> But you don't even need this much if you follow my suggestion below.
>>=20
>> Yes, you are right. I just think to make a common string option =
compare function,
>> so it is not optimized and it is maybe useful for further =
case(ro->rw?), in this
>> case upperdir/wordir are from NULL to non NULL. If there is no other =
place need
>> it in the future then we will need to modify it to better fit for =
existing case.
>>=20
>=20
> So for generic:
>=20
> {
>    if (old =3D=3D new)
>        return true;
>    if (!old || !new)
>        return false;
>    return !strcmp(new, old);
> }
>=20
> and I wouldn't be surprised if you look for such an existing helper
> in the kernel you will find it.

OK, I=A1=AFll optimize this in V2.


>=20
>>=20
>>>=20
>>>> +static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>>>> +{
>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>> +       struct ovl_config *old_config =3D &ofs->config;
>>>> +       struct ovl_config *new_config;
>>>> +       bool remount =3D true;
>>>=20
>>> No need for helper var.
>>>=20
>>>> +       int err;
>>>> +
>>>> +       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>>> +               return -EROFS;
>>>> +
>>>> +       new_config =3D kzalloc(sizeof(struct ovl_config), =
GFP_KERNEL);
>>>> +       if (!new_config)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       new_config->index =3D old_config->index;
>>>> +       new_config->nfs_export =3D old_config->nfs_export;
>>>> +
>>>> +       err =3D ovl_parse_opt((char *)data, new_config, remount);
>>>> +       if (err)
>>>> +               goto out_err;
>>>> +
>>>> +       err =3D -EINVAL;
>>>> +       if (new_config->lowerdir &&
>>>> +                       =
!ovl_string_option_equal(new_config->lowerdir,
>>>> +                                       old_config->lowerdir))
>>>> +               goto out_err;
>>>> +
>>>> +       if (new_config->upperdir &&
>>>> +                       =
!ovl_string_option_equal(new_config->upperdir,
>>>> +                                       old_config->upperdir))
>>>> +               goto out_err;
>>>> +
>>>> +       if (new_config->workdir &&
>>>> +                       =
!ovl_string_option_equal(new_config->workdir,
>>>> +                                       old_config->workdir))
>>>> +               goto out_err;
>>>> +
>>>> +       if (new_config->redirect_mode &&
>>>> +               !ovl_string_option_equal(new_config->redirect_mode,
>>>> +                                       old_config->redirect_mode))
>>>> +               goto out_err;
>>>> +
>>>> +       if (new_config->index !=3D old_config->index)
>>>> +               goto out_err;
>>>> +
>>>> +       if (new_config->nfs_export !=3D old_config->nfs_export)
>>>> +               goto out_err;
>>>> +
>>>> +       return 0;
>>>> +out_err:
>>>=20
>>> This error really calls for error in dmesg preferably pointing user
>>> to the offending mount option.
>>>=20
>>> For this reason, I think it might be better to implement those =
checks
>>> inside ovl_parse_opt() while parsing each option.
>>>=20
>>> Instead of passing bool remount, you can pass ovl_config *oldconfig
>>> to signify remount.
>>>=20
>>> For string options, you can replace the following code with a small =
helper
>>> or macro to also include the remount logic:
>>>=20
>>>                       kfree(config->upperdir);
>>>                       config->upperdir =3D match_strdup(&args[0]);
>>>                       if (!config->upperdir)
>>>                               return -ENOMEM;
>>>                       if (oldconfig && old->config->upperdir &&
>>> !strcmp(config->upperdir, old->config->upperdir)
>>>                               goto remount_err; // where you can
>>> print an error with args[0]
>>>=20
>>=20
>> Actually, in my initial version I did just like what you wrote here,
>> but considering some future potential abilities(for example ro -> rw)
>> that we can add later, I decided to get new value through parsing.
>>=20
>=20
> I don't see how my suggestion limits to ability to allow for setting
> new options on remount. I just gave an example of a parameter that
> cannot be changed from NULL to non-NULL.

I think your suggestion will work and probably effective way to do it
if we prohibit changing anything in parsing. but if we allow changeable
options, I just worry put too many logics of remount into option =
parsing.=20

>=20
>> I haven=A1=AFt got time to check closely, but ro -> rw in remount =
seems doable
>> if we carefully handle readdir related things, and what about other =
options?
>> Are all of them really unchangeable?
>>=20
>=20
> It's tricky, need to look closely at every option, because there are =
some
> inter dependency between options and settings that are stored on
> mount time and not changes later on.
>=20
> Off the top of mt head, the change =
redirect_dir=3D[on|off|nofollow|follow]
> should be pretty much standalone and independent of the rest of
> the filesystem's state, so I don't see a reason why it cannot be =
changed
> on remount.
>=20
> For index and nfs_export, don't go there.
>=20
> For adding upperdir/workdir (ro->rw) I can't think of a reason why
> it shouldn't work, but need to see a patch.

Thanks for your analyzation, maybe ro->rw is a good starting point
after this supporting infrastructure.

>=20
> What was the motivation of this work for you?
> Do you have a specific set of options you want to change in remount?

The initial motivation is from dynamically updating container image =
without downtime,
dynamic updating will significantly improve productivity(specially on =
communication for downtime)
when we change and update base image. overlayfs is only a part work in =
total solution
and actually we may need to reorganize/replace layers(maybe include =
lowers), but I think
analyzing and implementing remount will be good staring point.

By the way, don=A1=AFt you think it will be special competitive feature =
of overlayfs compare to
other docker storage backend?

Thanks,
Chengguang.
