From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with
 file_{start,end}_write()
Date: Fri, 27 Jan 2017 08:31:41 -0800
Message-ID: <20170127163141.GG2584@birch.djwong.org>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com>
 <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com>
 <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com>
 <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, mfasheh@versity.com, linux-btrfs <linux-btrfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

[adding mfasheh & btrfs list to cc]

On Fri, Jan 27, 2017 at 06:20:12PM +0200, Amir Goldstein wrote:
> On Fri, Jan 27, 2017 at 1:50 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Fri, Jan 27, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Mon, Jan 23, 2017 at 8:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> Before calling write f_ops, call file_start_write() instead
> >>> of sb_start_write().
> >>>
> >>> This ensures freeze protection for both overlay and upper fs
> >>> when file is open from an overlayfs mount.
> >>>
> >>> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
> >>> for fallocate().
> >>>
> >>> For dedup_file_range() there is no need for mnt_want_write_file().
> >>> File is already open for write, so we already have mnt_want_write()
> >>> and we only need file_start_write().
> >>
> >> Being opened for write is not verified if capable(CAP_SYS_ADMIN).
> >> Ugly special case, don't ask me why it's done...
> >>
> >
> > Christoph, Darrick, is that by design?
> 
> Anyway, whether is makes sense or not, that's a legacy from
> BTRFS_IOC_FILE_EXTENT_SAME, we probably have to live with.
> 
> Michael, I recon man page needs updating.
> 
> I'll remove this hunk from the patch.

I /think/ that behavior (CAP_SYS_ADMIN not requiring destfd to be open
for writes in order to dedupe) was intentional; it seems to date back to
the original ioctl in 2013.  My guess of the justification is that we're
not really writing to dest, so if the admin comes along with an O_RDONLY
destfd it's ok?

<shrug> Let's see if we get any bites from the btrfs developers. :)

--D
