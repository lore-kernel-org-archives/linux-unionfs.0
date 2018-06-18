From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Mon, 18 Jun 2018 15:43:45 -0400
Message-ID: <20180618194345.GA15973@redhat.com>
References: <20180618154222.19279-1-salyzyn@android.com>
 <20180618185448.GA8749@redhat.com>
 <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 18, 2018 at 12:18:25PM -0700, Mark Salyzyn wrote:
> On 06/18/2018 11:54 AM, Vivek Goyal wrote:
> > On Mon, Jun 18, 2018 at 08:42:15AM -0700, Mark Salyzyn wrote:
> > > All accesses to the lower filesystems reference the creator (mount)
> > > and not the source context.  This is a security issue.
> > Can you elaborate with an example that how this is a security issue.
> > mounter's check is in addition to caller's check. So we have two
> > checks in ovl_permission(). overlay inode gets the credentials from
> > underlying inode and we first check if caller is allowed to the
> > operation and if that's allowed, then we check if mounter is allowed
> > to do the operation.
> init which does the mount and represents the creator_cred which is granted a
> restricted MAC to do just what it needs to do, eg mount, but not be able to
> access the files. The caller comes in and is rejected because init domain is
> not allowed, even though the caller's domain is. MAC does not require
> overlap in privileges between the creator and the user.

[ CC dan walsh, stephen smalley ]

Ok. So this is not about security risk as such. It is more about that
it does not work in particular configuration where caller is allowed to
something but the mounter is not allowed to do that operation, so
operation fails.

(IIUC, recently this was raised as an issue if NFS is lower layer and
server is doing root squashing. Then root on client can do mount but might
not have access to a file while caller does have).

Will it be acceptable to write security policies in such a way so that
mounter has access as well.

Current model does assume that mounter has privileges on underlying files.

I think this works reasonably well with SELinux model of doing context
mounts. So if a "context=foo_label" mount is done, that changes labels
on overlay inodes (and ignore lables on disk). Mounter is the one allowing
this overriding. Now if we mounter allows this, then mounter should have
atleast access to underlying files. Otherwise this becomes equivalent
of that as long as mounter can do mount then it is providing access to
all files on disk/dir (with context mount). And mounter itself might not
be able to do those operations.

Core idea is, trying to make sure mounter of overlay does not provide
more priviliges to caller through a mount point if mounter itself does
not have privilege to do certain operations.

Another place it works well is that one does not have to provide
read/write labels on lower file. So in case of containers, SELinux can
just provide read labels to files in shared image dir, and as long
as mounter has read permission, it can copy up file and provide a writable
copy to the client. If we don't do mounter's check, that means caller
needs to have write permission to lower layer as well. And if caller
breaks out of container, it could directly write lower layer and attcking
another containers. So this was another use case in mind while coming
up with this model.

I am not saying that current model is the best way of doing things. Just
giving some context about why we thought it is a good idea.

Thanks
Vivek
