From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of() rather than direct cast
Date: Fri, 31 Oct 2014 10:18:27 +0000
Message-ID: <13508.1414750707@warthog.procyon.org.uk>
References: <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu> <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com> <20141030141004.28203.79687.stgit@warthog.procyon.org.uk> <5760.1414680426@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaJaKSg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 31 Oct 2014 06:18:36 -0400
In-Reply-To: <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu>
Content-ID: <13507.1414750707.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Subject: vfs: make first argument of dir_context.actor typed
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: David Howells <dhowells@redhat.com>
