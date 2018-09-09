From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs @ Containers and checkpoint/restart micro-conference at LPC2018
Date: Sun, 9 Sep 2018 09:31:02 +0300
Message-ID: <CAOQ4uxih7rPPLquJZFL9HtSbUFi-cCOR21qH4_-ORxxLKGsLXg@mail.gmail.com>
References: <20180813161015.GD18492@castiana> <20180908045935.GA9201@castiana>
 <CAOQ4uxiQEpofdS97kxnii8LtVW2QiKAGvjjaH0Px-Bj3eHVCFA@mail.gmail.com> <20180909013108.6wjlx75ztqjipepg@mailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180909013108.6wjlx75ztqjipepg@mailbox.org>
Sender: netdev-owner@vger.kernel.org
To: christian@brauner.io
Cc: Stephane Graber <stgraber@ubuntu.com>, containers@lists.linuxfoundation.org, Miklos Szeredi <miklos@szeredi.hu>, Netdev <netdev@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, lxc-users@lists.linuxcontainers.org, LSM List <linux-security-module@vger.kernel.org>, lxc-devel@lists.linuxcontainers.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Sep 9, 2018 at 4:31 AM Christian Brauner <christian@brauner.io> wro=
te:
>
...
> > [cc: overlayfs developers]
> >
> > Hi St=C3=A9phane!
>
> Hey Amir,
>
> I'm one of the co-organizers of the microconf.
>
> >
> > I am not planing to travel to LPC this year, so this is more of an FYI =
than
> > a CFP, but maybe another overlayfs developer can pick up this glove??
>
> Sure, that would be great.
>
> >
> > For the past two years I have participated in the effort to fix overlay=
fs
> > "non-standard" behavior:
> > https://github.com/amir73il/overlayfs/wiki/Overlayfs-non-standard-behav=
ior
>
> Yes, this is an issue that we were aware of for a long time and it
> something that has made overlayfs somewhat more difficult to use than it
> should be.
>
> >
> > Allegedly, this effort went underway to improve the experience of overl=
ayfs
> > users, who are mostly applications running inside containers. For backw=
ard
> > compatibility reasons, container runtimes will need to opt-in for fixin=
g some
> > of the legacy behavior.
> >
> > In reality, I have seen very little cross list interaction between linu=
x-unionfs
> > and containers mailing lists. The only interaction I recall in the
> > past two years
> > ended up in a fix in overlayfs to require opt-in for fixing yet another=
 backward
> > compatible bad behavior, although docker did follow up shortly after to=
 fix
> > bad practice in container runtime:
> > https://github.com/moby/moby/issues/34672
> >
> > So the questions I would like to relay to the micro-conf participants w=
.r.t the
> > new opt-in overlayfs behavior:
> > 1. Did you know?
>
> I personally did not know about the new opt-in behavior. More reason to
> give a talk! :)
>
> > 2. Do you care?
>
> Yes, we do care. However - speaking as LXC upstream now - we have
> recently focused on getting shiftfs to work rather than overlayfs.
>

IMO, as I expressed it in the past, the fact that shiftfs development is no=
t
collaborated with overlayfs developers is a pitty.
Yes shiftfs has a different purpose than overlayfs, but they have common
use cases and common problems as well.

> We are more than happy to have a overlayfs talk at the microconf. If
> someone were to talk about:
> - What non-standard behavior has already been fixed?
> - How has it been fixed?

IMO, those questions are covered quite well by the wiki and overlayfs.txt
documentation in kernel tree.

> - What non-standard behavior still needs to be fixed?

There's the mmap MAP_SHARED case covered in the wiki
and there may be other small stuff, but not sure if anyone cares
about them, so the question should really be directed back to the audience.=
..

> - Outstanding problems that either still need a solution or
>   are solved but one would like feedback on the implementation. This way
>   we can have a good discussion.
>

I think one of the chsallange that distros and container runtime will need =
to
deal with is managing format versions of overlay "images".
The reason the new features require user or distro to opt-in is because
the new features create overlayfs images that are not fully compatible with=
 old
kernels and existing container image tools (i.e. export/migrate image).

The new overlayfs-progs project by Zhangyi is going to help in that respect=
:
https://github.com/hisilicon/overlayfs-progs
As well as Zhangyi's work on overlayfs feature set support:
https://marc.info/?l=3Dlinux-unionfs&m=3D153302911328159&w=3D2

Thanks,
Amir.
