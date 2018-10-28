Return-Path: <russell@personaltelco.net>
MIME-Version: 1.0
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <CAOQ4uxii0rZv3SVXWNN7yug_WZ-TKLL3Wo-mti0y9K66Z+-EcQ@mail.gmail.com>
 <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com> <6556017.quyC1DpDMg@blindfold>
In-Reply-To: <6556017.quyC1DpDMg@blindfold>
From: Russell Senior <russell@personaltelco.net>
Date: Sun, 28 Oct 2018 00:09:06 -0700
Message-ID: <CAHP3WfPnvruq49JSKVEFTf1jA1e60ZkZBvi6NkaNi3vgVmO82g@mail.gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Content-Type: multipart/alternative; boundary="00000000000087c50c057944a15d"
To: richard@nod.at
Cc: zajec5@gmail.com, amir73il@gmail.com, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind1@gmail.com, adrian.hunter@intel.com, linux-mtd@lists.infradead.org, openwrt-devel@lists.openwrt.org
List-ID: <linux-unionfs@vger.kernel.org>

--00000000000087c50c057944a15d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2018 at 12:33 PM Richard Weinberger <richard@nod.at> wrote:

> Rafa=C5=82,
>
> Am Montag, 22. Oktober 2018, 17:34:44 CEST schrieb Rafa=C5=82 Mi=C5=82eck=
i:
> > Then I took a close look at ovl_copy_up_locked() and it seems above
> > info isn't accurate. It seems to me that setxattr() happens between
> > fsync and link. I modified my C app to follow that order (open, write,
> > fsync, setxattr, link) and I can reproduce the problem now!
> >
> > Steps to reproduce the problem:
> > 1) compile tmptest.c
> > 2) tmptest /overlay/upper/foo.txt user.bar baz
> > 3) wait 5 seconds (so ubifs writes to flash)
> > 4) power cut
> > 5) boot again and check content of /overlay/upper/foo.txt
> > 6) in my case content appears to be 00 00 00 00
>
> Just returned from Edinburgh and had a chance to look at the problem.
> The problem is not that no write-back happens, in fact it happens just
> fine.
> But we have a problem upon journal replay if an unlinked file (O_TMPFILE)
> gets relinked in combination with xattrs.
>
> Can you please give the attached patch a try? It is not perfect but if I
> understand the problem correctly it should fix the issues you're facing.
>

Your patch seems to have fixed it for me, sample size =3D 1.

--=20
Russell Senior
russell@personaltelco.net

--00000000000087c50c057944a15d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Sat=
, Oct 27, 2018 at 12:33 PM Richard Weinberger &lt;<a href=3D"mailto:richard=
@nod.at">richard@nod.at</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">Rafa=C5=82,<br>
<br>
Am Montag, 22. Oktober 2018, 17:34:44 CEST schrieb Rafa=C5=82 Mi=C5=82ecki:=
<br>
&gt; Then I took a close look at ovl_copy_up_locked() and it seems above<br=
>
&gt; info isn&#39;t accurate. It seems to me that setxattr() happens betwee=
n<br>
&gt; fsync and link. I modified my C app to follow that order (open, write,=
<br>
&gt; fsync, setxattr, link) and I can reproduce the problem now!<br>
&gt; <br>
&gt; Steps to reproduce the problem:<br>
&gt; 1) compile tmptest.c<br>
&gt; 2) tmptest /overlay/upper/foo.txt user.bar baz<br>
&gt; 3) wait 5 seconds (so ubifs writes to flash)<br>
&gt; 4) power cut<br>
&gt; 5) boot again and check content of /overlay/upper/foo.txt<br>
&gt; 6) in my case content appears to be 00 00 00 00<br>
<br>
Just returned from Edinburgh and had a chance to look at the problem.<br>
The problem is not that no write-back happens, in fact it happens just fine=
.<br>
But we have a problem upon journal replay if an unlinked file (O_TMPFILE)<b=
r>
gets relinked in combination with xattrs.<br>
<br>
Can you please give the attached patch a try? It is not perfect but if I <b=
r>
understand the problem correctly it should fix the issues you&#39;re facing=
.<br></blockquote><div><br></div><div>Your patch seems to have fixed it for=
 me, sample size =3D 1.</div><div>=C2=A0</div>-- <br></div><div class=3D"gm=
ail_quote">Russell Senior</div><div class=3D"gmail_quote"><a href=3D"mailto=
:russell@personaltelco.net">russell@personaltelco.net</a><br></div></div>

--00000000000087c50c057944a15d--
