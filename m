From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/7] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Mon, 11 Jul 2016 12:56:59 -0400
Message-ID: <20160711165659.GC7728@redhat.com>
References: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
 <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
 <2277404e-d91a-7190-ccbd-96e668ea95dd@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2277404e-d91a-7190-ccbd-96e668ea95dd@tycho.nsa.gov>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jul 11, 2016 at 11:31:47AM -0400, Stephen Smalley wrote:
> On 07/08/2016 12:19 PM, Vivek Goyal wrote:
> > Provide a security hook which is called when xattrs of a file are being
> > copied up. This hook is called once for each xattr and LSM can return 0
> > to access the xattr, 1 to reject xattr, -EOPNOTSUPP if none of the lsms
> > claim to know xattr and a negative error code if something went terribly
> > wrong.
> 
> 0 if the security module wants the xattr to be copied up, 1 if the
> security module wants the xattr to be discarded on the copy, -EOPNOTSUPP
> if the security module does not handle/manage the xattr, or a -errno
> upon an error.

Ok, will change the description.

> 
> > 
> > If 0 or -EOPNOTSUPP is returned, xattr will be copied up, if 1 is returned,
> > xattr will not be copied up and if negative error code is returned, copy up
> > will be aborted.
> 
> Not sure I understand the benefit of the 0 vs -EOPNOTSUPP distinction.

I am not sure either. Casey wanted to have four states so I introduced it. 

Thanks
Vivek
