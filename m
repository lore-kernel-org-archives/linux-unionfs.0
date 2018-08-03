Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-6-yi.zhang@huawei.com>
 <CAOQ4uxgwUnna5zs1n2S9UkHKv4wH1n0QA-96kSsTJ+iDiah8gQ@mail.gmail.com> <3d2b993b-6046-784a-765a-c5fd65adcc10@huawei.com>
In-Reply-To: <3d2b993b-6046-784a-765a-c5fd65adcc10@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 3 Aug 2018 22:38:23 +0200
Message-ID: <CAOQ4uxh8sC+frLSHMqiz9p46fmOYdBsnuhjqJYNVqz2u990rpQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/9] ovl: add redirect dir feature when set
 redirect xattr to dir
Content-Type: multipart/alternative; boundary="00000000000082da2205728de95c"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

--00000000000082da2205728de95c
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 3, 2018, 1:52 PM zhangyi (F) <yi.zhang@huawei.com> wrote:

> On 2018/8/1 19:03, Amir Goldstein Wrote:
> > On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com>
> wrote:
> >> Redirect dir feature is backward incompatible because old kernel (which
> >> not support this feature) may corrupt the merge relationship between
> >> directories when change the directory which have redirect xattr.
> >>
> >> This patch check and set the upper layer's redirect dir feature when
> >> kernel set redirect xattr to directory in the upper layer.
> >>
> >> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> >> ---
> >>  fs/overlayfs/dir.c       | 11 +++++++++++
> >>  fs/overlayfs/overlayfs.h |  5 ++++-
> >>  2 files changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> >> index f480b1a2cd2e..238999e5f47b 100644
> >> --- a/fs/overlayfs/dir.c
> >> +++ b/fs/overlayfs/dir.c
> >> @@ -969,6 +969,7 @@ static int ovl_rename(struct inode *olddir, struct
> dentry *old,
> >>         bool is_dir = d_is_dir(old);
> >>         bool new_is_dir = d_is_dir(new);
> >>         bool samedir = olddir == newdir;
> >> +       struct ovl_fs* ofs = old->d_sb->s_fs_info;
> >>         struct dentry *opaquedir = NULL;
> >>         const struct cred *old_cred = NULL;
> >>         LIST_HEAD(list);
> >> @@ -1061,6 +1062,16 @@ static int ovl_rename(struct inode *olddir,
> struct dentry *old,
> >>                 }
> >>         }
> >>
> >> +       if ((is_dir && ovl_type_merge_or_lower(old)) ||
> >> +           (!overwrite && new_is_dir && ovl_type_merge_or_lower(new)))
> {
> >> +               /*
> >> +                * Set redirect dir feature to the upper root dir if
> this
> >> +                * feature doesn't exist.
> >> +                */
> >> +               if (!ovl_has_feature_redirect_dir(ofs->upper_layer))
> >> +                       err = ovl_set_feature_redirect_dir(ofs);
> >> +       }
> >> +
> >
> > Please just place a call to  ovl_set_feature_redirect_dir(ofs)
> > inside ovl_set_redirect(). There is no need to check all those
> > conditions.
> > Also, there is no need to check ovl_has_feature_redirect_dir()
> > as ovl_set_feature() already checks for existing bit.
> >
>
> I understand check those condition is not perfect, but place it
> to ovl_set_redirect() will lead to inode AA dead lock if the
> parent dir of the renamed dir is the upper root dir, because
> lock_rename() and vfs_setxattr() will get the same inode lock.
>
> ovl_rename()
>   ->lock_rename(upperdir)   //get the upper root inode lock
>   ->ovl_set_redirect()
>     ->ovl_set_feature_redirect_dir()
>       ->vfs_setxattr(upperdir)  //dead lock in inode_lock()
>

Very well, so you can move ovl_set_redirect before lock_rename()

I'm pretty sure that vivek already posted a patch like this in one of the
revisions of metacopy, but dropped it because it wasn't a must.

Thanks,
Amir.

