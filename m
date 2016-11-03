From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Thu, 3 Nov 2016 16:50:43 +0100
Message-ID: <CAJfpegs9zoTXiqaYV0=sQqXqD9_owqFiOkrwBkOrZ2yYpFEk2g@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161028161534.GM19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161028161534.GM19539@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 28, 2016 at 6:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Oct 25, 2016 at 09:34:47AM +0200, Miklos Szeredi wrote:
>> Current code returns EXDEV when a directory would need to be copied up to
>> move.  We could copy up the directory tree in this case, but there's
>> another solution: point to old lower directory from moved upper directory.
>>
>> This is achieved with a "trusted.overlay.redirect" xattr storing the path
>> relative to the root of the overlay.  After such attribute has been set,
>> the directory can be moved without further actions required.
>>
>> This is a backward incompatible feature, old kernels won't be able to
>> correctly mount an overlay containing redirected directories.
>
>> +                     err = vfs_path_lookup(lowerpath.dentry, lowerpath.mnt,
>> +                                           redirect, 0, &thispath);
>> +
>> +                     if (err) {
>> +                             if (err == -ENOENT || err == -ENAMETOOLONG)
>> +                                     this = NULL;
>> +                     } else {
>> +                             this = thispath.dentry;
>> +                             mntput(thispath.mnt);
>> +                             if (!this->d_inode) {
>> +                                     dput(this);
>> +                                     this = NULL;
>> +                             } else if (ovl_dentry_weird(this)) {
>> +                                     dput(this);
>> +                                     err = -EREMOTE;
>> +                             }
>> +                     }
>
> I'm not happy with that one - you are relying upon the fairly subtle
> assertions here.
>         1)  Had lowerpath.mnt *not* been a privately cloned one with nothing
> mounted on it, you would've been screwed.
>         2) Had that thing contained a "jumper" symlink (a-la procfs ones),
> you would've been screwed.  Currently only procfs has those, and it would've
> been rejected before getting there, but this is brittle and non-obvious.
>         3) Any automount point in there (nfs4 referrals, etc.) can
> break the assumption that nothing could've been mounted on it.  And _that_
> might have not been stepped onto; back when the path had been stored, there'd
> been no automount point at all, so we have avoided ovl_dentry_weird() rejects,
> and by now nothing on the path had been visited yet, so ovl_dentry_weird()
> didn't have a chance to trigger.  Note that calling it on the last dentry
> is no good - we might have crossed the automount point in the middle of that
> path, so this last dentry might be nice and shiny - and on another filesystem.
> So unlike (1) and (2) it's not just a fishy-looking thing that happens to
> work for non-local reasons; AFAICS, it's actually a bug.
>
> I'm not sure if vfs_path_lookup() is the right tool here.  It might be
> usable for making such a tool, but as it is you are setting one hell of
> a trap for yourself...

Agreed, it's not the right tool.   A custom loop of lookup_one_len's
should work much better and doesn't add all that much complexity.
Updated patch pushed to:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect

This version also passes the recycling tests by Amir and enables the
redirect feature by default on an empty upperdir.

Thanks,
Miklos
