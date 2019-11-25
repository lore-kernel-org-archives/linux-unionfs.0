Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191117154349.28695-1-amir73il@gmail.com> <CAOQ4uxjMbNVf9-1YjUpDzyaM_aV7OD0hi4m_AMbUvH3vUVn4sQ@mail.gmail.com>
 <CAOQ4uxjMsv2vE5Nn5D8TNCFxaz8b4duyOLOiPpy4qd1bs3bdwQ@mail.gmail.com> <CAOQ4uxi5QoV-WyY2rXhGpFoOfvcKh0Pm0tfU1vPvyk+rj0zCNQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi5QoV-WyY2rXhGpFoOfvcKh0Pm0tfU1vPvyk+rj0zCNQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Nov 2019 16:45:21 +0200
Message-ID: <CAOQ4uxi_p8u4=0xZuwY=ieU=6Lgj=D4fibGfHX1kWCcVqPkRaw@mail.gmail.com>
Subject: Re: [PATCH 0/6] Sort out overlay layers and fs arrays
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Nov 22, 2019 at 11:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > I was also considering setting xino=on by default if xino_auto
> > > > is enabled, because what have we got to loose?
> > > >
> > > > The inodes whose st_ino fit in lower bits (by far more common) will
> > > > use overlay st_dev and the inodes whose st_ino overflow the lower bits
> > > > will use pseudo_dev. Seems like a win-win situation, but I wanted to
> > > > get your feedback on this before sending out a patch.
> > > >
> > >
> > > Arrr.. yes, there is a catch.
> > > Overflowing lower bits has a price beyond just using pseudo_dev.
> > > It introduces the possibility of inode number conflicts on directories,
> > > because directories never use pseudo_dev.
> > >
> >
> > But we could mitigate that problem if we reserve an fsid for volatile
> > directory inode numbers. get_next_ino is 32bit anyway.
> > I am going to take a swing at having xino=auto always enabling xino.
> >
>
> FWIW, pushed WIP branch to:
> https://github.com/amir73il/linux/commits/ovl-ino
>
> It is based on an updated ovl-layers branch of the $SUBJECT series.
>
> During cleanup, I've found several corner cases bugs of setting
> i_ino value and fixed them.
> None of those bugs are critical.
> AFAIK, the only user that complained on inconsistent i_ino is
> an xfstest that is checking ino in /proc/locks.
>
> However, I do think that the cleanup I made simplifies the code
> which was a bit spaghetti in that area and with some more TLC
> we can get to enabling xino from xino=auto even for filesystems
> that have seldom high ino bits.
>
> That could be a real benefit, because it is unlikely that users
> will have enough knowledge or certainty about underlying fs
> to declare xino=on.
>
> I need to clear up some time to test i_ino changes and
> the collision avoidance code, but for now, at least the ovl-ino branch
> passes the existing regression tests.
>

Documenting all this in words has become too complex for me,
so I resorted to visual aids [1].

The table doesn't mention this explicitly, but xino=auto can now
(code in ovl-ino) provide all desired features for any non-samefs setup.

Tests are still WIP. Will post the work when they are done.
I am using a nested overlay [2] as a way to test xino overflow behavior.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/blob/ovl-ino/Documentation/filesystems/overlayfs.rst#inode-properties
[2] https://github.com/amir73il/unionmount-testsuite/commits/ovl-nested
