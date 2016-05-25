From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2 10/18] evm: Turn evm_update_evmxattr into void
 function
Date: Wed, 25 May 2016 15:30:23 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1605251528430.13567@namei.org>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com> <1463742875-9836-11-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:47460 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbcEYFbk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 May 2016 01:31:40 -0400
In-Reply-To: <1463742875-9836-11-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Fri, 20 May 2016, Andreas Gruenbacher wrote:

> The return value of evm_update_evmxattr is never used.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

As I mentioned last time, the EVM code is silently ignoring errors here, 
and I'd prefer to see that fixed.

Mimi: any comment on this?



-- 
James Morris
<jmorris@namei.org>
