From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode label [ver #2]
Date: Thu, 18 Jun 2015 19:22:30 +0100
Message-ID: <5836.1434651750@warthog.procyon.org.uk>
References: <5582FB01.9080602@tycho.nsa.gov> <1509.1434645664@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbbFRSWg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 14:22:36 -0400
In-Reply-To: <5582FB01.9080602@tycho.nsa.gov>
Content-ID: <5835.1434651750.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	rc = selinux_determine_inode_label(d_inode(dentry), name,
> 
> We want d_inode(dentry->d_parent) here.

Aargh.  I forgot to commit it.

David
