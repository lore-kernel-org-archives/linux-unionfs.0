From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 4 Nov 2016 14:48:22 +0100
Message-ID: <CAJfpegs=u6vvM2pr48KOfRubruZwrVXUT3vWcTAknGJrt1nRDw@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161028161534.GM19539@ZenIV.linux.org.uk>
 <CAJfpegs9zoTXiqaYV0=sQqXqD9_owqFiOkrwBkOrZ2yYpFEk2g@mail.gmail.com> <CAOQ4uxgK9+Nwxtj9GCHp-fFg7Gsu0HMA2-MeguBJ=BWxQATWmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgK9+Nwxtj9GCHp-fFg7Gsu0HMA2-MeguBJ=BWxQATWmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 4, 2016 at 10:29 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> You did not address my comment about the 'stack' allocation overflow
> in ovl_lookup
> I believe the (possible) overflow is demonstrated by the following debug patch:

Oops, missed that.  Good spotting!

And there's more shit that unionfs-testsuite didn't discover (not even
involving multiple layers):

rm -rf /lower /upper /work
mkdir -p /lower/a/b/c /upper /work
mount -t overlay overlay -oupperdir=/upper,lowerdir=/lower,workdir=/work /mnt
mv /mnt/a /mnt/z
mv /mnt/z/b /mnt/q
ls /mnt/q
umount /mnt
mount -t overlay overlay -oupperdir=/upper,lowerdir=/lower,workdir=/work /mnt
ls /mnt/q
umount /mnt

Next update coming up...

Thanks,
Miklos
