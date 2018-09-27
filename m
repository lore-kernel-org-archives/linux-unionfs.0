From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in path_openat
Date: Thu, 27 Sep 2018 11:26:56 +0300
Message-ID: <CAOQ4uxjfmE4Bd49kt7+kD7C=8g5ChN80LCOUDf9e3mqG=8Yrag@mail.gmail.com>
References: <00000000000044cbf80576baaecd@google.com> <CAJfpegsxLtDZqOpK68kGZU+qeEpA5gmAw-uigUKZorexU5i8BA@mail.gmail.com>
 <CAOQ4uxi7LjOVssduYEfbNnYd7ZbwB+hikd+P03_qPFHZeF_Phg@mail.gmail.com> <CAJfpegvEA4L-3SgoyF-Unt4rNZq6rX86Q4AVQBWBiqaWEqDP8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvEA4L-3SgoyF-Unt4rNZq6rX86Q4AVQBWBiqaWEqDP8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 27, 2018 at 9:36 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Sep 27, 2018 at 8:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > So this is interesting... if there is a file in overlayfs lower layer with
> > the f_op read = seq_read then &p->lock in the chain above could be
> > takes after ovl locks and that is in reveres order to the order of locks
> > in execve on an overlayfs file.
> >
> > On the one hand, it is possible (not sure if desirable) to use filesystems
> > with seq_file like debugfs as overlay lower fs, but on the other hand,
> > it is not possible to copy up a debugfs file with its original content
> > because (at least for most files I looked) the inode size is reported as 0.
> >
> > Also, from v4.19-rc1, with stacked f_op, ovl_read_iter() calls vfs_iter_read(),
> > so overlayfs is no longer tolerant to underlying files that implement f_op read
> > (and not read_iter), thus, it is no longer possible to read lower debugfs files.
> >
> > That said, if there are files in lower layer that user seq_read f_op and have
> > non zero inode size, the deadlock reported above might be possible.
> >
> > Miklos,
> >
> > What do you recon we should do?
> > Blacklist debugfs just like procfs was blacklisted from fs stacking?
> > Improve the heuristics of ovl_dentry_weird() to cover debugfs and friends?
>
> I think that's the best plan.  There doesn't seem to be any sense in
> supporting debugfs and similar weirdness as lower layer, so the best
> course of action would be to deny at the earilest possible point in
> time.
>

OK. I will leave to you to find the Weirdest Common Denominator
of debugfs and friends.
But there could also be a filesystem with sporadic special files
with seq_read (or no read_iter f_op), or maybe our Weird heuristics didn't
catch the filesystem.
We might want to block those files from being copied up on the grounds that
they cannot be read from overlay before copy up anyway.

Thanks,
Amir.
