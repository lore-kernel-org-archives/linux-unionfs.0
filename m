From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 4/4] locks: map correct ino/dev pairs when exporting to
 userspace
Date: Wed, 1 Aug 2018 17:45:56 +0000
Message-ID: <20180801174556.GD20761@wotan.suse.de>
References: <20180731211045.5671-1-mfasheh@suse.de>
 <20180731211045.5671-5-mfasheh@suse.de>
 <CAOQ4uxgQnO-nZxF51TLFF-+Lx+XmxgnN-6bHbvFNwLkGC3qNEg@mail.gmail.com>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgQnO-nZxF51TLFF-+Lx+XmxgnN-6bHbvFNwLkGC3qNEg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, overlayfs <linux-unionfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 01, 2018 at 08:37:31AM +0300, Amir Goldstein wrote:
> >         if (inode) {
> > +               __u64 ino;
> > +               dev_t dev;
> > +
> > +               vfs_map_unique_ino_dev(dentry, &ino, &dev);
> >                 /* userspace relies on this representation of dev_t */
> >                 seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> > -                               MAJOR(inode->i_sb->s_dev),
> > -                               MINOR(inode->i_sb->s_dev), inode->i_ino);
> > +                               MAJOR(dev), MINOR(dev), inode->i_ino);
> 
> Don't you mean ,ino); ?

Indeed I do, thanks for catching that one Amir.
	--Mark
