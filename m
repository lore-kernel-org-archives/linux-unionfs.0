Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxhc9ceXeS-WJYc8MPh73ipVUxEO7iK5uCVikfrpq2bG7A@mail.gmail.com>
Date: Sun, 1 Apr 2018 20:16:08 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <5FEFAF00-D681-4FD2-AF4A-CDEB8A2B3CC6@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
 <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
 <C2127448-4F45-43F9-AF2E-2CF51BC980A4@gmx.com>
 <CAOQ4uxhc9ceXeS-WJYc8MPh73ipVUxEO7iK5uCVikfrpq2bG7A@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E77:33=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 2:06 PM, cgxu519@gmx.com <cgxu519@gmx.com> =
wrote:
>> =D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E76:02=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
> [...]
>>>=20
>>>>=20
>>>>>=20
>>>>>> +static int ovl_remount(struct super_block *sb, int *flags, char =
*data)
>>>>>> +{
>>>>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>>>>> +       struct ovl_config *old_config =3D &ofs->config;
>>>>>> +       struct ovl_config *new_config;
>>>>>> +       bool remount =3D true;
>>>>>=20
>>>>> No need for helper var.
>>>>>=20
>>>>>> +       int err;
>>>>>> +
>>>>>> +       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>>>>> +               return -EROFS;
>>>>>> +
>>>>>> +       new_config =3D kzalloc(sizeof(struct ovl_config), =
GFP_KERNEL);
>>>>>> +       if (!new_config)
>>>>>> +               return -ENOMEM;
>>>>>> +
>>>>>> +       new_config->index =3D old_config->index;
>>>>>> +       new_config->nfs_export =3D old_config->nfs_export;
>>>>>> +
>>>>>> +       err =3D ovl_parse_opt((char *)data, new_config, remount);
>>>>>> +       if (err)
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       err =3D -EINVAL;
>>>>>> +       if (new_config->lowerdir &&
>>>>>> +                       =
!ovl_string_option_equal(new_config->lowerdir,
>>>>>> +                                       old_config->lowerdir))
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       if (new_config->upperdir &&
>>>>>> +                       =
!ovl_string_option_equal(new_config->upperdir,
>>>>>> +                                       old_config->upperdir))
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       if (new_config->workdir &&
>>>>>> +                       =
!ovl_string_option_equal(new_config->workdir,
>>>>>> +                                       old_config->workdir))
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       if (new_config->redirect_mode &&
>>>>>> +               =
!ovl_string_option_equal(new_config->redirect_mode,
>>>>>> +                                       =
old_config->redirect_mode))
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       if (new_config->index !=3D old_config->index)
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       if (new_config->nfs_export !=3D old_config->nfs_export)
>>>>>> +               goto out_err;
>>>>>> +
>>>>>> +       return 0;
>>>>>> +out_err:
>>>>>=20
>>>>> This error really calls for error in dmesg preferably pointing =
user
>>>>> to the offending mount option.
>>>>>=20
>>>>> For this reason, I think it might be better to implement those =
checks
>>>>> inside ovl_parse_opt() while parsing each option.
>>>>>=20
>>>>> Instead of passing bool remount, you can pass ovl_config =
*oldconfig
>>>>> to signify remount.
>>>>>=20
>>>>> For string options, you can replace the following code with a =
small helper
>>>>> or macro to also include the remount logic:
>>>>>=20
>>>>>                      kfree(config->upperdir);
>>>>>                      config->upperdir =3D match_strdup(&args[0]);
>>>>>                      if (!config->upperdir)
>>>>>                              return -ENOMEM;
>>>>>                      if (oldconfig && old->config->upperdir &&
>>>>> !strcmp(config->upperdir, old->config->upperdir)
>>>>>                              goto remount_err; // where you can
>>>>> print an error with args[0]
>>>>>=20
>>>>=20
>>>> Actually, in my initial version I did just like what you wrote =
here,
>>>> but considering some future potential abilities(for example ro -> =
rw)
>>>> that we can add later, I decided to get new value through parsing.
>>>>=20
>>>=20
>>> I don't see how my suggestion limits to ability to allow for setting
>>> new options on remount. I just gave an example of a parameter that
>>> cannot be changed from NULL to non-NULL.
>>=20
>> I think your suggestion will work and probably effective way to do it
>> if we prohibit changing anything in parsing. but if we allow =
changeable
>> options, I just worry put too many logics of remount into option =
parsing.
>>=20
>=20
> Not much logic. Only 3 classifications that can be encoded in 3 =
different
> parsing helpers:
> 1. disallow change
> 2. allow change NULL->non-NULL
> 3. allow change non-NULL->non-NULL
>=20
> The parsing code doesn't do anything except setting the new
> values in config struct and applying one of the limitations above
> while parsing.

For example,=20
In ro->rw case, We need check a condition that from mount flags(rw)
to consider if workdir/upperdir change to non-NULL from NULL is
reasonable. So we have to pass mount flag to option parsing, right?

If we specify index=3Don with ro->rw, then in the index case, at least
we should check if workdir/upperdir mount option and rw mount flags have
already set and based on that to consider index=3Don is reasonable.

[=A1=AD]

>=20
> Setting up overlayfs based on new config values, whether
> old values where NULL or non-NULL is the job for remount code
> not of parsing code.
>=20
> [=A1=AD]
>=20
>>=20
>>>=20
>>> What was the motivation of this work for you?
>>> Do you have a specific set of options you want to change in remount?
>>=20
>> The initial motivation is from dynamically updating container image =
without downtime,
>> dynamic updating will significantly improve productivity(specially on =
communication for downtime)
>> when we change and update base image. overlayfs is only a part work =
in total solution
>> and actually we may need to reorganize/replace layers(maybe include =
lowers), but I think
>> analyzing and implementing remount will be good staring point.
>>=20
>> By the way, don=A1=AFt you think it will be special competitive =
feature of overlayfs compare to
>> other docker storage backend?
>>=20
>=20
> Maybe. I did not understand the use case exactly.
> I understand the use case of "rotate" - adding new upper and setting =
current
> upper at the top of lower layers stack.
>=20
> BTW, I have implemented remount for the overlayfs snapshot feature:
> https://github.com/amir73il/linux/commits/ovl_snapshot
>=20
> The interesting part about this implementation is not the remount =
itself,
> but the functions ovl_snapshot_revalidate() and =
ovl_snapshot_barrier().
> If you plan to embark on a mission to implement live "rotate", you =
should
> take a look at this implementation.
>=20
> The idea is that when remount changes layers configuration, you need
> to increment a "filesystem configuration version". The current fs =
version
> should be stored in every dentry and dentries should be lazily =
invalidated
> when the fs version has changed (on remount).

Very good reference!


Thanks,
Chengguang.
