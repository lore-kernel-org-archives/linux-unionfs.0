From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH] OVL: add honoracl=off mount option.
Date: Thu, 02 May 2019 22:47:08 +0900
Message-ID: <2200.1556804828@jrobl>
References: <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com> <20161205151933.GA17517@fieldses.org> <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com> <20161205162559.GB17517@fieldses.org> <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com> <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de> <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com> <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com> <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com> <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com> <20161206185806.GC31197@fieldses.org> <87bm0l4nra.fsf@notabene.neil.brown.name> <8736lx4goa.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8736lx4goa.fsf@notabene.neil.brown.name>
Content-ID: <2199.1556804828.1@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

NeilBrown:
> If the upper and lower layers use incompatible ACL formats, it is not
> possible to copy the ACL xttr from one to the other, so overlayfs
> cannot work with them.
> This happens particularly with NFSv4 which uses system.nfs4_acl, and
> ext4 which uses system.posix_acl_access.

FYI,
Aufs had met the same problem many years ago, and I introduced some
options called ICEX (Ignore Copyup Error on Xattr).

(from the design doc in aufs)
----------------------------------------
For example, the src branch supports ACL but the dst branch doesn't
because the dst branch may natively un-support it or temporary
un-support it due to "noacl" mount option. Of course, the dst branch fs
may NOT return an error even if the XATTR is not supported. It is
totally up to the branch fs.

Anyway when the aufs internal copy-up gets an error from the dst branch
fs, then aufs tries removing the just copied entry and returns the error
to the userspace. The worst case of this situation will be all copy-up
will fail.

For the copy-up operation, there two basic approaches.
- copy the specified XATTR only (by category above), and return the
  error unconditionally if it happens.
- copy all XATTR, and ignore the error on the specified category only.

In order to support XATTR and to implement the correct behaviour, aufs
chooses the latter approach and introduces some new branch attributes,
"icexsec", "icexsys", "icextr", "icexusr", and "icexoth".
They correspond to the XATTR namespaces (see above). Additionally, to be
convenient, "icex" is also provided which means all "icex*" attributes
are set (here the word "icex" stands for "ignore copy-error on XATTR").

The meaning of these attributes is to ignore the error from setting
XATTR on that branch.
Note that aufs tries copying all XATTR unconditionally, and ignores the
error from the dst branch according to the specified attributes.
----------------------------------------

But recent nfs4 got changed its behaviour around ACL, and it didn't pass
my local tests.  I had posted about that, but got no reply.


J. R. Okajima
