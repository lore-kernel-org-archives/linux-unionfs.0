From: Eiichi Tsukata <devel@etsukata.com>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Date: Thu, 22 Nov 2018 14:40:50 +0900
Message-ID: <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com>
References: <20181121024400.4346-1-devel@etsukata.com> <20181121045440.GM32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20181121045440.GM32577@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

2018=E5=B9=B411=E6=9C=8821=E6=97=A5(=E6=B0=B4) 13:54 Al Viro <viro@zeniv.li=
nux.org.uk>:
>
> On Wed, Nov 21, 2018 at 11:43:56AM +0900, Eiichi Tsukata wrote:
> > Some file systems (including ext4, xfs, ramfs ...) have the following
> > problem as I've described in the commit message of the 1/4 patch.
> >
> >   The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llse=
ek")
> >   removed almost all locks in llseek() including SEEK_END. It based on =
the
> >   idea that write() updates size atomically. But in fact, write() can b=
e
> >   divided into two or more parts in generic_perform_write() when pos
> >   straddles over the PAGE_SIZE, which results in updating size multiple
> >   times in one write(). It means that llseek() can see the size being
> >   updated during write().
>
> And?  Who has ever promised anything that insane?  write(2) can take an a=
rbitrary
> amount of time; another process doing lseek() on independently opened des=
criptor
> is *not* going to wait for that (e.g. page-in of the buffer being written=
, which
> just happens to be mmapped from a file on NFS over RFC1149 link).

Thanks.

The lock I added in NFS was nothing but slow down lseek() because a file si=
ze is
updated atomically. Even `spin_lock(&inode->i_lock)` is unnecessary.

I'll fix the commit message which only refers to specific local file
systems that use
generic_perform_write() and remove unnecessary locks in some
distributed file systems
(e.g. nfs, cifs, or more) by replacing generic_file_llseek() with
generic_file_llseek_unlocked()
so that `tail` don't have to wait for avian carriers.