--00000000000082da2205728de95c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">=
On Fri, Aug 3, 2018, 1:52 PM zhangyi (F) &lt;<a href=3D"mailto:yi.zhang@hua=
wei.com">yi.zhang@huawei.com</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">On 2018/8/1 19:03, Amir Goldstein Wrote:<br>
&gt; On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) &lt;<a href=3D"mailto:yi=
.zhang@huawei.com" target=3D"_blank" rel=3D"noreferrer">yi.zhang@huawei.com=
</a>&gt; wrote:<br>
&gt;&gt; Redirect dir feature is backward incompatible because old kernel (=
which<br>
&gt;&gt; not support this feature) may corrupt the merge relationship betwe=
en<br>
&gt;&gt; directories when change the directory which have redirect xattr.<b=
r>
&gt;&gt;<br>
&gt;&gt; This patch check and set the upper layer&#39;s redirect dir featur=
e when<br>
&gt;&gt; kernel set redirect xattr to directory in the upper layer.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: zhangyi (F) &lt;<a href=3D"mailto:yi.zhang@huawei.c=
om" target=3D"_blank" rel=3D"noreferrer">yi.zhang@huawei.com</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt;=C2=A0 fs/overlayfs/dir.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 11 ++++++++++=
+<br>
&gt;&gt;=C2=A0 fs/overlayfs/overlayfs.h |=C2=A0 5 ++++-<br>
&gt;&gt;=C2=A0 2 files changed, 15 insertions(+), 1 deletion(-)<br>
&gt;&gt;<br>
&gt;&gt; diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c<br>
&gt;&gt; index f480b1a2cd2e..238999e5f47b 100644<br>
&gt;&gt; --- a/fs/overlayfs/dir.c<br>
&gt;&gt; +++ b/fs/overlayfs/dir.c<br>
&gt;&gt; @@ -969,6 +969,7 @@ static int ovl_rename(struct inode *olddir, st=
ruct dentry *old,<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool is_dir =3D d_is_dir(old);<br=
>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool new_is_dir =3D d_is_dir(new)=
;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool samedir =3D olddir =3D=3D ne=
wdir;<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct ovl_fs* ofs =3D old-&gt;d_sb-&g=
t;s_fs_info;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dentry *opaquedir =3D NULL=
;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct cred *old_cred =3D N=
ULL;<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(list);<br>
&gt;&gt; @@ -1061,6 +1062,16 @@ static int ovl_rename(struct inode *olddir,=
 struct dentry *old,<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;&gt;<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((is_dir &amp;&amp; ovl_type_merge_=
or_lower(old)) ||<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!overwrite &amp;&amp; n=
ew_is_dir &amp;&amp; ovl_type_merge_or_lower(new))) {<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Set red=
irect dir feature to the upper root dir if this<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * feature=
 doesn&#39;t exist.<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ovl_h=
as_feature_redirect_dir(ofs-&gt;upper_layer))<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0err =3D ovl_set_feature_redirect_dir(ofs);<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;&gt; +<br>
&gt; <br>
&gt; Please just place a call to=C2=A0 ovl_set_feature_redirect_dir(ofs)<br=
>
&gt; inside ovl_set_redirect(). There is no need to check all those<br>
&gt; conditions.<br>
&gt; Also, there is no need to check ovl_has_feature_redirect_dir()<br>
&gt; as ovl_set_feature() already checks for existing bit.<br>
&gt;<br>
<br>
I understand check those condition is not perfect, but place it<br>
to ovl_set_redirect() will lead to inode AA dead lock if the<br>
parent dir of the renamed dir is the upper root dir, because<br>
lock_rename() and vfs_setxattr() will get the same inode lock.<br>
<br>
ovl_rename()<br>
=C2=A0 -&gt;lock_rename(upperdir)=C2=A0 =C2=A0//get the upper root inode lo=
ck<br>
=C2=A0 -&gt;ovl_set_redirect()<br>
=C2=A0 =C2=A0 -&gt;ovl_set_feature_redirect_dir()<br>
=C2=A0 =C2=A0 =C2=A0 -&gt;vfs_setxattr(upperdir)=C2=A0 //dead lock in inode=
_lock()<br></blockquote></div></div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Very well, so you can move ovl_set_redirect before lock_rename()</di=
v><div dir=3D"auto"><br></div><div dir=3D"auto">I&#39;m pretty sure that vi=
vek already posted a patch like this in one of the revisions of metacopy, b=
ut dropped it because it wasn&#39;t a must.</div><div dir=3D"auto"><br></di=
v><div dir=3D"auto">Thanks,</div><div dir=3D"auto">Amir.</div></div>

--00000000000082da2205728de95c--
