Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com> <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Apr 2018 13:02:23 +0300
Message-ID: <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 11:22 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
>
>> =E5=9C=A8 2018=E5=B9=B44=E6=9C=881=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=883:=
39=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>>> Check remount options and return error if there is any unchangeable
>>> option.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>>> ---
>>> fs/overlayfs/super.c | 110 +++++++++++++++++++++++++++++++++++++++++---=
-------
>>> 1 file changed, 89 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index 5c8944b..ba00295 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
>>> @@ -353,27 +353,6 @@ static int ovl_show_options(struct seq_file *m, st=
ruct dentry *dentry)
>>>        return 0;
>>> }
>>>
>>> -static int ovl_remount(struct super_block *sb, int *flags, char *data)
>>> -{
>>> -       struct ovl_fs *ofs =3D sb->s_fs_info;
>>> -
>>> -       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>> -               return -EROFS;
>>> -
>>> -       return 0;
>>> -}
>>> -
>>> -static const struct super_operations ovl_super_operations =3D {
>>> -       .alloc_inode    =3D ovl_alloc_inode,
>>> -       .destroy_inode  =3D ovl_destroy_inode,
>>> -       .drop_inode     =3D generic_delete_inode,
>>> -       .put_super      =3D ovl_put_super,
>>> -       .sync_fs        =3D ovl_sync_fs,
>>> -       .statfs         =3D ovl_statfs,
>>> -       .show_options   =3D ovl_show_options,
>>> -       .remount_fs     =3D ovl_remount,
>>> -};
>>> -
>>> enum {
>>>        OPT_LOWERDIR,
>>>        OPT_UPPERDIR,
>>> @@ -534,6 +513,95 @@ static int ovl_parse_opt(char *opt, struct ovl_con=
fig *config, bool remount)
>>>        return ovl_parse_redirect_mode(config, config->redirect_mode);
>>> }
>>>
>>> +static bool ovl_string_option_equal(const char *new, const char *old)
>>> +{
>>> +       if (new) {
>>> +               if (old) {
>>> +                       if (!strcmp(new, old))
>>> +                               return true;
>>> +                       else
>>> +                               return false;
>>> +               } else {
>>> +                       return false;
>>> +               }
>>> +       } else {
>>> +               if (old)
>>> +                       return false;
>>> +               else
>>> +                       return true;
>>> +       }
>>> +}
>>> +
>>
>> Or maybe just:
>> {  return old && !strcmp(new, old); }
>>
>> You really only need to check when new is non NULL.
>>
>> But you don't even need this much if you follow my suggestion below.
>
> Yes, you are right. I just think to make a common string option compare f=
unction,
> so it is not optimized and it is maybe useful for further case(ro->rw?), =
in this
> case upperdir/wordir are from NULL to non NULL. If there is no other plac=
e need
> it in the future then we will need to modify it to better fit for existin=
g case.
>

So for generic:

{
    if (old =3D=3D new)
        return true;
    if (!old || !new)
        return false;
    return !strcmp(new, old);
}

and I wouldn't be surprised if you look for such an existing helper
in the kernel you will find it.

>
>>
>>> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
>>> +{
>>> +       struct ovl_fs *ofs =3D sb->s_fs_info;
>>> +       struct ovl_config *old_config =3D &ofs->config;
>>> +       struct ovl_config *new_config;
>>> +       bool remount =3D true;
>>
>> No need for helper var.
>>
>>> +       int err;
>>> +
>>> +       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>>> +               return -EROFS;
>>> +
>>> +       new_config =3D kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
>>> +       if (!new_config)
>>> +               return -ENOMEM;
>>> +
>>> +       new_config->index =3D old_config->index;
>>> +       new_config->nfs_export =3D old_config->nfs_export;
>>> +
>>> +       err =3D ovl_parse_opt((char *)data, new_config, remount);
>>> +       if (err)
>>> +               goto out_err;
>>> +
>>> +       err =3D -EINVAL;
>>> +       if (new_config->lowerdir &&
>>> +                       !ovl_string_option_equal(new_config->lowerdir,
>>> +                                       old_config->lowerdir))
>>> +               goto out_err;
>>> +
>>> +       if (new_config->upperdir &&
>>> +                       !ovl_string_option_equal(new_config->upperdir,
>>> +                                       old_config->upperdir))
>>> +               goto out_err;
>>> +
>>> +       if (new_config->workdir &&
>>> +                       !ovl_string_option_equal(new_config->workdir,
>>> +                                       old_config->workdir))
>>> +               goto out_err;
>>> +
>>> +       if (new_config->redirect_mode &&
>>> +               !ovl_string_option_equal(new_config->redirect_mode,
>>> +                                       old_config->redirect_mode))
>>> +               goto out_err;
>>> +
>>> +       if (new_config->index !=3D old_config->index)
>>> +               goto out_err;
>>> +
>>> +       if (new_config->nfs_export !=3D old_config->nfs_export)
>>> +               goto out_err;
>>> +
>>> +       return 0;
>>> +out_err:
>>
>> This error really calls for error in dmesg preferably pointing user
>> to the offending mount option.
>>
>> For this reason, I think it might be better to implement those checks
>> inside ovl_parse_opt() while parsing each option.
>>
>> Instead of passing bool remount, you can pass ovl_config *oldconfig
>> to signify remount.
>>
>> For string options, you can replace the following code with a small help=
er
>> or macro to also include the remount logic:
>>
>>                        kfree(config->upperdir);
>>                        config->upperdir =3D match_strdup(&args[0]);
>>                        if (!config->upperdir)
>>                                return -ENOMEM;
>>                        if (oldconfig && old->config->upperdir &&
>> !strcmp(config->upperdir, old->config->upperdir)
>>                                goto remount_err; // where you can
>> print an error with args[0]
>>
>
> Actually, in my initial version I did just like what you wrote here,
> but considering some future potential abilities(for example ro -> rw)
> that we can add later, I decided to get new value through parsing.
>

I don't see how my suggestion limits to ability to allow for setting
new options on remount. I just gave an example of a parameter that
cannot be changed from NULL to non-NULL.

> I haven=E2=80=99t got time to check closely, but ro -> rw in remount seem=
s doable
> if we carefully handle readdir related things, and what about other optio=
ns?
> Are all of them really unchangeable?
>

It's tricky, need to look closely at every option, because there are some
inter dependency between options and settings that are stored on
mount time and not changes later on.

Off the top of mt head, the change redirect_dir=3D[on|off|nofollow|follow]
should be pretty much standalone and independent of the rest of
the filesystem's state, so I don't see a reason why it cannot be changed
on remount.

For index and nfs_export, don't go there.

For adding upperdir/workdir (ro->rw) I can't think of a reason why
it shouldn't work, but need to see a patch.

What was the motivation of this work for you?
Do you have a specific set of options you want to change in remount?

Thanks,
Amir.
