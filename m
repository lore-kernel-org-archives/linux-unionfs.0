From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 22/35] vfs: don't open real
Date: Tue, 15 May 2018 16:42:10 -0400
Message-ID: <20180515204210.GA26411@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
 <20180507083807.28792-23-mszeredi@redhat.com>
 <20180511185430.GE6044@redhat.com>
 <20180511194248.GF6044@redhat.com>
 <20180514135803.GA2777@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180514135803.GA2777@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, Paul Moore <pmoore@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 14, 2018 at 09:58:03AM -0400, Vivek Goyal wrote:

[..]
> Talked to Dan and he mentioned that he was trying to test entrypoint
> failure (and not exec failure) and that's whey he might have allowed exec
> to mounter.
> 
> I think that current entrypoint test's expectations are wrong.
> User process sees overlay inode lablel which is rwx_t and that means
> overlay layer will allow entrypoint into that executable. This will be the
> behavior on a normal file system where underlying file's label will be
> completely overridden by context=.
> 
> So in my opinion, we should modify testsuite and not run this test with
> context= mounts.

Miklos, now a fix has been merged to the tests so that test passes both with
current kernels and proposed changes.

https://github.com/SELinuxProject/selinux-testsuite/pull/36

Thanks Dan Walsh, Stephen Smalley and Paul More.

Vivek
