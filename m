MIME-Version: 1.0
In-Reply-To: <CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com>
References: <CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com>
Date: Thu, 11 Oct 2018 20:36:26 +0200
Message-ID: <CAJfpegvLg3xmvVAKyiqxa6T_x4D-3X10Oqkn5LxWQYXBCogOBg@mail.gmail.com>
Subject: Re: ovl: Ephemeral Mounts
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, ghartmann@netflix.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 5:28 PM, Sargun Dhillon <sargun@sargun.me> wrote:
> We recently upgraded our kernel from 4.9 to 4.18 and were surprised to
> find a behaviour change in overlayfs. Overlayfs now calls sync on the
> upper dir's superblock on shutdown. This causes all of our containers
> to stall out for a little bit.
>
> We run lots of ephemeral "containers" with overlayfs (Docker) on XFS.
> A given XFS filesystem could be host to 50+ containers. We block our
> users from calling syncfs on their overlayfs mount. Unfortunately, on
> filesystem shutdown, syncfs gets called on the overlayfs, which calls
> syncfs on the upperdir, causing a ton of I/O on the block device. This
> is useless, because all of the data they wrote to the upperdir is
> subsequently removed.
>
> We believe that we're not going to be the only ones surprised by this behaviour.
>
> Since we don't control shutdown of the mount namespace, and therefore
> control shutdown of the mount, it's not easy to add an ioctl to
> shutdown the filesystem cleanly, instead we need something at mount
> time we can use to indicate that syncfs shouldn't happen.
>
> I propose that we add a mount option "ephemeral" to the overlayfs
> mount which tells overlayfs to not syncfs at shutdown time.
>
> It might also be nice to extend this mount option to tell overlayfs to
> drop all syncfs calls, or return EIO.
>
> Does anyone else have any other suggestions?

I would guess tmpfs as upper layer might be a good fit when there's
lots of memory.  Tmpfs can also swap out data on memory pressure (not
dentries or inodes though).

Thanks,
Miklos
