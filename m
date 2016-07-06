From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 5/5] overlayfs: Use vfs_getxattr_noperm() for real inode
Date: Wed, 6 Jul 2016 06:36:49 +0200
Message-ID: <CAJfpegv7Hd8VHt0-q44FGpucR5VfRDVviy6vpCVO2n4W85bTJg@mail.gmail.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-6-git-send-email-vgoyal@redhat.com> <b62a4ca9-3f75-b662-108b-1dec85c40ba1@schaufler-ca.com>
 <20160705211638.GH17987@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160705211638.GH17987@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, pmoore@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 5, 2016 at 11:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jul 05, 2016 at 01:29:39PM -0700, Casey Schaufler wrote:
>> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
>> > ovl_getxattr() currently uses vfs_getxattr() on realinode. This fails
>> > if mounter does not have DAC/MAC permission to access getxattr.
>> >
>> > Specifically this becomes a problem when selinux is trying to initialize
>> > overlay inode and does ->getxattr(overlay_inode). A task might trigger
>> > initialization of overlay inode and we will access real inode xattr in the
>> > context of mounter and if mounter does not have permissions, then inode
>> > selinux context initialization fails and inode is labeled as unlabeled_t.
>> >
>> > One way to deal with it is to let SELinux do getxattr checks both on
>> > overlay inode and underlying inode and overlay can call vfs_getxattr_noperm()
>> > to make sure when selinux is trying to initialize label on inode, it does
>> > not go through checks on lower levels and initialization is successful.
>> > And after inode initialization, SELinux will make sure task has getatttr
>> > permission.
>> >
>> > One issue with this approach is that it does not work for directories as
>> > d_real() returns the overlay dentry for directories and not the underlying
>> > directory dentry.
>> >
>> > Another way to deal with it to introduce another function pointer in
>> > inode_operations, say getxattr_noperm(), which is responsible to get
>> > xattr without any checks. SELinux initialization code will call this
>> > first if it is available on inode. So user space code path will call
>> > ->getxattr() and that will go through checks and SELinux internal
>> > initialization will call ->getxattr_noperm() and that will not
>> > go through checks.
>> >
>> > For now, I am just converting ovl_getxattr() to get xattr without
>> > any checks on underlying inode. That means it is possible for
>> > a task to get xattr of a file/dir on lower/upper through overlay mount
>> > while it is not possible outside overlay mount.
>> >
>> > If this is a major concern, I can look into implementing getxattr_noperm().
>>
>> This is a major concern.
>
> Hmm.., In that case I will write patch to provide another inode operation
> getxattr_noperm() and a wrapper which falls back to getxattr() if noperm
> variant is not defined. That should take care of this issue.

That's not going to fly.  A slighly better, but still quite ugly
solution would be to add a "flags" arg to the current ->getxattr()
callback indicating whether the caller wants permission checking
inside the call or not.

But we already have the current->creds.  Can't that be used to control
the permission checking done by the callback?

Thanks,
Miklos
