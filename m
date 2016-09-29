From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 05/16] sockfs: getxattr: Fail with -EOPNOTSUPP for
 invalid attribute names
Date: Thu, 29 Sep 2016 13:24:24 -0700
Message-ID: <20160929202424.GA9499@infradead.org>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
 <1475164125-28635-6-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46225 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755694AbcI2UY3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Sep 2016 16:24:29 -0400
Content-Disposition: inline
In-Reply-To: <1475164125-28635-6-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Thu, Sep 29, 2016 at 05:48:34PM +0200, Andreas Gruenbacher wrote:
> The standard return value for unsupported attribute names is
> -EOPNOTSUPP, as opposed to undefined but supported attributes
> (-ENODATA).
> 
> Also, fail for attribute names like "system.sockprotonameXXX" and
> simplify the code a bit.

The only sensible thing to do with this xattr abuse is to remove it
entirely..
