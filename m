From: Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [V9fs-developer] 9p/overlayfs: what inodes/dentries are safe to use?
Date: Tue, 13 Oct 2015 09:10:14 -0400
Message-ID: <CAFkjPTnPCTbJeEp819eeQQVVeWbp5U3kbj7gJUwRx4vX7UP_FQ@mail.gmail.com>
References: <CAJfpegurhotqht8apANWM1iWOw7YWb1oAcY6Nq7nKOp80jvTaQ@mail.gmail.com>
 <20151012174759.GA31768@nautica> <CAJfpegujzXb49saZWuNDHzrmfboCAhqx=daLY-b+9=HA93ZKjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33691 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbJMNKf (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 13 Oct 2015 09:10:35 -0400
Received: by obbbh8 with SMTP id bh8so12976109obb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Oct 2015 06:10:35 -0700 (PDT)
In-Reply-To: <CAJfpegujzXb49saZWuNDHzrmfboCAhqx=daLY-b+9=HA93ZKjw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Vincent Bernat <bernat@luffy.cx>, Dominique Martinet <dominique.martinet@cea.fr>, Latchesar Ionkov <lucho@ionkov.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, V9FS Developers <v9fs-developer@lists.sourceforge.net>, Ron Minnich <rminnich@sandia.gov>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Oct 12, 2015 at 11:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Oct 12, 2015 at 7:47 PM, Dominique Martinet
> <asmadeus@codewreck.org> wrote:
>> Miklos Szeredi wrote on Mon, Oct 12, 2015:
>>> The solution depends on how 9p handles hard links.  If any dentry will
>>> do then d_find_any_alias() will get you a dentry (any dentry) from the
>>> inode.
>>>
>>> Otherwise I know of no mechanism to get the backing dentry from the file.
>>
>> I've got two problems at the moment:
>>  - first, 9P stores informations in the superblock (accessed
>> through either dentry->d_sb->s_fs_info or inode->i_sb->...), and
>> operations such as read will get passed an inode and a file (which has a
>> dentry), but 9P doesn't know which to trust (if I go this right - if 9P
>> is underlay then the inode is 9p's, if 9P is overlay then the dentry
>> is ?)
>
> file->f_path shouldn't be trusted by filesystems for non-directories.  Ever.
>
> Solution to this particular problem?  Not sure.
>

It ends up being a very difficult problem.  At the heart of things it
has to do with no direct 1:1 mapping between 9P and VFS for the
concept of a fid, because a fid represents both open files and
transient pointers to locations in the file hierarchy.  To complicate
things, fids are technically per-user and have a good deal of state
associated with them including security context, position in a
multi-packet directory listing, etc.  To try and cope, I went with a
mix of attaching fids to inodes, dentries, and file pointers.  The
original concept was that file pointers were only for open files and
dentries were for transient location pointers.  The attachment to
inodes was originally for housekeeping, but more recently I was
looking at moving completely from dentries to inode based attachment
to try and solve the open-unlink-stat bug on the client side versus
making the server deal with it.

So, any dentry won't do, but we could try and traverse the fids
attached to an inode and guess which one is the right one by looking
at the ownership information and state within the fid.  This would
advocate hanging everything off of the inode instead of the
dentry/file.  Of course, I'd have to reliably get to 9P's inode -- but
I'm assuming by the time I get to it through whatever layers above it,
I should be able to resolve my inode.  It means a slightly worse
access time if you have lots of fids associated with an inode, but
maybe we can make that traversal more efficient if it actually
materializes as a performance constraint.  Its fairly heavy surgery,
but may solve some other problems -- of course, I'm worried it might
create other issues.

We can try a bit of a more complicated solution by being a bit more
paranoid about VFS structures and always keying the 9P structures.  If
private data doesn't match the 9P key then we fallback to some long
latency path to recover the required information....

thoughts?

        -eric
