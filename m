Return-Path: <maciekz82@gmail.com>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org> <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org> <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
 <CAOQ4uxjsfgfo3rXtFKQk4A_fU2tvo38GFhzz7H9h1+R4trjd6Q@mail.gmail.com>
 <CAJfpeguV6Dwkm-CJieHKZWYK=uw3BYx9nW17KAs8uNJptmnchA@mail.gmail.com>
 <CACTyJpCx7y-5OOhk0P8ETQwp4_n-a1W1Dmc-1dHeE6j_cvdk7A@mail.gmail.com> <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com>
From: =?UTF-8?Q?Maciej_Zi=C4=99ba?= <maciekz82@gmail.com>
Date: Wed, 14 Nov 2018 22:33:50 +0100
Message-ID: <CACTyJpBpmTz-ZiRG23rEh4tASmd2uPyzY8SQsbM1FE+5dAdJ_A@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: multipart/alternative; boundary="0000000000009254b5057aa6b0b2"
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, vgoyal@redhat.com, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, salyzyn@android.com
List-ID: <linux-unionfs@vger.kernel.org>

--0000000000009254b5057aa6b0b2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi :)

It took me a while to compile the kernel but I can confirm that this patch
fixes the problem.

Best regards,
Maciej

=C5=9Br., 14 lis 2018 o 13:09 Amir Goldstein <amir73il@gmail.com> napisa=C5=
=82(a):

> On Wed, Nov 14, 2018 at 12:28 PM Maciej Zi=C4=99ba <maciekz82@gmail.com> =
wrote:
> >
> > Hi :)
> >
> > I'm not sure which part is relevant, so I'm sending the entire dmesg
> output as well as the docker messages. I hope it will be useful.
> >
>
> Thanks for the info!
>
> Problem is ovl_set_redirect() inside ovl_link() is missing
> ovl_override_creds().
>
> Can you try the patch below?
>
> Reason that unionmount-testsuite didn't catch this is because
> it is run as root.
>
> Vivek, Mark,
>
> Either of you care to implement dropping privileges for the duration
> of unionmount-testsuite test cases (in between mounts and unmounts)?
>
> Thanks,
> Amir.
>
> ---
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index c6289147c787..82c129bfe58d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct
> dentry *dentry,
>         return ovl_create_object(dentry, S_IFLNK, 0, link);
>  }
>
> +static int ovl_set_link_redirect(struct dentry *dentry)
> +{
> +       const struct cred *old_cred;
> +       int err;
> +
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +       err =3D ovl_set_redirect(dentry, false);
> +       revert_creds(old_cred);
> +
> +       return err;
> +}
> +
>  static int ovl_link(struct dentry *old, struct inode *newdir,
>                     struct dentry *new)
>  {
> @@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct
> inode *newdir,
>                 goto out_drop_write;
>
>         if (ovl_is_metacopy_dentry(old)) {
> -               err =3D ovl_set_redirect(old, false);
> +               err =3D ovl_set_link_redirect(old);
>                 if (err)
>                         goto out_drop_write;
>         }
>

--0000000000009254b5057aa6b0b2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi :)<div><br></div><div>It took me a while to compile the=
 kernel but I can confirm that this patch fixes the problem.</div><div><br>=
</div><div>Best regards,</div><div>Maciej</div></div><br><div class=3D"gmai=
l_quote"><div dir=3D"ltr">=C5=9Br., 14 lis 2018 o 13:09=C2=A0Amir Goldstein=
 &lt;<a href=3D"mailto:amir73il@gmail.com">amir73il@gmail.com</a>&gt; napis=
a=C5=82(a):<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, Nov 14, 2018 at=
 12:28 PM Maciej Zi=C4=99ba &lt;<a href=3D"mailto:maciekz82@gmail.com" targ=
et=3D"_blank">maciekz82@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi :)<br>
&gt;<br>
&gt; I&#39;m not sure which part is relevant, so I&#39;m sending the entire=
 dmesg output as well as the docker messages. I hope it will be useful.<br>
&gt;<br>
<br>
Thanks for the info!<br>
<br>
Problem is ovl_set_redirect() inside ovl_link() is missing<br>
ovl_override_creds().<br>
<br>
Can you try the patch below?<br>
<br>
Reason that unionmount-testsuite didn&#39;t catch this is because<br>
it is run as root.<br>
<br>
Vivek, Mark,<br>
<br>
Either of you care to implement dropping privileges for the duration<br>
of unionmount-testsuite test cases (in between mounts and unmounts)?<br>
<br>
Thanks,<br>
Amir.<br>
<br>
---<br>
<br>
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c<br>
index c6289147c787..82c129bfe58d 100644<br>
--- a/fs/overlayfs/dir.c<br>
+++ b/fs/overlayfs/dir.c<br>
@@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct<br>
dentry *dentry,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ovl_create_object(dentry, S_IFLNK, 0, li=
nk);<br>
=C2=A0}<br>
<br>
+static int ovl_set_link_redirect(struct dentry *dentry)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct cred *old_cred;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int err;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0old_cred =3D ovl_override_creds(dentry-&gt;d_sb=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_set_redirect(dentry, false);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0revert_creds(old_cred);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return err;<br>
+}<br>
+<br>
=C2=A0static int ovl_link(struct dentry *old, struct inode *newdir,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struc=
t dentry *new)<br>
=C2=A0{<br>
@@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct<br>
inode *newdir,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_drop_write=
;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ovl_is_metacopy_dentry(old)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_set_red=
irect(old, false);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_set_lin=
k_redirect(old);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out_drop_write;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
</blockquote></div>

--0000000000009254b5057aa6b0b2--
