From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL for 4.8] consolidate vfs API for overlayfs
Date: Thu, 30 Jun 2016 09:22:07 +0200
Message-ID: <CAJfpeguMumFdFy9unZkYfrmVfc-oibhspQKytNKRtoyi8-qhKQ@mail.gmail.com>
References: <20160628081810.GB2388@veci.piliscsaba.szeredi.hu> <20160629230952.GE14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160629230952.GE14480@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jun 30, 2016 at 1:09 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jun 28, 2016 at 10:18:10AM +0200, Miklos Szeredi wrote:
>> Hi Al,
>>
>> Please pull from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git d_real
>>
>> This consolidates the d_real/d_select_inode API as well as some documentation
>> cleanups.
>
> Two notes:
>
> 1) you have 4 places with identical "if DCACHE_OP_REAL is there,
> call ->d_real(dentry, ..., ...), otherwise return dentry".  And you have
> exactly one place where d_real() wrapper is called.  Looks like we would
> be better off with the calling conventions for wrapper updated as well.
>
> 2) while we can't turn dentry argument into const struct dentry * (due to
> ovl_copy_up()), could we at least do that to the inode one?
>
> IOW, how about this, on top of that branch?  Or fold it into the commit
> changing the arguments of ->d_real(), for that matter...

Makes sense.  Folded, updated doc and force pushed to the same branch.

Thanks,
Miklos
