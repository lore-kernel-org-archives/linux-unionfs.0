From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2] vfs: add file_path() helper
Date: Fri, 19 Jun 2015 09:49:09 +0100
Message-ID: <7199.1434703749@warthog.procyon.org.uk>
References: <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbbFSItO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 04:49:14 -0400
In-Reply-To: <20150619082913.GB24181@tucsk>
Content-ID: <7198.1434703749.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> +char *file_path(struct file *filp, char *buf, int buflen)
> +{
> +	return d_path(&filp->f_path, buf, buflen);
> +}
> +EXPORT_SYMBOL(file_path);

Inline it?

David
