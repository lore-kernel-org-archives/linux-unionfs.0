From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/7] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Mon, 11 Jul 2016 13:02:15 -0400
Message-ID: <20160711170215.GE7728@redhat.com>
References: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
 <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
 <2277404e-d91a-7190-ccbd-96e668ea95dd@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2277404e-d91a-7190-ccbd-96e668ea95dd@tycho.nsa.gov>
Sender: owner-linux-security-module@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jul 11, 2016 at 11:31:47AM -0400, Stephen Smalley wrote:

[..]
> > +static inline int security_inode_copy_up_xattr(const char *name)
> > +{
> > +	-EOPNOTSUPP;
> 
> return?

Yes, this one I fixed it in my patches now. kbuild also flagged this.

Vivek
