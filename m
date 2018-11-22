From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Date: Thu, 22 Nov 2018 07:06:50 +0000
Message-ID: <20181122070650.GN32577@ZenIV.linux.org.uk>
References: <20181121024400.4346-1-devel@etsukata.com>
 <20181121045440.GM32577@ZenIV.linux.org.uk>
 <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Eiichi Tsukata <devel@etsukata.com>
Cc: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 22, 2018 at 02:40:50PM +0900, Eiichi Tsukata wrote:
> 2018年11月21日(水) 13:54 Al Viro <viro@zeniv.linux.org.uk>:
> >
> > On Wed, Nov 21, 2018 at 11:43:56AM +0900, Eiichi Tsukata wrote:
> > > Some file systems (including ext4, xfs, ramfs ...) have the following
> > > problem as I've described in the commit message of the 1/4 patch.
> > >
> > >   The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
> > >   removed almost all locks in llseek() including SEEK_END. It based on the
> > >   idea that write() updates size atomically. But in fact, write() can be
> > >   divided into two or more parts in generic_perform_write() when pos
> > >   straddles over the PAGE_SIZE, which results in updating size multiple
> > >   times in one write(). It means that llseek() can see the size being
> > >   updated during write().
> >
> > And?  Who has ever promised anything that insane?  write(2) can take an arbitrary
> > amount of time; another process doing lseek() on independently opened descriptor
> > is *not* going to wait for that (e.g. page-in of the buffer being written, which
> > just happens to be mmapped from a file on NFS over RFC1149 link).
> 
> Thanks.
> 
> The lock I added in NFS was nothing but slow down lseek() because a file size is
> updated atomically. Even `spin_lock(&inode->i_lock)` is unnecessary.
> 
> I'll fix the commit message which only refers to specific local file
> systems that use
> generic_perform_write() and remove unnecessary locks in some
> distributed file systems
> (e.g. nfs, cifs, or more) by replacing generic_file_llseek() with
> generic_file_llseek_unlocked()
> so that `tail` don't have to wait for avian carriers.

fd = open("/mnt/sloooow/foo", O_RDONLY);
p = mmap(NULL, 8192, PROT_READ, MAP_SHARED, fd, 0);
local_fd = open("/tmp/foo", O_RDWR);
write(local_fd, p, 8192);

and there you go - extremely slow write(2).  To file on a local filesystem.

Can you show me where does POSIX/SuS/whatever it's called these days promise
that kind of atomicity?  TBH, I would be very surprised if any Unix promised
to have file size updated no more than once per write(2).  Any userland code
that relies on such property is, as minimum, non-portable and I would argue
that it is outright broken.

Note, BTW, that your example depends upon rather non-obvious details of echo
implementation, starting with the bufferization logics used by particular
shell.  And AFAICS ash(1) ends up with possibility of more than one write(2)
anyway - get SIGSTOP delivered, followed by SIGCONT and you've got just that.
Transparently for echo(1).  I'm fairly sure that the same holds for anything
that isn't outright broken - write(2) *IS* interruptible (must be, for obvious
reasons) and that pair of signals will lead to short write if it comes at the
right time.  The only thing userland can do (and does) is to issue further
write(2) on anything that hadn't been written the last time around.
