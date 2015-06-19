From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 08:59:03 +0100
Message-ID: <20150619075903.GI17109@ZenIV.linux.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
 <20150619072015.GH17109@ZenIV.linux.org.uk>
 <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbbFSH7I (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 03:59:08 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 09:52:55AM +0200, Miklos Szeredi wrote:
> Brave.
> 
> What's going to happen to all those f_path.dentry uses where the
> filesystem thinks it's getting its own dentry?
> 
> > git grep f_path.dentry | wc -l
> 171

How many of those are not for directories *and* not in something like
CIFS or debugfs?
