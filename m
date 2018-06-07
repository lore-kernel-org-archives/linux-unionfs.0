From: Ian Kent <raven@themaw.net>
Subject: Re: Exporting a unique ino/dev pair to user space
Date: Thu, 07 Jun 2018 19:31:15 +0800
Message-ID: <1528371075.2845.25.camel@themaw.net>
References: <20180606213807.GE9445@wotan.suse.de>
         <1528332448.2845.7.camel@themaw.net> <20180607020638.GF9445@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180607020638.GF9445@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Amir Goldstein <amir73il@gmail.com>, Jeff Mahoney <jeffm@suse.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, 2018-06-07 at 04:06 +0200, Mark Fasheh wrote:
> Hi Ian,
> 
> On Thu, Jun 07, 2018 at 08:47:28AM +0800, Ian Kent wrote:
> > On Wed, 2018-06-06 at 23:38 +0200, Mark Fasheh wrote:
> > > Hi,
> > 
> > I'm not sure I understand what the problem is.
> 
> I'll try to elaborate below.
> 
> 
> > > We have an inconsistency in how the kernel is exporting inode number /
> > > device pairs for user space. There's of course stat(2) and statx(2),
> > > but aside from those we simply dump inode->i_ino and super->s_dev. In
> > > some cases, the dumped values differ from what is returned via stat(2)
> > > or statx(2). Some filesystems might even show duplicate (but
> > > internally different!) pairs when the raw i_ino/s_dev is used.
> > 
> > How is it that you can dump the raw ino and s_dev if your not in
> > kernel code?
> 
> If you look below my first paragraph, you'll see a list of places where the
> kernel publishes (maybe that's a better word?) ino/dev pairs by printing or
> otherwise copying raw ino/s_dev values into user accesible buffers.
> 
> 
> > For stat family system calls, if the file system defines the inode
> > operation getattr it will be used to fill the stat structure otherwise
> > the VFS will fill the stat  structure and it will use inode->i_ino and
> > sb->s_dev as you say.
> 
> My concern is that those pairs are sometimes not unique and do not line up
> with what statx(2) returns. We actually need the true inode / device as is
> returned by statx in those places. I go into much more detail in my original
> mail.

IMHO I think you are right in that the values seen by user space
should be consistent.

I also think that vfs_statx() (which is pretty much what's called
by all the stat family system calls, and indirectly vfs_getattr)
should be the defining way to get those values if only because it's
core VFS and maintained by the VFS maintainer who should be the one
to set the rules.

But, as you say there are a bunch of places, not necessarily easy
to find, that would need review.

And there's the question of 32 bit .....

> 
> 
> > > Some examples where we dump raw ino/dev:
> > > 
> > > - /proc/<pid>/maps. I've written about how this confuses lsof(8):
> > >   https://marc.info/?l=linux-btrfs&m=130074451403261&w=2
> > > 
> > > - Unsurprisingly, many VFS tracepoints dump ino and/or dev. See
> > >   trace/events/lock.h or trace/events/writeback.h for examples.
> > > 
> > > - eventpoll also dumps the raw ino/dev pair via ep_show_fdinfo()
> > > 
> > > - Audit records the raw ino/dev and passes them around. We do seem to
> > >   have paths printed from audit as well, but if it's printed with the
> > >   wrong ino/dev pair I believe my point still stands.
> > > 
> > > 
> > > This breaks software which expects these pairs to be unique, and can
> > > put the user in a situation where they might not be able to find an
> > > inode referenced from the kernel. What's even worse - depending on how
> > > ino is exported, they might even find the *wrong* inode.
> 
> Thanks,
> 	--Mark
