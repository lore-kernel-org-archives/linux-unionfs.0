Return-Path: <charleszheng44@gmail.com>
MIME-Version: 1.0
Sender: charleszheng44@gmail.com
In-Reply-To: <CAJfpegvXnyUeLJEDSJwnQ_mL6okjqin=E6fw_Wj=aezyNgiwNw@mail.gmail.com>
References: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
 <CAOQ4uxhxU0PYe=aV2OR5UpU_fDTAWe6ex1m_oq0nCq8OGK-eJQ@mail.gmail.com>
 <CAAeanMzpzsNVxCaOHp=0t=5dcQG7BcOUbogZ_t1T3cDTZTzQ1A@mail.gmail.com>
 <CAOQ4uxgep4MRSCgauT79UsEVHZ0A_reOOyAvh4n3viW2LLS14A@mail.gmail.com> <CAJfpegvXnyUeLJEDSJwnQ_mL6okjqin=E6fw_Wj=aezyNgiwNw@mail.gmail.com>
From: charles zheng <czheng2@nd.edu>
Date: Mon, 30 Oct 2017 11:43:48 -0400
Message-ID: <CAAeanMxM5t3s+5v5iNWy4NmN9A_L-YC72Lmz+jLjBx13Vf9LZA@mail.gmail.com>
Subject: Re: [OVERLAYFS] Can I create file in directory on lower layer located
 on NFS
Content-Type: multipart/alternative; boundary="94eb2c0c38582b71fd055cc5810c"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, dimitrios.skourtis@ibm.com, mmohamed@us.ibm.com, aswarke@us.ibm.com
List-ID: <linux-unionfs@vger.kernel.org>

--94eb2c0c38582b71fd055cc5810c
Content-Type: text/plain; charset="UTF-8"

Hello Amir and Miklos,

I tried NFSv4 with noacl option, and I still got "operation not support". I
also tried NFSv3, and it works as expect. Hope this information is useful
to you.

Best,
Charles

On Tue, Oct 17, 2017 at 3:11 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Tue, Oct 17, 2017 at 7:37 AM, Amir Goldstein <amir73il@gmail.com>
> wrote:
> > Since the error happens on such as old kernel as well as a new one, I
> suspect
> > copy up fails on copying extended attributes of lower_dir.
> > I suspect there are some NFS related xattr on lower dir?
> > and perhaps those cannot be set on your upper fs?
> > You did not reveal in mountinfo snippet what you local upper fs is
> > and what mount options it uses.
> >
> > Please try to check if lower dir contains any xattr and
> > if your upper fs supports xattr.
>
> Yes, there's an NFSv4 related splat because overlayfs can't copy up
> "system.nfs4_acl" xattr.  The weird but apparently unfixable fact is
> that this attribute is there even if the nfs4-acl is equivalent to the
> DAC bits (i.e. the common case).
>
> If you don't want to use NFS acls, then just turn them off with
> "noacl" mount option on the NFS mount and things should work.
>
> Thanks,
> Miklos
>

--94eb2c0c38582b71fd055cc5810c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">Hel=
lo Amir and Miklos,</div><div class=3D"gmail_default" style=3D"font-size:sm=
all"><br></div><div class=3D"gmail_default" style=3D"font-size:small">I tri=
ed NFSv4 with noacl option, and I still got &quot;operation not support&quo=
t;. I also tried NFSv3, and it works as expect. Hope this information is us=
eful to you.</div><div class=3D"gmail_default" style=3D"font-size:small"><b=
r></div><div class=3D"gmail_default" style=3D"font-size:small">Best,</div><=
div class=3D"gmail_default" style=3D"font-size:small">Charles=C2=A0=C2=A0</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue,=
 Oct 17, 2017 at 3:11 AM, Miklos Szeredi <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:miklos@szeredi.hu" target=3D"_blank">miklos@szeredi.hu</a>&gt;</span>=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, Oct 17, =
2017 at 7:37 AM, Amir Goldstein &lt;<a href=3D"mailto:amir73il@gmail.com">a=
mir73il@gmail.com</a>&gt; wrote:<br>
&gt; Since the error happens on such as old kernel as well as a new one, I =
suspect<br>
&gt; copy up fails on copying extended attributes of lower_dir.<br>
&gt; I suspect there are some NFS related xattr on lower dir?<br>
&gt; and perhaps those cannot be set on your upper fs?<br>
&gt; You did not reveal in mountinfo snippet what you local upper fs is<br>
&gt; and what mount options it uses.<br>
&gt;<br>
&gt; Please try to check if lower dir contains any xattr and<br>
&gt; if your upper fs supports xattr.<br>
<br>
</span>Yes, there&#39;s an NFSv4 related splat because overlayfs can&#39;t =
copy up<br>
&quot;system.nfs4_acl&quot; xattr.=C2=A0 The weird but apparently unfixable=
 fact is<br>
that this attribute is there even if the nfs4-acl is equivalent to the<br>
DAC bits (i.e. the common case).<br>
<br>
If you don&#39;t want to use NFS acls, then just turn them off with<br>
&quot;noacl&quot; mount option on the NFS mount and things should work.<br>
<br>
Thanks,<br>
Miklos<br>
</blockquote></div><br></div>

--94eb2c0c38582b71fd055cc5810c--
