From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Thu, 2 May 2019 19:44:07 +0200
Message-ID: <CAHc6FU4czPQ8xxv5efvhkizU3obpV_05VEWYKydXDDDYcp8j=w@mail.gmail.com>
References: <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com>
 <20161205151933.GA17517@fieldses.org> <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com>
 <20161205162559.GB17517@fieldses.org> <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com>
 <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de> <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com>
 <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
 <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
 <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com>
 <20161206185806.GC31197@fieldses.org> <87bm0l4nra.fsf@notabene.neil.brown.name>
 <CAOQ4uxjYEjqbLcVYoUaPzp-jqY_3tpPBhO7cE7kbq63XrPRQLQ@mail.gmail.com>
 <875zqt4igg.fsf@notabene.neil.brown.name> <8f3ba729-ed44-7bed-5ff8-b962547e5582@math.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8f3ba729-ed44-7bed-5ff8-b962547e5582@math.utexas.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Goetz, Patrick G" <pgoetz@math.utexas.edu>
Cc: NeilBrown <neilb@suse.com>, Amir Goldstein <amir73il@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, 2 May 2019 at 19:27, Goetz, Patrick G <pgoetz@math.utexas.edu> wrote:
> On 5/1/19 10:57 PM, NeilBrown wrote:
> > Support some day support for nfs4 acls were added to ext4 (not a totally
> > ridiculous suggestion).  We would then want NFS to allow it's ACLs to be
> > copied up.
>
> Is there some reason why there hasn't been a greater effort to add NFSv4
> ACL support to the mainstream linux filesystems?  I have to support a
> hybrid linux/windows environment and not having these ACLs on ext4 is a
> daily headache for me.

The patches for implementing that have been rejected over and over
again, and nobody is working on them anymore.

Andreas
