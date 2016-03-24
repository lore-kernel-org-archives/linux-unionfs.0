From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir,
 located on btrfs
Date: Thu, 24 Mar 2016 15:20:43 +0000
Message-ID: <20160324152043.GA22781@ZenIV.linux.org.uk>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io>
 <20151106031845.GV22011@ZenIV.linux.org.uk>
 <563C26AE.1020403@jeffm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <563C26AE.1020403@jeffm.io>
Sender: linux-btrfs-owner@vger.kernel.org
To: Jeff Mahoney <jeffm@jeffm.io>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 05, 2015 at 11:03:58PM -0500, Jeff Mahoney wrote:

> I suppose the irony here is that, AFAIK, that code is to ensure a file
> doesn't get lost between transactions due to rename.
> 
> Isn't the file->f_path.dentry relationship stable otherwise, though? The
> name might change and the parent might change but the dentry that the
> file points to won't.

Sure, it is stable.  But that doesn't guarantee anything about the
ancestors.

btrfs_log_inode_parent() is a mess.  Look at that loop you've got there:

       while (1) {
                if (!parent || d_really_is_negative(parent) || sb != d_inode(parent)->i_sb)
                        break;

Really?  NULL from dget_parent()?  A negative from dget_parent()?  Sodding
superblock changing from transition to parent?

                inode = d_inode(parent);
                if (root != BTRFS_I(inode)->root)
                        break;

Umm...  Something like crossing a snapshot boundary?

                if (BTRFS_I(inode)->generation > last_committed) {  
                        ret = btrfs_log_inode(trans, root, inode,
                                              LOG_INODE_EXISTS,
                                              0, LLONG_MAX, ctx);
                        if (ret)
                                goto end_trans;
                }
                if (IS_ROOT(parent))
                        break;

                parent = dget_parent(parent);
                dput(old_parent);
                old_parent = parent;
        }

Note that there's not a damn thing to guarantee that those directories have
anything to do with your file - race with rename(2) easily could've sent you
chasing the wrong chain of ancestors.  Incidentally, what will happen if
you do that fsync() to an unlinked file?  It still has ->d_parent pointing
to the what used to be its parent (quite possibly itself already rmdir'ed and
pinned down by that reference; inode is still busy, as if we'd done open and
rmdir).  Is that what those checks are attempting to catch?  And what happens
if rmdir happens between the check and btrfs_log_inode()?

The thing is, playing with ancestors of opened file is very easy to get
wrong, regardless of overlayfs involvement.  And this code is anything
but clear.  I don't know btrfs guts enough to be able to tell how much
can actually break (as opposed to adding wrong inodes to transaction),
but I would really suggest taking a good look at what's going on there...

> I did find a few other places where that assumption happens without any
> questionable traversals.  Sure, all three are in file systems unlikely
> to be used with overlayfs.
> 
> ocfs2_prepare_inode_for_write uses file->f_path.dentry for
> should_remove_suid (due to needing to do it early since cluster locking
> is unknown in setattr, according to the commit).  Having
> should_remove_suid operate on an inode would solve that easily.

Can't do - there are filesystems that _need_ dentry for ->setattr().

> cifs_new_fileinfo keeps a reference to the dentry but it seems to be
> used mostly to access the inode except for the nasty-looking call to
> build_path_from_dentry in cifs_reopen_file, which I won't be touching.
> That does look like a questionable traversal, especially with the "we
> can't take the rename lock here" comment.

cifs uses fs-root-relative pathnames in protocol; nothing to do there.
Where do you see that comment, BTW?  It uses read_seqbegin/read_seqretry
on rename_lock there...
