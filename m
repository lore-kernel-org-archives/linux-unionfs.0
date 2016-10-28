Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20161028125457.GA8412@veci.piliscsaba.szeredi.hu>
References: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
 <1477506616-14061-1-git-send-email-amir73il@gmail.com> <20161027223742.GC4819@redhat.com>
 <CAOQ4uxiSf+9u0P1s5--uj19ubrJYrUWH_WM2FPbpvH9yApoZyQ@mail.gmail.com> <20161028125457.GA8412@veci.piliscsaba.szeredi.hu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Oct 2016 18:08:34 +0300
Message-ID: <CAOQ4uxjRFi+u-MiY9mBheU1TaqdJpaDYJ7Riwb7Hsobm1riX2A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: update S_ISGID when setting posix ACLs
Content-Type: multipart/alternative; boundary=089e014943226e6fd8053fee3b9f
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

--089e014943226e6fd8053fee3b9f
Content-Type: text/plain; charset=UTF-8

On Oct 28, 2016 3:55 PM, "Miklos Szeredi" <miklos@szeredi.hu> wrote:
>
> On Fri, Oct 28, 2016 at 07:47:12AM +0300, Amir Goldstein wrote:
> > On Fri, Oct 28, 2016 at 1:37 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Wed, Oct 26, 2016 at 09:30:16PM +0300, Amir Goldstein wrote:
> > >> Since operations on upper are performed using mounter's credentials,
> > >> we need to call posix_acl_update_mode() with current credentials on
> > >> overlay inode to possibly copy-up and clear setgid bit, before
setting
> > >> posix ACLs on upper inode.
> > >>
> > >> Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX_ACL to
> > >> avoid compiler warning for implicit declaration of function
> > >> 'posix_acl_update_mode' on build without that config option.
> > >>
> > >> This change fixes xfstest generic/375, which failed to clear the
> > >> setgid bit in the following test case over overlayfs:
> > >>
> > >>   touch $testfile
> > >>   chown 100:100 $testfile
> > >>   chmod 2755 $testfile
> > >>   _runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx $testfile
>
> Instead of calculating and setting the equivalent mode in overlayfs code
(as
> well as in the upper layer later), how about just clearing the sgid bit
when
> necessary?

That looks reasonable.
I'll be able to test tomorrow.

> Untested patch follows.
>
> Thanks,
> Miklos
>
> ---
>  fs/overlayfs/super.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -562,6 +562,21 @@ ovl_posix_acl_xattr_set(const struct xat
>
>         posix_acl_release(acl);
>
> +       /*
> +        * Check if sgid bit needs to be cleared (actual setacl operation
will
> +        * be done with mounter's capabilities and so that won't do it
for us).
> +        */
> +       if (unlikely(inode->i_mode & S_ISGID) &&
> +           handler->flags == ACL_TYPE_ACCESS &&
> +           !in_group_p(inode->i_gid) &&
> +           !capable_wrt_inode_uidgid(inode, CAP_FSETID)) {
> +               struct iattr iattr = { .ia_valid = ATTR_KILL_SGID };
> +
> +               err = ovl_setattr(dentry, &iattr);
> +               if (err)
> +                       return err;
> +       }
> +
>         err = ovl_xattr_set(dentry, handler->name, value, size, flags);
>         if (!err)
>                 ovl_copyattr(ovl_inode_real(inode, NULL), inode);

--089e014943226e6fd8053fee3b9f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"></p>
<p dir=3D"ltr">On Oct 28, 2016 3:55 PM, &quot;Miklos Szeredi&quot; &lt;<a h=
ref=3D"mailto:miklos@szeredi.hu">miklos@szeredi.hu</a>&gt; wrote:<br>
&gt;<br>
&gt; On Fri, Oct 28, 2016 at 07:47:12AM +0300, Amir Goldstein wrote:<br>
&gt; &gt; On Fri, Oct 28, 2016 at 1:37 AM, Vivek Goyal &lt;<a href=3D"mailt=
o:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; wrote:<br>
&gt; &gt; &gt; On Wed, Oct 26, 2016 at 09:30:16PM +0300, Amir Goldstein wro=
te:<br>
&gt; &gt; &gt;&gt; Since operations on upper are performed using mounter&#3=
9;s credentials,<br>
&gt; &gt; &gt;&gt; we need to call posix_acl_update_mode() with current cre=
dentials on<br>
&gt; &gt; &gt;&gt; overlay inode to possibly copy-up and clear setgid bit, =
before setting<br>
&gt; &gt; &gt;&gt; posix ACLs on upper inode.<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX=
_ACL to<br>
&gt; &gt; &gt;&gt; avoid compiler warning for implicit declaration of funct=
ion<br>
&gt; &gt; &gt;&gt; &#39;posix_acl_update_mode&#39; on build without that co=
nfig option.<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; This change fixes xfstest generic/375, which failed to c=
lear the<br>
&gt; &gt; &gt;&gt; setgid bit in the following test case over overlayfs:<br=
>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt;=C2=A0 =C2=A0touch $testfile<br>
&gt; &gt; &gt;&gt;=C2=A0 =C2=A0chown 100:100 $testfile<br>
&gt; &gt; &gt;&gt;=C2=A0 =C2=A0chmod 2755 $testfile<br>
&gt; &gt; &gt;&gt;=C2=A0 =C2=A0_runas -u 100 -g 101 -- setfacl -m u::rwx,g:=
:rwx,o::rwx $testfile<br>
&gt;<br>
&gt; Instead of calculating and setting the equivalent mode in overlayfs co=
de (as<br>
&gt; well as in the upper layer later), how about just clearing the sgid bi=
t when<br>
&gt; necessary?</p>
<p dir=3D"ltr">That looks reasonable.<br>
I&#39;ll be able to test tomorrow.</p>
<p dir=3D"ltr">&gt; Untested patch follows.<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Miklos<br>
&gt;<br>
&gt; ---<br>
&gt; =C2=A0fs/overlayfs/super.c |=C2=A0 =C2=A015 +++++++++++++++<br>
&gt; =C2=A01 file changed, 15 insertions(+)<br>
&gt;<br>
&gt; --- a/fs/overlayfs/super.c<br>
&gt; +++ b/fs/overlayfs/super.c<br>
&gt; @@ -562,6 +562,21 @@ ovl_posix_acl_xattr_set(const struct xat<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 posix_acl_release(acl);<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Check if sgid bit needs to be cleared (=
actual setacl operation will<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * be done with mounter&#39;s capabilities=
 and so that won&#39;t do it for us).<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(inode-&gt;i_mode &amp; S_ISGI=
D) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0handler-&gt;flags =3D=3D ACL=
_TYPE_ACCESS &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!in_group_p(inode-&gt;i_gid)=
 &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!capable_wrt_inode_uidgid(in=
ode, CAP_FSETID)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iattr i=
attr =3D { .ia_valid =3D ATTR_KILL_SGID };<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ovl_se=
tattr(dentry, &amp;iattr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return err;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D ovl_xattr_set(dentry, handler-&gt;=
name, value, size, flags);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!err)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ovl_copyattr(o=
vl_inode_real(inode, NULL), inode);<br></p>

--089e014943226e6fd8053fee3b9f--
