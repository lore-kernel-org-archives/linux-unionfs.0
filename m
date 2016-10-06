From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 15/16] xattr: Stop calling {get,set,remove}xattr inode
 operations
Date: Thu, 6 Oct 2016 22:27:57 +0100
Message-ID: <20161006212756.GK19539@ZenIV.linux.org.uk>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
 <1475164125-28635-16-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475164125-28635-16-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 29, 2016 at 05:48:44PM +0200, Andreas Gruenbacher wrote:
> In squashfs and sockfs, add ->set xattr handler operations so that the
> VFS can call ->set without a NULL check.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
> +	if (!handler->set)
>  		return -EOPNOTSUPP;

What's the point adding those ->set() instances?  You *do* check for
NULL ->set (which is cheaper than indirect call anyway, so it is the
right thing to do), so...
