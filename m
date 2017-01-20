From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Fri, 20 Jan 2017 10:49:07 +0200
Message-ID: <CAOQ4uxjaFRXaHRmZSbBzSCDcL0HnNxCyVevjCPqoOROkse8wGw@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> I implemented freeze/thaw of overlayfs, because I need it for
> overlay snapshots (CoW decision is made before mnt_wat_write(upper)
> and I need to serialize it with snapshot take).
>
> Not sure if there are other use cases for overlayfs freeze??
>
> Tested freeze stress with xfstest generic/068 generic/390.
>
> While staring at the code, I realized that syncfs(2) for overlayfs
> seems broken.  It looks like only inodes are synced and upper fs
> metadata is not being flushed, but I could be wrong.
>
> Tested sync sanity with -g quick (although no test calls syncfs directly).
> Tested the usual unionmount sanity over xfs and over tmpfs.
>
> I am not sure exactly how to write a test case to verify this alleged
> breakage?
>

Well, I have a smoking gun.
Wrote this xfs specific test, which checks xfs stats after syncfs/fsync:
https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh

Good (on xfs 4.10.0-rc4):
# ./syncfs.sh /base/
before touch
xfs_log_force = 375
after touch
xfs_log_force = 375
after syncfs
xfs_log_force = 376
after fsync
xfs_log_force = 376
after fsync #2
xfs_log_force = 376

Bad (on overlayfs 4.10.0-rc4):
# ./syncfs.sh /mnt
before touch
xfs_log_force = 376
after touch
xfs_log_force = 376
after syncfs
xfs_log_force = 376
after fsync
xfs_log_force = 377
after fsync #2
xfs_log_force = 377

Overlayfs syncfs fails to flush the xfs log.

I'll see if I can put this test into xfstests.
I am going to need some sort of require_upper_fs_is_xfs
not sure id it already exists.

If anyone has suggestions how to write this test not xfs specific I
would be happy to hear.
Eryu?

Also, FYI, xfs_io -c syncfs is broken.
Going to send a fix patch soon.
