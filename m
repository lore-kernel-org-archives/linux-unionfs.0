From: James Morris <jmorris@namei.org>
Subject: Re: [RFC 4/8] evm: Turn evm_update_evmxattr into void function
Date: Wed, 4 May 2016 17:23:23 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1605041722290.13639@namei.org>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com> <1462229118-13123-5-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:46698 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbcEDHX4 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 4 May 2016 03:23:56 -0400
In-Reply-To: <1462229118-13123-5-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

On Tue, 3 May 2016, Andreas Gruenbacher wrote:

> The return value of evm_update_evmxattr is never used.

Perhaps it should be used, otherwise there are potential silent failure 
paths in the EVM code.


-- 
James Morris
<jmorris@namei.org>
