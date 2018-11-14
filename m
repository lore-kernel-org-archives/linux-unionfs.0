Return-Path: <maciekz82@gmail.com>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org> <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org> <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
 <CAOQ4uxjsfgfo3rXtFKQk4A_fU2tvo38GFhzz7H9h1+R4trjd6Q@mail.gmail.com>
 <CAJfpeguV6Dwkm-CJieHKZWYK=uw3BYx9nW17KAs8uNJptmnchA@mail.gmail.com>
 <CACTyJpCx7y-5OOhk0P8ETQwp4_n-a1W1Dmc-1dHeE6j_cvdk7A@mail.gmail.com>
 <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com> <20181114142541.GB29804@redhat.com>
In-Reply-To: <20181114142541.GB29804@redhat.com>
From: =?UTF-8?Q?Maciej_Zi=C4=99ba?= <maciekz82@gmail.com>
Date: Wed, 14 Nov 2018 19:40:56 +0100
Message-ID: <CACTyJpDcL0_PHWeta8LAcsRsBPOoDJyzjUTSO_hC_7nyfjEq-A@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: multipart/alternative; boundary="000000000000368ca9057aa4466e"
To: vgoyal@redhat.com
Cc: Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, salyzyn@android.com
List-ID: <linux-unionfs@vger.kernel.org>

--000000000000368ca9057aa4466e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I've run docker build command as my user (belongs to "docker" group), as
root and using sudo but the error is always the same.

Regards,
Maciej


=C5=9Br., 14 lis 2018 o 15:25 Vivek Goyal <vgoyal@redhat.com> napisa=C5=82(=
a):

> On Wed, Nov 14, 2018 at 02:09:01PM +0200, Amir Goldstein wrote:
>
> [..]
> > Vivek, Mark,
> >
> > Either of you care to implement dropping privileges for the duration
> > of unionmount-testsuite test cases (in between mounts and unmounts)?
>
> Hi Amir,
>
> I think it will be good to drop priviliges while running
> unionmount-testsuite.
>
> BTW, docker build used to run as root/priviliged user. Is that not the ca=
se
> anymore? Why did it fail to begin with.
>
> Thanks
> Vivek
>
> >
> > Thanks,
> > Amir.
> >
> > ---
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index c6289147c787..82c129bfe58d 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct
> > dentry *dentry,
> >         return ovl_create_object(dentry, S_IFLNK, 0, link);
> >  }
> >
> > +static int ovl_set_link_redirect(struct dentry *dentry)
> > +{
> > +       const struct cred *old_cred;
> > +       int err;
> > +
> > +       old_cred =3D ovl_override_creds(dentry->d_sb);
> > +       err =3D ovl_set_redirect(dentry, false);
> > +       revert_creds(old_cred);
> > +
> > +       return err;
> > +}
> > +
> >  static int ovl_link(struct dentry *old, struct inode *newdir,
> >                     struct dentry *new)
> >  {
> > @@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct
> > inode *newdir,
> >                 goto out_drop_write;
> >
> >         if (ovl_is_metacopy_dentry(old)) {
> > -               err =3D ovl_set_redirect(old, false);
> > +               err =3D ovl_set_link_redirect(old);
> >                 if (err)
> >                         goto out_drop_write;
> >         }
>

--000000000000368ca9057aa4466e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I&#39;ve run docker build command a=
s my user (belongs to &quot;docker&quot; group), as root and using sudo but=
 the error is always the same.</div><div><br></div><div>Regards,</div><div>=
Maciej</div><div><br></div></div><br><div class=3D"gmail_quote"><div dir=3D=
"ltr">=C5=9Br., 14 lis 2018 o 15:25=C2=A0Vivek Goyal &lt;<a href=3D"mailto:=
vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; napisa=C5=82(a):<br></div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">On Wed, Nov 14, 2018 at 02:09:01PM +0200, Amir G=
oldstein wrote:<br>
<br>
[..]<br>
&gt; Vivek, Mark,<br>
&gt; <br>
&gt; Either of you care to implement dropping privileges for the duration<b=
r>
&gt; of unionmount-testsuite test cases (in between mounts and unmounts)?<b=
r>
<br>
Hi Amir,<br>
<br>
I think it will be good to drop priviliges while running<br>
unionmount-testsuite.<br>
<br>
BTW, docker build used to run as root/priviliged user. Is that not the case=
<br>
anymore? Why did it fail to begin with.<br>
<br>
Thanks<br>
Vivek<br>
<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Amir.<br>
&gt; <br>
&gt; ---<br>
&gt; <br>
&gt; diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c<br>
&gt; index c6289147c787..82c129bfe58d 100644<br>
&gt; --- a/fs/overlayfs/dir.c<br>
&gt; +++ b/fs/overlayfs/dir.c<br>
&gt; @@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct<=
br>
&gt; dentry *dentry,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ovl_create_object(dentry, S_IF=
LNK, 0, link);<br>
&gt;=C2=A0 }<br>
&gt; <br>
&gt; +static int ovl_set_link_redirect(struct dentry *dentry)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct cred *old_cred;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0int err;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0old_cred =3D ovl_override_creds(dentry-&gt=
;d_sb);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_set_redirect(dentry, false);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0revert_creds(old_cred);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return err;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 static int ovl_link(struct dentry *old, struct inode *newdir,<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0struct dentry *new)<br>
&gt;=C2=A0 {<br>
&gt; @@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct<br>
&gt; inode *newdir,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
drop_write;<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ovl_is_metacopy_dentry(old)) {<br=
>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_se=
t_redirect(old, false);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_se=
t_link_redirect(old);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0goto out_drop_write;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
</blockquote></div>

--000000000000368ca9057aa4466e--
