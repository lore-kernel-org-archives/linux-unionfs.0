Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH 3/3] ovl: introduce a dedicated cache pool for ovl_entry
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxinZnZG4teKWgdXfFp_9nYgC=TOgsMLq=qruAY2CS91Pw@mail.gmail.com>
Date: Wed, 18 Apr 2018 08:59:05 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <38C045C0-4B23-497C-A2A6-860679E5CAC7@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
 <1523932965-25792-3-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxinZnZG4teKWgdXfFp_9nYgC=TOgsMLq=qruAY2CS91Pw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C217=C8=D5=A3=AC=CF=C2=CE=E76:41=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Apr 17, 2018 at 5:42 AM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> Introduce a dedicated cache pool for ovl_entry to optimize
>> memory allocation adn deallocation.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> ---
>> fs/overlayfs/export.c    | 11 +++++++----
>> fs/overlayfs/namei.c     |  7 +++++--
>> fs/overlayfs/overlayfs.h |  4 ++++
>> fs/overlayfs/ovl_entry.h |  9 +++++----
>> fs/overlayfs/super.c     | 38 +++++++++++++++++++++++++++++---------
>> fs/overlayfs/util.c      | 28 ++++++++++++++++++++++++----
>> 6 files changed, 74 insertions(+), 23 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index f2ba5fb..b1047ae 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -321,8 +321,8 @@ static struct dentry *ovl_obtain_alias(struct =
super_block *sb,
>>                        goto nomem;
>>=20
>>                if (lower) {
>> -                       oe->lowerstack->dentry =3D dget(lower);
>> -                       oe->lowerstack->layer =3D lowerpath->layer;
>> +                       oe->lowerstack.dentry =3D dget(lower);
>> +                       oe->lowerstack.layer =3D lowerpath->layer;
>>                }
>>                dentry->d_fsdata =3D oe;
>>                if (upper_alias)
>> @@ -346,9 +346,12 @@ static struct dentry *ovl_dentry_real_at(struct =
dentry *dentry, int idx)
>>        if (!idx)
>>                return ovl_dentry_upper(dentry);
>>=20
>> +       if (oe->numlower =3D=3D 1 && oe->lowerstack.layer->idx =3D=3D =
idx)
>> +               return oe->lowerstack.dentry;
>> +
>>        for (i =3D 0; i < oe->numlower; i++) {
>> -               if (oe->lowerstack[i].layer->idx =3D=3D idx)
>> -                       return oe->lowerstack[i].dentry;
>> +               if (oe->lowerstacks[i].layer->idx =3D=3D idx)
>> +                       return oe->lowerstacks[i].dentry;
>>        }
>>=20
>>        return NULL;
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index eb3ec6c..51fd914 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -994,7 +994,10 @@ struct dentry *ovl_lookup(struct inode *dir, =
struct dentry *dentry,
>>        if (!oe)
>>                goto out_put;
>>=20
>> -       memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
>> +       if (oe->numlower =3D=3D 1)
>> +               memcpy(&oe->lowerstack, stack, sizeof(struct =
ovl_path));
>> +       else
>> +               memcpy(oe->lowerstacks, stack, sizeof(struct =
ovl_path) * ctr);
>>        dentry->d_fsdata =3D oe;
>>=20
>>        if (upperopaque)
>> @@ -1028,7 +1031,7 @@ struct dentry *ovl_lookup(struct inode *dir, =
struct dentry *dentry,
>>=20
>> out_free_oe:
>>        dentry->d_fsdata =3D NULL;
>> -       kfree(oe);
>> +       ovl_free_entry(oe);
>> out_put:
>>        dput(index);
>>        for (i =3D 0; i < ctr; i++)
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index 8039602..a104e02 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -207,6 +207,7 @@ static inline struct dentry =
*ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
>> bool ovl_index_all(struct super_block *sb);
>> bool ovl_verify_lower(struct super_block *sb);
>> struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
>> +void ovl_free_entry(struct ovl_entry *oe);
>> bool ovl_dentry_remote(struct dentry *dentry);
>> bool ovl_dentry_weird(struct dentry *dentry);
>> enum ovl_path_type ovl_path_type(struct dentry *dentry);
>> @@ -378,3 +379,6 @@ int ovl_set_origin(struct dentry *dentry, struct =
dentry *lower,
>>=20
>> /* export.c */
>> extern const struct export_operations ovl_export_operations;
>> +
>> +/* super.c */
>> +extern struct kmem_cache *ovl_entry_cachep;
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 41655a7..3ed8ab4 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -71,13 +71,14 @@ struct ovl_fs {
>> /* private information held for every overlayfs dentry */
>> struct ovl_entry {
>>        union {
>> -               struct {
>> -                       unsigned long flags;
>> -               };
>> +               unsigned long flags;
>>                struct rcu_head rcu;
>>        };
>>        unsigned numlower;
>> -       struct ovl_path lowerstack[];
>> +       union {
>> +               struct ovl_path lowerstack;
>> +               struct ovl_path *lowerstacks;
>> +       };
>=20
> 1. The names are not representative to what they stand for
> 'stack' is something containing many items already, so you
> want 'lowerpath' (numlower =3D=3D 1) and 'lowerstack' (numlower > 1).
>=20
> 2. I suggested a different approach, not sure if it is better.
> I will repeat it in case you did not understand me:
>=20
>       struct ovl_path lowerstack[1];
>=20
> this approach requires no union and most of the code that does
> if (numlower =3D=3D 1) can be removed.
> Only need special casing alloc and free (see below).

Sounds better, let's try this.

Thanks,
Chengguang.
