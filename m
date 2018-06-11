From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Mon, 11 Jun 2018 09:09:04 +0200
Message-ID: <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180610041243.GJ30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 6:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 29, 2018 at 04:43:14PM +0200, Miklos Szeredi wrote:
>> Implement file operations on a regular overlay file.  The underlying file
>> is opened separately and cached in ->private_data.
>>
>> It might be worth making an exception for such files when accounting in
>> nr_file to confirm to userspace expectations.  We are only adding a small
>> overhead (248bytes for the struct file) since the real inode and dentry are
>> pinned by overlayfs anyway.
>>
>> This patch doesn't have any effect, since the vfs will use d_real() to find
>> the real underlying file to open.  The patch at the end of the series will
>> actually enable this functionality.
>
>> +static struct file *ovl_open_realfile(const struct file *file)
>> +{
>> +     struct inode *inode = file_inode(file);
>> +     struct inode *upperinode = ovl_inode_upper(inode);
>> +     struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
>> +     struct file *realfile;
>> +     const struct cred *old_cred;
>> +
>> +     old_cred = ovl_override_creds(inode->i_sb);
>> +     realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
>> +                          realinode, current_cred(), false);
>> +     revert_creds(old_cred);
>> +
>> +     pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
>> +              file, file, upperinode ? 'u' : 'l', file->f_flags,
>> +              realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
>> +
>> +     return realfile;
>> +}
>
> IDGI.  OK, you open a file in the layer you want; good, but why the hell do you
> *not* use the dentry/vfsmount from the same layer?
>
> IOW, why does your path_open() get an explicit inode argument at all?  With the
> rest of the work done in that series it looks like you should be able to use
> vfs_open() instead...  Sure, for ovlfs file you want ->f_path on overlayfs and
> not in a layer, but why do the same for those?

I'd really like to get there some time but...

List of basic requirements:

 - Private mmap of overlay file shares page cache with lower file (and
hence with all other overlays using the same lower file).

 - /proc/PID/maps shows correct path.

Thought about setting f_mapping/i_mapping of overlay file to that of
underlying file.  But that breaks when doing a copy-up.  We can't just
go and change those mapping pointers, assumption is that those remain
constant (we'd need READ_ONCE() for all cases where we use the mapping
more than once).  It's probably doable, but it's a large and fragile
change.

Thanks,
Miklos
