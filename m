From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2 15/18] xattr: Add __vfs_{get,set,remove}xattr
 helpers
Date: Wed, 25 May 2016 15:38:25 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1605251537060.13567@namei.org>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com> <1463742875-9836-16-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:47511 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbcEYFiu (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 May 2016 01:38:50 -0400
In-Reply-To: <1463742875-9836-16-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Fri, 20 May 2016, Andreas Gruenbacher wrote:

> Right now, various places in the kernel check for the existence of
> getxattr, setxattr, and removexattr inode operations and directly call
> those operations.  Switch to helper functions and test for the IOP_XATTR
> flag instead.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>


Acked-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<jmorris@namei.org>
