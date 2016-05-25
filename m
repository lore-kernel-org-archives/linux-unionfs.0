From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 10/18] evm: Turn evm_update_evmxattr into void
 function
Date: Wed, 25 May 2016 07:08:10 -0400
Message-ID: <1464174490.2763.146.camel@linux.vnet.ibm.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
	 <1463742875-9836-11-git-send-email-agruenba@redhat.com>
	 <alpine.LRH.2.20.1605251528430.13567@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58142 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcEYLK5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 May 2016 07:10:57 -0400
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 25 May 2016 21:10:55 +1000
In-Reply-To: <alpine.LRH.2.20.1605251528430.13567@namei.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Wed, 2016-05-25 at 15:30 +1000, James Morris wrote:
> On Fri, 20 May 2016, Andreas Gruenbacher wrote:
> 
> > The return value of evm_update_evmxattr is never used.
> > 
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> 
> As I mentioned last time, the EVM code is silently ignoring errors here, 
> and I'd prefer to see that fixed.

Agreed.   evm_update_evmxattr() is called as a result of a "protected"
xattr or some other file metadata having been modified.  The two actions
need to remain in sync, otherwise subsequent file access will be denied.
At the point that evm_update_evmxattr() fails, there isn't much that can
be done other than audit the failure.  The file metadata has already
been modified.

Mimi
