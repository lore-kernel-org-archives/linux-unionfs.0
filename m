From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [RFC 0/8] Xattr inode operation removal
Date: Tue, 3 May 2016 12:38:07 +0200
Message-ID: <CAHc6FU4mGL8KdnG7E3043CXpHYzZmX=A6n62G_iBor5zZC3fQg@mail.gmail.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
	<551ED650-CBF8-40D6-85A0-BDB3C281C247@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <551ED650-CBF8-40D6-85A0-BDB3C281C247@dilger.ca>
Sender: ecryptfs-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 3, 2016 at 1:23 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On May 2, 2016, at 4:45 PM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>>
>> Hi all,
>>
>> what are your thoughts on this patch set?  It applies on top of the
>> work.xattr branch [*], converts the remaining filesystems over to xattr
>> handlers, and replaces the getxattr, setxattr, and removexattr inode
>> operations.  The only way to implement getxattr, setxattr, and
>> removexattr with this approach is through xattr handlers.
>
> Maybe I'm missing the point of this patch, but is there a long-term benefit
> to this change?  It seems to be replacing the ->getxattr() and related inode
> methods with a generic ->xattr handler list that needs to be demultiplexed
> on each access?  Is there a net improvement in functionality that comes
> out the other end?

All filesystems except for things like overlayfs and fuse implement this kind of
multiplexing already, so we might as well make that the default.

I'm hoping that we can further clean things up on top to get rid of at
least some
of the name parsing in fs/xattr.c that has crept in over time; it's not pretty.

> That isn't at all clear from your comments or the
> patches themselves.  It seems that all of LOC savings is from deleting
> the .setxattr, .getxattr, and .removexattr lines from inode_operations
> but there is added complexity in the rest of the code?

Hmm, except for the rather trivial dummy dispatching for bad inodes, "empty"
directories, fuse, and overlayfs, here do you see increased complexity? The
indirection through the generic inode operations goes away, which isn't a bad
thing.

I agree that better documentation would help.

Thanks,
Andreas
