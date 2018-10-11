Return-Path: <sargun@sargun.me>
MIME-Version: 1.0
From: Sargun Dhillon <sargun@sargun.me>
Date: Thu, 11 Oct 2018 08:28:06 -0700
Message-ID: <CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com>
Subject: ovl: Ephemeral Mounts
Content-Type: text/plain; charset="UTF-8"
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, ghartmann@netflix.com, miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

We recently upgraded our kernel from 4.9 to 4.18 and were surprised to
find a behaviour change in overlayfs. Overlayfs now calls sync on the
upper dir's superblock on shutdown. This causes all of our containers
to stall out for a little bit.

We run lots of ephemeral "containers" with overlayfs (Docker) on XFS.
A given XFS filesystem could be host to 50+ containers. We block our
users from calling syncfs on their overlayfs mount. Unfortunately, on
filesystem shutdown, syncfs gets called on the overlayfs, which calls
syncfs on the upperdir, causing a ton of I/O on the block device. This
is useless, because all of the data they wrote to the upperdir is
subsequently removed.

We believe that we're not going to be the only ones surprised by this behaviour.

Since we don't control shutdown of the mount namespace, and therefore
control shutdown of the mount, it's not easy to add an ioctl to
shutdown the filesystem cleanly, instead we need something at mount
time we can use to indicate that syncfs shouldn't happen.

I propose that we add a mount option "ephemeral" to the overlayfs
mount which tells overlayfs to not syncfs at shutdown time.

It might also be nice to extend this mount option to tell overlayfs to
drop all syncfs calls, or return EIO.

Does anyone else have any other suggestions?
