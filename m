From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Tue, 7 May 2019 04:07:21 -0400
Message-ID: <CAJfpegv-0mUs=XRgerxR_Zz_MvYuDvb95v0QZeBUcHNnenusnw@mail.gmail.com>
References: <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com>
 <20161205162559.GB17517@fieldses.org> <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com>
 <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de> <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com>
 <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
 <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
 <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com>
 <20161206185806.GC31197@fieldses.org> <87bm0l4nra.fsf@notabene.neil.brown.name>
 <20190503153531.GJ12608@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190503153531.GJ12608@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>, =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, May 3, 2019 at 11:35 AM J. Bruce Fields <bfields@fieldses.org> wrote:
>
> On Thu, May 02, 2019 at 12:02:33PM +1000, NeilBrown wrote:

> >  Silently not copying the ACLs is probably not a good idea as it might
> >  result in inappropriate permissions being given away.  So if the
> >  sysadmin wants this (and some clearly do), they need a way to
> >  explicitly say "I accept the risk".
>
> So, I feel like silently copying ACLs up *also* carries a risk, if that
> means switching from server-enforcement to client-enforcement of those
> permissions.

That's not correct: permissions are checked on the overlay layer,
regardless of where the actual file resides.  For filesystems using a
server enforced permission model that means possibly different
permissions for accesses through overlayfs than for accesses without
overlayfs.  Apparently this is missing from the documentation and
definitely needs to be added.

So I think it's perfectly fine to allow copying up ACLs, as long as
the ACL is representable on the upper fs.  If that cannot be ensured,
then the only sane thing to do is to disable ACL checking across the
overlay ("noacl" option).

Thanks,
Miklos
