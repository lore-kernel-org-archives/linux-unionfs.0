From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Tue, 6 Dec 2016 11:08:32 +0100
Message-ID: <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
References: <5a6862bd-924d-25e4-2a8e-ba4f51e66604@web.de> <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com>
 <20161205151933.GA17517@fieldses.org> <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com>
 <20161205162559.GB17517@fieldses.org> <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com>
 <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de> <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com>
 <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Patrick Plagwitz <Patrick_Plagwitz@web.de>, "J. Bruce Fields" <bfields@fieldses.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 6, 2016 at 12:24 AM, Andreas Gr=C3=BCnbacher
<andreas.gruenbacher@gmail.com> wrote:
> 2016-12-06 0:19 GMT+01:00 Andreas Gr=C3=BCnbacher <andreas.gruenbacher@gm=
ail.com>:

>> It's not hard to come up with a heuristic that determines if a
>> system.nfs4_acl value is equivalent to a file mode, and to ignore the
>> attribute in that case. (The file mode is transmitted in its own
>> attribute already, so actually converting .) That way, overlayfs could
>> still fail copying up files that have an actual ACL. It's still an
>> ugly hack ...
>
> Actually, that kind of heuristic would make sense in the NFS client
> which could then hide the "system.nfs4_acl" attribute.

Even simpler would be if knfsd didn't send the attribute if not
necessary.  Looks like there's code actively creating the nfs4_acl on
the wire even if the filesystem had none:

    pacl =3D get_acl(inode, ACL_TYPE_ACCESS);
    if (!pacl)
        pacl =3D posix_acl_from_mode(inode->i_mode, GFP_KERNEL);

What's the point?

Thanks,
Miklos
