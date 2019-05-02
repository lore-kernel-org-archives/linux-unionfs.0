From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Thu, 2 May 2019 19:53:13 +0200
Message-ID: <CAHc6FU5fBorvOCkxvX58hEKmDgwu+-m_RDwEWDY36XpH1F03Hw@mail.gmail.com>
References: <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
 <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
 <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com>
 <20161206185806.GC31197@fieldses.org> <87bm0l4nra.fsf@notabene.neil.brown.name>
 <CAOQ4uxjYEjqbLcVYoUaPzp-jqY_3tpPBhO7cE7kbq63XrPRQLQ@mail.gmail.com>
 <875zqt4igg.fsf@notabene.neil.brown.name> <CAHc6FU52OCCGUnHXOCFTv1diP_5i4yZvF6fAth9=aynwS+twQg@mail.gmail.com>
 <CAJfpegsthQn_=3AQJf7ojxoQBpHMA3dz1fCBjNZXsCA1E0oqnw@mail.gmail.com>
 <CAHpGcML0KuoGSyXyyDnXHkSp3nDnSjJPeZeWEmt8CXxQeojxwg@mail.gmail.com> <20190502171603.GA1778@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190502171603.GA1778@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, NeilBrown <neilb@suse.com>, Amir Goldstein <amir73il@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, 2 May 2019 at 19:16, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, May 02, 2019 at 05:08:14PM +0200, Andreas Grünbacher wrote:
> > You'll still see permissions that differ from what the filesystem
> > enforces, and copy-up would change that behavior.
>
> That's always true, and this issue isn't really specific to NFSv4 ACLs
> (or ACLs at all), it already exists with just mode bits.  The client
> doesn't know how principals may be mapped on the server, doesn't know
> group membership, etc.
>
> That's the usual model, anyway.  Permissions are almost entirely the
> server's responsibility, and we just provide a few attributes to set/get
> those server-side permissions.

Sure, if the client and server don't share the same user and group
databases, ACLs can get a very different meaning.

Andreas

> The overlayfs/NFS case is different, I think: the nfs filesystem may be
> just a static read-only template for a filesystem that's only ever used
> by clients, and for all I know maybe permissions should only be
> interpreted on the client side in that case.
>
> --b.
