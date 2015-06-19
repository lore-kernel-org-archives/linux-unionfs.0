From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] vfs: add seq_file_path() helper
Date: Fri, 19 Jun 2015 09:38:30 +0100
Message-ID: <5426.1434703110@warthog.procyon.org.uk>
References: <20150619083028.GC24181@tucsk> <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbbFSIif (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 04:38:35 -0400
In-Reply-To: <20150619083028.GC24181@tucsk>
Content-ID: <5425.1434703110.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Turn
> 	seq_path(..., &file->f_path, ...);
> into
> 	seq_file_path(..., file, ...);
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: David Howells <dhowells@redhat.com>
