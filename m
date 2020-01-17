Return-Path: <cpuguy83@gmail.com>
Return-Path: <cpuguy83@gmail.com>
Date: Fri, 17 Jan 2020 13:33:00 -0800
From: Brian Goff <cpuguy83@gmail.com>
Message-ID: <dejalu-217-910ea575-f51c-42ae-b89d-44387784c12f@gmail.com>
In-Reply-To: <20200117211940.GA22062@cisco>
References: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com>
 <20200104203946.27914-3-James.Bottomley@HansenPartnership.com>
 <20200113034149.GA27228@mail.hallyn.com>
 <1579112360.3249.17.camel@HansenPartnership.com>
 <20200116064430.GA32763@mail.hallyn.com>
 <1579192173.3551.38.camel@HansenPartnership.com>
 <20200117154402.GA16882@mail.hallyn.com>
 <1579278342.3227.36.camel@HansenPartnership.com>
 <20200117211940.GA22062@cisco>
Subject: Re: [PATCH v2 2/3] fs: introduce uid/gid shifting bind mount
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="5e22280c_59adea3d_1013a"
To: Tycho Andersen <tycho@tycho.ws>, James Bottomley <James.Bottomley@hansenpartnership.com>, Miklos Szeredi <miklos@szeredi.hu>, containers@lists.linux-foundation.org, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

--5e22280c_59adea3d_1013a
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

There are also cases where you=E2=80=99d want to bind-mount a host dir in=
to a shifted container and have that be writeable, not just to an overlay=
.

=E2=80=94

On January 17, 2020 at 1:19 PM, Tycho Andersen wrote:
> Please, no. mount() failures are already hard to reason about, I would
> rather not add another temporary (or worse, permanent) non-obvious
> failure mode.
>
> What if we make shifted bind mounts always readonly=3F That will force
> people to use an overlay (or something else) on top, but they probably
> want to do that anyway so they can avoid tainting the original
> container image with writes.
>
> It's not just the cool factor: if you're doing this, it's presumably
> because you want to use it with a container in a user namespace.
> Specifying the same parameters twice leaves room for error, causing
> CVEs and more work.
>
> Tycho
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> Containers mailing list
> Containers=40lists.linux-foundation.org (mailto:Containers=40lists.linu=
x-foundation.org)
> lists.linuxfoundation.org/mailman/listinfo/containers (https://lists.li=
nuxfoundation.org/mailman/listinfo/containers)
>
>
>
>


--5e22280c_59adea3d_1013a
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


            <div>
                <div>There are also cases where you=E2=80=99d want to bin=
d-mount a host dir into a shifted container and have that be writeable, n=
ot just to an overlay.</div><div><br></div><div><div><div>=E2=80=94</div>=
<div><br></div><div></div></div></div>
            </div>
            <div><br></div>
            <div style=3D=22color: =23aaa;=22>On January 17, 2020 at 1:19=
 PM, Tycho Andersen wrote:</div>
            <blockquote type=3D=22cite=22 style=3D=22border-left-color:=23=
ccc;border-left-style:solid;border-width:1px;margin-left:0px;padding-left=
:10px;=22>
                =20
                <div>
                <div><div><div><div>Please, no. mount() failures are alre=
ady hard to reason about, I would
</div><div>rather not add another temporary (or worse, permanent) non-obv=
ious
</div><div>failure mode.
</div><div><br></div><div>What if we make shifted bind mounts always read=
only=3F That will force
</div><div>people to use an overlay (or something else) on top, but they =
probably
</div><div>want to do that anyway so they can avoid tainting the original=

</div><div>container image with writes.
</div><div><br></div><div>It's not just the cool factor: if you're doing =
this, it's presumably
</div><div>because you want to use it with a container in a user namespac=
e.
</div><div>Specifying the same parameters twice leaves room for error, ca=
using
</div><div>CVEs and more work.
</div><div><br></div><div>Tycho
</div><div>=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F
</div><div>Containers mailing list
</div><div><a href=3D=22mailto:Containers=40lists.linux-foundation.org=22=
>Containers=40lists.linux-foundation.org</a>
</div><div><a href=3D=22https://lists.linuxfoundation.org/mailman/listinf=
o/containers=22>lists.linuxfoundation.org/mailman/listinfo/containers</a>=

</div></div></div></div></div>
            </blockquote>
        
--5e22280c_59adea3d_1013a--
